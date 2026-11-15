# Alibaba Cloud SMS Integration Guide

Log in to the Alibaba Cloud console and go to the "SMS Service" page: https://dysms.console.aliyun.com/overview

## Step 1: Add a signature
![Step](images/alisms/sms-01.png)
![Step](images/alisms/sms-02.png)

The steps above give you a signature. Write it into the control console parameter `aliyun.sms.sign_name`

## Step 2: Add a template
![Step](images/alisms/sms-11.png)

The steps above give you a template code. Write it into the control console parameter `aliyun.sms.sms_code_template_code`

Note: the signature takes 7 working days to be filed with the carriers; messages can only be sent successfully after the filing succeeds.

Note: the signature takes 7 working days to be filed with the carriers; messages can only be sent successfully after the filing succeeds.

Note: the signature takes 7 working days to be filed with the carriers; messages can only be sent successfully after the filing succeeds.

You can wait until the filing succeeds before continuing.

## Step 3: Create an SMS account and grant permissions

Log in to the Alibaba Cloud console and go to the "Access Control" page: https://ram.console.aliyun.com/overview?activeTab=overview

![Step](images/alisms/sms-21.png)
![Step](images/alisms/sms-22.png)
![Step](images/alisms/sms-23.png)
![Step](images/alisms/sms-24.png)
![Step](images/alisms/sms-25.png)

The steps above give you an access_key_id and an access_key_secret. Write them into the control console parameters `aliyun.sms.access_key_id` and `aliyun.sms.access_key_secret`
## Step 4: Enable mobile registration

1. Normally, after all the information above is filled in, you get this result. If not, a step may be missing

![Step](images/alisms/sms-31.png)

2. Allow non-administrator users to register: set the parameter `server.allow_user_register` to `true`

3. Enable mobile registration: set the parameter `server.enable_mobile_register` to `true`
![Step](images/alisms/sms-32.png)