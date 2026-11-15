package xiaozhi.modules.sms.service;

/**
 * Interface defining the methods of the SMS service
 *
 * @author zjy
 * @since 2025-05-12
 */
public interface SmsService {

    /**
     * Send the verification code SMS
     * @param phone mobile number
     * @param VerificationCode verification code
     */
    void sendVerificationCodeSms(String phone, String VerificationCode) ;
}
