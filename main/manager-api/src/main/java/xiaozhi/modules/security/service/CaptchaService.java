package xiaozhi.modules.security.service;

import java.io.IOException;

import jakarta.servlet.http.HttpServletResponse;

/**
 * Captcha
 * Copyright (c) Renren Open Source All rights reserved.
 * Website: https://www.renren.io
 */
public interface CaptchaService {

    /**
     * Image captcha
     */
    void create(HttpServletResponse response, String uuid) throws IOException;

    /**
     * Captcha validation
     * 
     * @param uuid   uuid
     * @param code   captcha
     * @param delete whether to delete the captcha
     * @return true: success, false: failure
     */
    boolean validate(String uuid, String code, Boolean delete);

    /**
     * Send the SMS verification code
     * 
     * @param phone mobile number
     */
    void sendSMSValidateCode(String phone);

    /**
     * Verify the SMS verification code
     * 
     * @param phone  mobile number
     * @param code   captcha
     * @param delete whether to delete the captcha
     * @return true: success, false: failure
     */
    boolean validateSMSValidateCode(String phone, String code, Boolean delete);
}
