package xiaozhi.modules.device.service.impl;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicReference;

import org.apache.ibatis.exceptions.TooManyResultsException;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.mockito.MockedStatic;

import xiaozhi.common.constant.Constant;
import xiaozhi.common.redis.RedisKeys;
import xiaozhi.common.redis.RedisUtils;
import xiaozhi.modules.device.dao.DeviceAddressBookDao;
import xiaozhi.modules.device.entity.DeviceAddressBookEntity;
import xiaozhi.modules.device.entity.DeviceEntity;
import xiaozhi.modules.device.service.DeviceService;
import xiaozhi.modules.sys.service.SysParamsService;

class DeviceAddressBookServiceImplTest {

    private static final String MAC = "00:11:22:33:44:55";
    private static final String OTHER_MAC = "00:11:22:33:44:66";
    private static final String THIRD_MAC = "00:11:22:33:44:77";
    // An all-digit MAC is identical after case conversion, so it cannot produce two rows "differing only in case"
    private static final String HEX_MAC = "00:11:22:33:44:ab";

    @Test
    void newEntryUsesTheDedicatedAddressBookInsertMapping() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());

        service.saveOrUpdate(MAC, OTHER_MAC, "living-room", true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        DeviceAddressBookEntity entity = entityCaptor.getValue();
        assertEquals(MAC, entity.getMacAddress());
        assertEquals(OTHER_MAC, entity.getTargetMac());
        assertEquals("living-room", entity.getAlias());
        assertTrue(entity.getHasPermission());
        verify(addressBookDao, never()).insert(any(DeviceAddressBookEntity.class));
    }

    @Test
    void blankAliasOnUnregisteredTargetFallsBackToMacSuffix() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        when(deviceService.getOwnedDeviceByMacAddress(anyString())).thenReturn(null);

        service.saveOrUpdate(MAC, OTHER_MAC, null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        DeviceAddressBookEntity entity = entityCaptor.getValue();
        assertNotNull(entity.getAlias());
        assertEquals("尾号为66的设备", entity.getAlias());
        assertTrue(entity.getHasPermission());
        verify(deviceService, never()).getOwnedDeviceByMacAddress(anyString());
    }

    @Test
    void blankAliasOnAnotherDeviceFallsBackToMacSuffixWithoutAskingTheDeviceTable() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        DeviceEntity registered = new DeviceEntity();
        registered.setMacAddress(OTHER_MAC);
        registered.setAlias(null);
        when(deviceService.getDeviceByMacAddress(OTHER_MAC)).thenReturn(registered);
        when(deviceService.getOwnedDeviceByMacAddress(OTHER_MAC)).thenReturn(registered);

        service.saveOrUpdate(MAC, OTHER_MAC, null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("尾号为66的设备", entityCaptor.getValue().getAlias(),
                "A registered but unnamed device gets an empty name, the cache refresh skips this row, and the other party can never call in");
        verify(deviceService, never()).getDeviceByMacAddress(anyString());
        verify(deviceService, never()).getOwnedDeviceByMacAddress(anyString());
    }

    @Test
    void blankAliasOnRegisteredTargetDoesNotTakeOverTheirNickname() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        DeviceEntity theirs = new DeviceEntity();
        theirs.setMacAddress(OTHER_MAC);
        theirs.setAlias("老王的音响");
        when(deviceService.getDeviceByMacAddress(OTHER_MAC)).thenReturn(theirs);
        when(deviceService.getOwnedDeviceByMacAddress(OTHER_MAC)).thenReturn(theirs);

        service.saveOrUpdate(MAC, OTHER_MAC, null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("尾号为66的设备", entityCaptor.getValue().getAlias(),
                "The name the other party gave this device in the control console was copied into the caller's address book");
        verify(deviceService, never()).getDeviceByMacAddress(anyString());
        verify(deviceService, never()).getOwnedDeviceByMacAddress(anyString());
    }

    @Test
    void blankAliasOnOwnDeviceUsesTheNameFromItsOwnDeviceRow() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        DeviceEntity mine = new DeviceEntity();
        mine.setMacAddress(MAC);
        mine.setAlias("我的书房");
        when(deviceService.getOwnedDeviceByMacAddress(MAC)).thenReturn(mine);

        service.saveOrUpdate(MAC, MAC, null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("我的书房", entityCaptor.getValue().getAlias(),
                "When naming one's own device, the name in one's own device table is used");
    }

    @Test
    void ownDeviceWithoutAliasInDeviceTableFallsBackToMacSuffix() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        DeviceEntity mine = new DeviceEntity();
        mine.setMacAddress(MAC);
        mine.setAlias(null);
        when(deviceService.getOwnedDeviceByMacAddress(MAC)).thenReturn(mine);

        service.saveOrUpdate(MAC, MAC, null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("尾号为55的设备", entityCaptor.getValue().getAlias(),
                "One's own device has no name in the device table either; with an empty name the cache refresh would skip this row");
    }

    @Test
    void duplicateDeviceRowsDifferingOnlyInCaseDoNotBreakNaming() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        // The device table has two rows for the same MAC differing only in case; a lookup that allows only one row throws directly
        when(deviceService.getDeviceByMacAddress(anyString()))
                .thenThrow(new TooManyResultsException("selectOne hit two rows differing only in case"));
        DeviceEntity first = new DeviceEntity();
        first.setMacAddress(MAC);
        first.setAlias("我的书房");
        when(deviceService.getOwnedDeviceByMacAddress(MAC)).thenReturn(first);

        assertDoesNotThrow(() -> service.saveOrUpdate(MAC, MAC, null, true),
                "When the same MAC has two rows differing only in case, naming must not crash the whole API");

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("我的书房", entityCaptor.getValue().getAlias(),
                "On colliding rows, the name of the first row by id is used");
    }

    @Test
    void ownDeviceIsRecognizedWhateverCaseTheAddressIsWrittenIn() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        DeviceEntity mine = new DeviceEntity();
        mine.setMacAddress(HEX_MAC);
        mine.setAlias("我的书房");
        when(deviceService.getOwnedDeviceByMacAddress(HEX_MAC)).thenReturn(mine);

        service.saveOrUpdate(HEX_MAC, HEX_MAC.toUpperCase(), null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("我的书房", entityCaptor.getValue().getAlias(),
                "The same address written in two different cases was treated as someone else's device");
    }

    @Test
    void explicitAliasIsKeptAsIs() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());

        service.saveOrUpdate(MAC, OTHER_MAC, "客厅", true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("客厅", entityCaptor.getValue().getAlias(),
                "Naming someone else's device oneself is the purpose of the address book and must not be changed by the fallback logic");
        verify(deviceService, never()).getDeviceByMacAddress(anyString());
        verify(deviceService, never()).getOwnedDeviceByMacAddress(anyString());
    }

    @Test
    void blankAliasOnUnregisteredTargetDoesNotBlowUp() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        when(deviceService.getOwnedDeviceByMacAddress(anyString())).thenReturn(null);

        assertDoesNotThrow(() -> service.saveOrUpdate(MAC, OTHER_MAC, null, true),
                "When the target device is not registered the API must return normally and must not throw");

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("尾号为66的设备", entityCaptor.getValue().getAlias());
    }

    @Test
    void refreshCacheKeepsEntriesWhoseAliasWasNeverFilledIn() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        when(addressBookDao.selectList(null)).thenReturn(List.of(row(MAC, OTHER_MAC, null)));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        service.refreshCache();

        Map<String, String> book = cachedBook(service, redisUtils).get(MAC);
        assertNotNull(book, "The whole row was skipped for an empty alias, so this device can never be called again");
        assertEquals(OTHER_MAC + "|1", book.get("尾号为66的设备"));
    }

    @Test
    void refreshCacheDisambiguatesTwoEntriesSharingAnAlias() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        when(addressBookDao.selectList(null)).thenReturn(List.of(
                row(MAC, OTHER_MAC, "客厅"),
                row(MAC, THIRD_MAC, "客厅")));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        service.refreshCache();

        Map<String, String> book = cachedBook(service, redisUtils).get(MAC);
        assertEquals(2, book.size(), "Only one of the two devices with colliding names survived: " + book);
        assertEquals(OTHER_MAC + "|1", book.get("客厅"));
        assertEquals(THIRD_MAC + "|1", book.get("客厅1"));
    }

    @Test
    void refreshCacheGivesTheSameResultWhateverOrderRowsComeBackIn() {
        DeviceAddressBookEntity first = row(MAC, OTHER_MAC, "客厅");
        DeviceAddressBookEntity second = row(MAC, THIRD_MAC, "客厅");

        Map<String, String> inOrder = refreshAndRead(List.of(first, second));
        Map<String, String> reversed = refreshAndRead(List.of(second, first));

        assertEquals(inOrder, reversed, "The same data gave different results on two refreshes; the names in the cache would flip back and forth");
    }

    /**
     * The database can hold two rows whose owner differs only in case: the table is utf8mb4_0900_ai_ci,
     * the primary key (mac_address, target_mac) is case-insensitive, and rows do not collide when target differs.
     * This is the same person; computing names and writing the cache must both merge them into one book by lowercase
     */
    @Test
    void ownersDifferingOnlyInCaseShareOneBook() {
        String upper = HEX_MAC.toUpperCase();
        assertNotEquals(HEX_MAC, upper, "This case is only valid if a real case difference is produced");

        Map<String, Map<String, String>> books = refreshAndReadAll(List.of(
                row(upper, OTHER_MAC, "客厅"),
                row(HEX_MAC, THIRD_MAC, "客厅")));

        Map<String, String> book = books.get(HEX_MAC);
        assertNotNull(book, "The same person was counted as two people: " + books.keySet());
        assertEquals(2, book.size(), "Only one of the two devices is left; the other disappeared from the cache: " + book);
        assertEquals(OTHER_MAC + "|1", book.get("客厅"));
        assertEquals(THIRD_MAC + "|1", book.get("客厅1"));
        assertEquals(1, books.size(), "The two spellings of the address were split into two books: " + books.keySet());
    }

    @Test
    void listAndCacheAgreeWhenOwnersDifferOnlyInCase() {
        String upper = HEX_MAC.toUpperCase();
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        when(addressBookDao.getAddressBookList(upper)).thenReturn(new ArrayList<>(List.of(
                row(upper, OTHER_MAC, "客厅"), row(HEX_MAC, THIRD_MAC, "客厅"))));
        when(addressBookDao.selectList(null)).thenReturn(List.of(
                row(upper, OTHER_MAC, "客厅"), row(HEX_MAC, THIRD_MAC, "客厅")));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        Map<String, String> shownToConsole = namesByTargetMac(service.getAddressBookList(upper));
        assertEquals(2, shownToConsole.size(),
                "The API groups by the raw value, the two devices of the same person are counted as one, and the frontend sees only one: " + shownToConsole);

        service.refreshCache();
        Map<String, String> callableNames = new HashMap<>();
        cachedBook(service, redisUtils).get(HEX_MAC)
                .forEach((name, macAndPerm) -> callableNames.put(name, macAndPerm.split("\\|")[0]));

        assertEquals(shownToConsole, callableNames,
                "The API groups by the raw value and the cache by lowercase; a call by the name the user sees in the frontend does not hit the same device");
    }

    @Test
    void nameAssignmentDoesNotDependOnWhichSpellingOfTheOwnerCameBack() {
        String upper = HEX_MAC.toUpperCase();
        Map<String, String> expected = Map.of("客厅", OTHER_MAC + "|1", "客厅1", THIRD_MAC + "|1");

        Map<String, String> lowerFirst = refreshAndRead(HEX_MAC, List.of(
                row(HEX_MAC, OTHER_MAC, "客厅"), row(upper, THIRD_MAC, "客厅")));
        Map<String, String> upperFirst = refreshAndRead(HEX_MAC, List.of(
                row(upper, THIRD_MAC, "客厅"), row(HEX_MAC, OTHER_MAC, "客厅")));

        assertEquals(expected, lowerFirst,
                "The same person's names depend on which spelling the database returns first, and change on every refresh");
        assertEquals(expected, upperFirst, "With the order reversed the result should differ: " + upperFirst);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Map<String, String>> refreshAndReadAll(List<DeviceAddressBookEntity> rows) {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        when(addressBookDao.selectList(null)).thenReturn(rows);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        service.refreshCache();

        return cachedBook(service, redisUtils);
    }

    private Map<String, String> refreshAndRead(List<DeviceAddressBookEntity> rows) {
        return refreshAndRead(MAC, rows);
    }

    private Map<String, String> refreshAndRead(String owner, List<DeviceAddressBookEntity> rows) {
        return refreshAndReadAll(rows).get(owner);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Map<String, String>> cachedBook(DeviceAddressBookServiceImpl service, RedisUtils redisUtils) {
        ArgumentCaptor<Object> captor = ArgumentCaptor.forClass(Object.class);
        verify(redisUtils).set(eq(RedisKeys.getAddressBookKey()), captor.capture());
        return (Map<String, Map<String, String>>) captor.getValue();
    }

    private DeviceAddressBookEntity row(String macAddress, String targetMac, String alias) {
        return row(macAddress, targetMac, alias, Boolean.TRUE);
    }

    private DeviceAddressBookEntity row(String macAddress, String targetMac, String alias, Boolean hasPermission) {
        DeviceAddressBookEntity entity = new DeviceAddressBookEntity();
        entity.setMacAddress(macAddress);
        entity.setTargetMac(targetMac);
        entity.setAlias(alias);
        entity.setHasPermission(hasPermission);
        return entity;
    }

    @Test
    void listAndCacheHandOutTheSameNameForCollidingEntries() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        // Each of the two DAO calls gets fresh rows: naming writes back to the entities, so with shared rows the second pass would read already-computed names
        // Use a mutable list, consistent with what MyBatis actually returns, so the sort step does not blow up first and leave the assertions unreached
        when(addressBookDao.getAddressBookList(MAC)).thenReturn(
                new ArrayList<>(List.of(row(MAC, OTHER_MAC, "客厅"), row(MAC, THIRD_MAC, "客厅"))));
        when(addressBookDao.selectList(null)).thenReturn(List.of(
                row(MAC, OTHER_MAC, "客厅"), row(MAC, THIRD_MAC, "客厅")));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        Map<String, String> shownToConsole = namesByTargetMac(service.getAddressBookList(MAC));
        service.refreshCache();
        Map<String, String> callableNames = new HashMap<>();
        cachedBook(service, redisUtils).get(MAC)
                .forEach((name, macAndPerm) -> callableNames.put(name, macAndPerm.split("\\|")[0]));

        assertEquals(callableNames, shownToConsole,
                "The API and the cache give two different names; a call by the name the user sees in the frontend does not hit the same device");
    }

    @Test
    void theCallableEntryKeepsThePlainNameWhenTwoCollide() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        // OTHER_MAC's target_mac sorts first, so the row without permission would take the original name first
        when(addressBookDao.selectList(null)).thenReturn(List.of(
                row(MAC, OTHER_MAC, "客厅", Boolean.FALSE),
                row(MAC, THIRD_MAC, "客厅", Boolean.TRUE)));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        service.refreshCache();

        Map<String, String> book = cachedBook(service, redisUtils).get(MAC);
        assertEquals(THIRD_MAC + "|1", book.get("客厅"),
                "The callable device was pushed to the suffixed name; when the user taps the name shown in the frontend, the UI only says no permission");
        assertEquals(OTHER_MAC + "|0", book.get("客厅1"));
    }

    @Test
    void listFillsInBlankAliasesSoTheConsoleShowsWhatCanBeCalled() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        when(addressBookDao.getAddressBookList(MAC)).thenReturn(new ArrayList<>(List.of(row(MAC, OTHER_MAC, null))));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        List<DeviceAddressBookEntity> rows = service.getAddressBookList(MAC);

        assertEquals("尾号为66的设备", rows.get(0).getAlias(),
                "If an empty alias is returned as is, the frontend falls back to showing the device name, but a call by that name only says the remark was not found");
    }

    @Test
    void anUppercaseMacGetsTheSameNameWhicheverPathAddsItToTheBook() {
        // The fallback name has only this one algorithm: it is computed once when stored, and afterwards the API and the cache
        // show the same string. Without lowercasing too, the same address yields two names on the two paths,
        // and a call by the name the user sees does not hit the device they just saved
        //
        // The runtime side: saveOrUpdate is passed the address exactly as it came in the DTO, with case not normalized
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        when(addressBookDao.selectOne(any())).thenReturn(null);
        when(addressBookDao.selectList(null)).thenReturn(List.of());
        when(deviceService.getOwnedDeviceByMacAddress(anyString())).thenReturn(null);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, mock(SysParamsService.class));

        service.saveOrUpdate(MAC, "ff:ee:dd:cc:bb:AB", null, true);

        ArgumentCaptor<DeviceAddressBookEntity> entityCaptor = ArgumentCaptor.forClass(DeviceAddressBookEntity.class);
        verify(addressBookDao).insertAddressBook(entityCaptor.capture());
        assertEquals("尾号为ab的设备", entityCaptor.getValue().getAlias(),
                "MAC is case-insensitive, so the last two characters must be lowercased too; otherwise the names computed by the API and the calling side do not match");
    }

    /**
     * The API puts the most recently modified first
     *
     * <p>
     * The control console Vue page merges alias into allDevices by targetMac, discarding the API order,
     * so this currently has no effect on the console. The case stays to pin down this contract: if it is ever deleted as dead code,
     * a case will report it instead of the API's return order changing silently
     */
    @Test
    void listPutsTheMostRecentlyTouchedEntryFirst() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceAddressBookEntity older = row(MAC, OTHER_MAC, "客厅");
        older.setUpdateDate(new Date(1767321840000L));
        DeviceAddressBookEntity newer = row(MAC, THIRD_MAC, "书房");
        newer.setUpdateDate(new Date(1778000000000L));
        DeviceAddressBookEntity neverTouched = row(MAC, "00:11:22:33:44:88", "阳台");
        when(addressBookDao.getAddressBookList(MAC)).thenReturn(
                new ArrayList<>(List.of(older, neverTouched, newer)));
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, mock(DeviceService.class), mock(SysParamsService.class));

        List<DeviceAddressBookEntity> rows = service.getAddressBookList(MAC);

        assertEquals(List.of("书房", "客厅", "阳台"), rows.stream().map(DeviceAddressBookEntity::getAlias).toList(),
                "The most recently modified should come first, and the never-modified last");
    }


    private Map<String, String> namesByTargetMac(List<DeviceAddressBookEntity> rows) {
        Map<String, String> byAlias = new HashMap<>();
        for (DeviceAddressBookEntity row : rows) {
            byAlias.put(row.getAlias(), row.getTargetMac());
        }
        return byAlias;
    }

    @Test
    void callByNicknameFallsBackToMacSuffixWhenCallerHasNoAlias() {
        DeviceAddressBookDao addressBookDao = mock(DeviceAddressBookDao.class);
        RedisUtils redisUtils = mock(RedisUtils.class);
        DeviceService deviceService = mock(DeviceService.class);
        SysParamsService sysParamsService = mock(SysParamsService.class);
        DeviceAddressBookServiceImpl service = new DeviceAddressBookServiceImpl(
                addressBookDao, redisUtils, deviceService, sysParamsService);

        Map<String, Map<String, String>> books = new HashMap<>();
        Map<String, String> callerBook = new HashMap<>();
        callerBook.put("office", OTHER_MAC + "|1");
        books.put(MAC, callerBook);
        when(redisUtils.get(RedisKeys.getAddressBookKey())).thenReturn(books);
        when(deviceService.getDeviceByMacAddress(MAC)).thenReturn(null);
        when(sysParamsService.getValue("server.mqtt_manager_api", true)).thenReturn("127.0.0.1:1883");
        when(sysParamsService.getValue(Constant.SERVER_MQTT_SECRET, true)).thenReturn("gateway-key");

        // The gateway is a real http call; stub it, otherwise the test would send a real request to 127.0.0.1:1883
        AtomicReference<String> sentUrl = new AtomicReference<>();
        AtomicReference<String> sentBody = new AtomicReference<>();
        Map<String, Object> result;
        try (MockedStatic<MqttGatewayAuthorization> gateway = mockStatic(MqttGatewayAuthorization.class)) {
            gateway.when(() -> MqttGatewayAuthorization.postJson(
                            anyString(), anyString(), anyString(), any(), anyInt()))
                    .thenAnswer(invocation -> {
                        sentUrl.set(invocation.getArgument(0));
                        sentBody.set(invocation.getArgument(1));
                        return "{\"status\":\"success\",\"message\":\"ok\"}";
                    });
            result = service.callByNickname(MAC, "office", false);
        }

        assertEquals("success", result.get("status"));
        assertEquals("http://127.0.0.1:1883/api/call/request", sentUrl.get());
        assertTrue(sentBody.get().contains("尾号为55的设备"),
                "When the caller is neither registered nor named, it should fall back to the tail-number name: " + sentBody.get());
    }
}
