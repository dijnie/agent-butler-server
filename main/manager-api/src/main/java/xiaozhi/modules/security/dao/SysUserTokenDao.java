package xiaozhi.modules.security.dao;

import java.util.Date;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import xiaozhi.common.dao.BaseDao;
import xiaozhi.modules.security.entity.SysUserTokenEntity;

/**
 * System user Token
 * Copyright (c) Renren Open Source All rights reserved.
 * Website: https://www.renren.io
 */
@Mapper
public interface SysUserTokenDao extends BaseDao<SysUserTokenEntity> {

    SysUserTokenEntity getByToken(String token);

    SysUserTokenEntity getByUserId(Long userId);

    void logout(@Param("userId") Long userId, @Param("expireDate") Date expireDate);

    /**
     * CAS update exchanging the old token for a new token: overwrite only when the old token has not expired and belongs to the specified user.
     * Returns the number of affected rows (0 means the condition was not met = the token was already refreshed concurrently or has expired).
     */
    int refreshTokenCAS(@Param("userId") Long userId,
            @Param("oldToken") String oldToken,
            @Param("newToken") String newToken,
            @Param("newExpire") Date newExpire,
            @Param("updateDate") Date updateDate);
}
