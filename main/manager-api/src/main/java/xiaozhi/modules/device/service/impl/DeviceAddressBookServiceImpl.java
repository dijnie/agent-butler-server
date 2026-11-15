package xiaozhi.modules.device.service.impl;

import java.time.Instant;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.commons.lang3.StringUtils;
import org.springframework.context.annotation.Lazy;
import org.springframework.stereotype.Service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;

import cn.hutool.json.JSONUtil;
import xiaozhi.common.constant.Constant;
import xiaozhi.common.redis.RedisKeys;
import xiaozhi.common.redis.RedisUtils;
import xiaozhi.modules.device.dao.DeviceAddressBookDao;
import xiaozhi.modules.device.entity.DeviceAddressBookEntity;
import xiaozhi.modules.device.entity.DeviceEntity;
import xiaozhi.modules.device.service.DeviceAddressBookService;
import xiaozhi.modules.device.service.DeviceService;
import xiaozhi.modules.sys.service.SysParamsService;

@Service
public class DeviceAddressBookServiceImpl implements DeviceAddressBookService {

    private final DeviceAddressBookDao deviceAddressBookDao;
    private final RedisUtils redisUtils;
    private final DeviceService deviceService;
    private final SysParamsService sysParamsService;

    public DeviceAddressBookServiceImpl(DeviceAddressBookDao deviceAddressBookDao, RedisUtils redisUtils,
            @Lazy DeviceService deviceService, SysParamsService sysParamsService) {
        this.deviceAddressBookDao = deviceAddressBookDao;
        this.redisUtils = redisUtils;
        this.deviceService = deviceService;
        this.sysParamsService = sysParamsService;
    }

