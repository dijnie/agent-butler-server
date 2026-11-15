package xiaozhi.modules.sys.service;


import java.util.function.Consumer;

/**
 * Defines a system user utility class to avoid a circular dependency with the user module
 * E.g. users and devices depend on each other: a user needs to get all devices, and a device needs the username of each device
 * @author zjy
 * @since 2025-4-2
 */
public interface SysUserUtilService {
    /**
     * Assign the username
     * @param userId user id
     * @param setter setter method
     */
    void assignUsername( Long userId, Consumer<String> setter);
}
