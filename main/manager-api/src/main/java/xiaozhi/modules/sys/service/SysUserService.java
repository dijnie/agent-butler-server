package xiaozhi.modules.sys.service;

import xiaozhi.common.page.PageData;
import xiaozhi.common.service.BaseService;
import xiaozhi.modules.sys.dto.AdminPageUserDTO;
import xiaozhi.modules.sys.dto.PasswordDTO;
import xiaozhi.modules.sys.dto.SysUserDTO;
import xiaozhi.modules.sys.entity.SysUserEntity;
import xiaozhi.modules.sys.vo.AdminPageUserVO;

/**
 * System user
 */
public interface SysUserService extends BaseService<SysUserEntity> {

    SysUserDTO getByUsername(String username);

    SysUserDTO getByUserId(Long userId);

    void save(SysUserDTO dto);

    /**
     * Delete the specified user together with the associated devices and agents
     * 
     * @param ids
     */
    void deleteById(Long ids);

    /**
     * Verify whether the password change is allowed
     * 
     * @param userId      user id
     * @param passwordDTO parameters for verifying the password
     */
    void changePassword(Long userId, PasswordDTO passwordDTO);

    /**
     * Change the password directly, without verification
     * 
     * @param userId   user id
     * @param password password
     */
    void changePasswordDirectly(Long userId, String password);

    /**
     * Reset the password
     * 
     * @param userId user id
     * @return a randomly generated password that meets the rules
     */
    String resetPassword(Long userId);

    /**
     * Administrator paged user information
     * 
     * @param dto pagination search parameters
     * @return paged user list data
     */
    PageData<AdminPageUserVO> page(AdminPageUserDTO dto);

    /**
     * Batch update user status
     * 
     * @param status  user status
     * @param userIds array of user IDs
     */
    void changeStatus(Integer status, String[] userIds);

    /**
     * Get whether user registration is allowed
     * 
     * @return whether user registration is allowed
     */
    boolean getAllowUserRegister();
}