    @Override
    public List<DeviceAddressBookEntity> getAddressBookList(String macAddress) {
        List<DeviceAddressBookEntity> rows = assignUniqueAliases(deviceAddressBookDao.getAddressBookList(macAddress));
        // Names were computed in a fixed order; the frontend wants the most recently modified first, so put it back
        rows.sort(Comparator
                .comparing(DeviceAddressBookEntity::getUpdateDate, Comparator.nullsLast(Comparator.reverseOrder())));
        return rows;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Map<String, Map<String, String>> getAllAddressBooks() {
        Object cached = redisUtils.get(RedisKeys.getAddressBookKey());
        if (cached != null) {
            return (Map<String, Map<String, String>>) cached;
        }
        refreshCache();
        return (Map<String, Map<String, String>>) redisUtils.get(RedisKeys.getAddressBookKey());
    }

    @Override
    public Map<String, Object> callByNickname(String callerMac, String nickname, boolean isAnswer) {
        Map<String, Map<String, String>> allBooks = getAllAddressBooks();

        if (isAnswer) {
            return postToMqtt("/api/call/accept", Map.of("mac", callerMac), "Answer");
        }

        // Outgoing call mode
        Map<String, String> callerBook = allBooks.get(bookKey(callerMac));
        if (callerBook == null) {
            return errorResult("No device found with the remark '" + nickname + "'");
        }
        String targetMacWithPerm = callerBook.get(nickname);
        if (targetMacWithPerm == null) {
            return errorResult("No device found with the remark '" + nickname + "'");
        }
        String[] parts = targetMacWithPerm.split("\\|");
        String targetMac = parts[0];
        boolean hasPermission = parts.length > 1 && "1".equals(parts[1]);

        if (!hasPermission) {
            return errorResult("Call failed, you do not have permission to call this device");
        }

        // Get how the target device calls the caller
        Map<String, String> targetBook = allBooks.get(bookKey(targetMac));
        String callerNickname = null;
        if (targetBook != null) {
            callerNickname = targetBook.get(bookKey(callerMac));
        }
        if (StringUtils.isBlank(callerNickname)) {
            // The caller display name is the name of the caller's own device in the device table, not the other party's.
            // The name the other side gave the caller was already looked up in targetBook above.
            // Product-wise this is handled as "caller ID", so the address book's "do not copy the other party's private property" restriction is not applied here
            // This API has no logged-in user context; the ownership-checking lookup would return empty here, so only the lookup without the ownership check can be used
            DeviceEntity callerDevice = deviceService.getDeviceByMacAddress(callerMac);
            if (callerDevice != null) {
                callerNickname = callerDevice.getAlias();
            }
            if (StringUtils.isBlank(callerNickname)) {
                callerNickname = formatMacAsDeviceName(callerMac);
            }
        }

        return postToMqtt("/api/call/request",
                Map.of("caller_mac", callerMac, "target_mac", targetMac, "caller_nickname", callerNickname),
                "Call");
    }

    @Override
    public void refreshCache() {
        Map<String, Map<String, String>> result = new HashMap<>();
        List<DeviceAddressBookEntity> allRecords = assignUniqueAliases(deviceAddressBookDao.selectList(null));
        Map<String, String> reverseMap = new HashMap<>();

        for (DeviceAddressBookEntity entity : allRecords) {
            String macA = bookKey(entity.getMacAddress());
            String macB = bookKey(entity.getTargetMac());

            // Build the forward mapping: A's mapping for B, nickname -> macB|permission
            Map<String, String> book = result.computeIfAbsent(macA, k -> new HashMap<>());
            String permStr = (Boolean.TRUE.equals(entity.getHasPermission())) ? "1" : "0";
            book.put(entity.getAlias(), macB + "|" + permStr);

            // Build reverse records to look up what B calls A, using the same de-duplicated name so the two sides match
            reverseMap.put(macB + ":" + macA, entity.getAlias());
        }

        // Build the reverse mapping: B's mapping for A, macA -> nickname
        for (DeviceAddressBookEntity entity : allRecords) {
            String macA = bookKey(entity.getMacAddress());
            String macB = bookKey(entity.getTargetMac());
            String aliasBtoA = reverseMap.get(macA + ":" + macB);
            if (aliasBtoA != null && !aliasBtoA.isEmpty()) {
                result.computeIfAbsent(macB, k -> new HashMap<>());
                result.get(macB).put(macA, aliasBtoA);
            }
        }

        redisUtils.set(RedisKeys.getAddressBookKey(), result);
    }

    /**
     * Compute a non-duplicate name for each row and return a new sorted list with alias already written
     *
     * A nickname is an index within one person's address book; with duplicates the later one overwrites the earlier one, and calling by nickname reaches the wrong device.
     * The database already has duplicates: the tail-number names filled in for empty aliases have only 256 possible values, and an address book with a dozen
     * unnamed entries already collides. So both display and calling must go through this one,
     * otherwise the text the frontend shows and the name used when calling do not match, and the user cannot reach anyone by the name they tapped.
     * The passed-in list is not modified: it was just queried by the DAO and the caller still needs to use it in its own order
     */
    private List<DeviceAddressBookEntity> assignUniqueAliases(List<DeviceAddressBookEntity> rows) {
        // Naming depends on order to decide who gets the original name, and selectList has no order by, so the returned order is not guaranteed.
        // Sort once, so the same data yields the same result every time and the cache does not flip back and forth.
        // Sort by the normalized address: the same person is grouped together no matter which spelling is in the database,
        // and the next two comparators decide the order. target_mac does not repeat within one book (the primary key ensures it),
        // so the order is still fully fixed by these three keys and does not fall back to "following the order the database returns"
        List<DeviceAddressBookEntity> ordered = new ArrayList<>(rows);
        ordered.sort(Comparator
                .comparing((DeviceAddressBookEntity row) -> bookKey(row.getMacAddress()),
                        Comparator.nullsFirst(Comparator.naturalOrder()))
                // Permission is sorted before the address: on a name collision, the one whose owner allows calling me gets the original name first.
                // Sorting it later would have no effect: when the two addresses differ, the address decides who comes first,
                // the one without permission would still hold the original name, a call by the name the user sees in the frontend would hit it,
                // and the UI would only say no permission, with no way to get through
                .thenComparing(DeviceAddressBookEntity::getHasPermission,
                        Comparator.nullsLast(Comparator.reverseOrder()))
                .thenComparing(DeviceAddressBookEntity::getTargetMac, Comparator.nullsFirst(Comparator.naturalOrder())));

        Map<String, Set<String>> takenByOwner = new HashMap<>();
        for (DeviceAddressBookEntity row : ordered) {
            // alias is empty by default when the row is created; if the user gave no name it is empty. That is the default state, not an error.
            // Fill in a tail-number name instead; if the whole row were skipped the API would still return success but the other party could never call in
            String alias = StringUtils.isBlank(row.getAlias())
                    ? formatMacAsDeviceName(row.getTargetMac())
                    : row.getAlias();

            // The suffix style is kept consistent with generateUniqueAlias; no second naming rule
            Set<String> taken = takenByOwner.computeIfAbsent(bookKey(row.getMacAddress()), k -> new HashSet<>());
            String uniqueAlias = alias;
            int suffix = 1;
            while (taken.contains(uniqueAlias)) {
                uniqueAlias = alias + suffix++;
            }
            taken.add(uniqueAlias);
            row.setAlias(uniqueAlias);
        }
        return ordered;
    }

    @Override
    public void updateAlias(String macAddress, String targetMac, String alias) {
        String finalAlias = generateUniqueAlias(macAddress, targetMac, alias);
        deviceAddressBookDao.updateAlias(macAddress, targetMac, finalAlias);
        refreshCache();
    }

    @Override
    public void updatePermission(String macAddress, String targetMac, Boolean hasPermission) {
        deviceAddressBookDao.updatePermission(macAddress, targetMac, hasPermission);
        refreshCache();
    }

    @Override
    public void saveOrUpdate(String macAddress, String targetMac, String alias, Boolean hasPermission) {
        QueryWrapper<DeviceAddressBookEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("mac_address", macAddress).eq("target_mac", targetMac);
        DeviceAddressBookEntity record = deviceAddressBookDao.selectOne(wrapper);
        if (record == null) {
            DeviceAddressBookEntity entity = new DeviceAddressBookEntity();
            entity.setMacAddress(macAddress);
            entity.setTargetMac(targetMac);
            // If the caller gave no name, fall back to the tail-number name. The name the other party's device has in the control console is their private property,
            // and copying it into the caller's address book would leak someone else's nickname, so names of other people's devices are never taken from the device table
            if (StringUtils.isBlank(alias)) {
                // The device table name is used only when naming the caller's own device, which belongs to the caller anyway
                if (isOwnDevice(macAddress, targetMac)) {
                    // Use the lookup with the ownership check. The device table may hold two rows for the same MAC differing only in case,
                    // a lookup that allows only one row would throw TooManyResultsException on such data
                    // and crash the whole save API; take the first by id, so colliding rows do not raise an error
                    DeviceEntity ownDevice = deviceService.getOwnedDeviceByMacAddress(macAddress);
                    if (ownDevice != null && StringUtils.isNotBlank(ownDevice.getAlias())) {
                        alias = ownDevice.getAlias();
                    }
                }
                // The device is registered but the user never named it; alias is null from table creation, which is the default state,
                // not an error. Writing null here would make the cache refresh skip the whole row;
                // the API would still return success but the other party could never call in
                if (StringUtils.isBlank(alias)) {
                    alias = formatMacAsDeviceName(targetMac);
                }
            }
            // Check for duplicate names
            alias = generateUniqueAlias(macAddress, targetMac, alias);
            entity.setAlias(alias);
            entity.setHasPermission(hasPermission);
            deviceAddressBookDao.insertAddressBook(entity);
        } else {
            if (alias != null) {
                updateAlias(macAddress, targetMac, alias);
            }
            if (hasPermission != null) {
                deviceAddressBookDao.updatePermission(macAddress, targetMac, hasPermission);
            }
        }
        refreshCache();
    }

    @Override
    public void deleteByMacAddresses(List<String> macAddresses) {
        if (macAddresses == null || macAddresses.isEmpty()) {
            return;
        }
        deviceAddressBookDao.deleteByMacAddresses(macAddresses);
        refreshCache();
    }

    private Map<String, Object> errorResult(String message) {
        Map<String, Object> result = new HashMap<>();
        result.put("status", "error");
        result.put("message", message);
        return result;
    }

    private Map<String, Object> postToMqtt(String path, Map<String, Object> body, String action) {
        Map<String, Object> result = new HashMap<>();
        result.put("status", "error");

        String mqttGatewayUrl = sysParamsService.getValue("server.mqtt_manager_api", true);
        String mqttSignatureKey = sysParamsService.getValue(Constant.SERVER_MQTT_SECRET, true);

        if (StringUtils.isBlank(mqttGatewayUrl) || "null".equals(mqttGatewayUrl)
                || MqttGatewayAuthorization.isMissingSignatureKey(mqttSignatureKey)) {
            result.put("message", action + " failed, gateway configuration is missing");
            return result;
        }

        try {
            String url = "http://" + mqttGatewayUrl + path;
            String response = MqttGatewayAuthorization.postJson(
                    url,
                    JSONUtil.toJsonStr(body),
                    mqttSignatureKey,
                    Instant.now(),
                    5000);

            if (StringUtils.isNotBlank(response)) {
                Map<String, Object> gwResult = JSONUtil.parseObj(response);
                result.put("status", gwResult.get("status"));
                result.put("message", gwResult.get("message"));
            }
            return result;
        } catch (Exception e) {
            result.put("message", action + " failed, please try again later");
            return result;
        }
    }

    /**
     * The address key used as the owner in the address book
     *
     * <p>
     * Writing the cache, reading the cache and computing names all group by it, so the three places must use the same value. Miss one normalization and two rows of the same person
     * are treated as two people: each gets the same name, the latter overwrites the former when written into the same book, and a device simply disappears from the cache.
     * Such data really can appear in the database - the table is utf8mb4_0900_ai_ci and the primary key (mac_address, target_mac)
     * is case-insensitive; if owner differs only in case while target differs, the two rows do not collide
     */
    private static String bookKey(String macAddress) {
        return macAddress == null ? null : macAddress.toLowerCase();
    }

    /**
     * Whether the target device is the caller's own device
     *
     * <p>
     * MAC is case-insensitive; normalize by the address book key before comparing, consistent with comparisons elsewhere
     */
    private static boolean isOwnDevice(String macAddress, String targetMac) {
        return bookKey(macAddress) != null && bookKey(macAddress).equals(bookKey(targetMac));
    }

    private String formatMacAsDeviceName(String mac) {
        if (StringUtils.isBlank(mac) || mac.length() < 2) {
            return mac;
        }
        // MAC itself is case-insensitive; storing and querying both use the lowercased value.
        // Lowercase here too; otherwise the same address would yield two names on the two paths,
        // and the name seen after the data is moved to the control console could not reach anyone
        String lastTwo = mac.substring(mac.length() - 2).toLowerCase();
        return "尾号为" + lastTwo + "的设备";
    }

    private String generateUniqueAlias(String macAddress, String targetMac, String alias) {
        QueryWrapper<DeviceAddressBookEntity> wrapper = new QueryWrapper<>();
        wrapper.eq("mac_address", macAddress);
        List<DeviceAddressBookEntity> existing = deviceAddressBookDao.selectList(wrapper);
        List<String> existNames = existing.stream()
                .map(DeviceAddressBookEntity::getAlias)
                .filter(a -> a != null && !a.isEmpty())
                .collect(Collectors.toList());
        if (!existNames.contains(alias)) {
            return alias;
        }
        int suffix = 1;
        String newAlias;
        while (existNames.contains(newAlias = alias + suffix)) {
            suffix++;
        }
        return newAlias;
    }
}
