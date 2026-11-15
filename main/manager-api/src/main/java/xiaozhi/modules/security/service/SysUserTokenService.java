package xiaozhi.modules.security.service;

import xiaozhi.common.page.TokenDTO;
import xiaozhi.common.service.BaseService;
import xiaozhi.common.utils.Result;
import xiaozhi.modules.security.entity.SysUserTokenEntity;
import xiaozhi.modules.sys.dto.PasswordDTO;
import xiaozhi.modules.sys.dto.SysUserDTO;

/**
 * User Token
 * Copyright (c) Renren Open Source All rights reserved.
 * Website: https://www.renren.io
 */
public interface SysUserTokenService extends BaseService<SysUserTokenEntity> {

    /**
     * Generate token
     *
     * @param userId user ID
     */
    Result<TokenDTO> createToken(Long userId);

    /**
     * Exchange the old token for a new token; the old token becomes invalid immediately
     *
     * @param oldToken old token string
     */
    Result<TokenDTO> refreshToken(String oldToken);

    SysUserDTO getUserByToken(String token);

    /**
     * Logout
     *
     * @param userId user ID
     */
    void logout(Long userId);

    /**
     * Change password
     *
     * @param userId
     * @param passwordDTO
     */
    void changePassword(Long userId, PasswordDTO passwordDTO);

}