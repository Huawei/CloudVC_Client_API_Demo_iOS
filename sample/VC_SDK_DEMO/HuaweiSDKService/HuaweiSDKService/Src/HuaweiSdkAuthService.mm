
#include "HuaweiSdkAuthService.h"


TUP_API TUP_RESULT huawei_tup_service_startup(TUP_S_INIT_PARAM *param)
{
    return tup_service_startup(param);
}

TUP_API TUP_RESULT huawei_tup_service_shutdown()
{
    return tup_service_shutdown();
}


TUP_RESULT huawei_tup_login_log_start(IN LOGIN_E_LOG_LEVEL  log_level, IN TUP_INT32 max_size_kb, IN TUP_INT32 file_count, IN const TUP_CHAR* log_path)
{
    return tup_login_log_start(log_level, max_size_kb, file_count, log_path);
}


TUP_VOID  huawei_tup_login_log_stop(TUP_VOID)
{
    tup_login_log_stop();
    return;
}


TUP_RESULT huawei_tup_login_set_log_params(LOGIN_E_LOG_LEVEL log_evel,TUP_INT32 max_size_KB, TUP_INT32 file_count, const TUP_CHAR* log_path)
{
    return tup_login_set_log_params(log_evel, max_size_KB, file_count, log_path);
}


TUP_RESULT huawei_tup_login_register_process_notifiy(IN LOGIN_FN_CALLBACK_PTR call_back)
{
    return tup_login_register_process_notifiy(call_back);
}


TUP_RESULT huawei_tup_login_init(IN TUP_CHAR* cert_path, IN LOGIN_E_VERIFY_MODE verify_mode)
{
    return tup_login_init(cert_path, verify_mode);
}


TUP_RESULT huawei_tup_login_uninit()
{
    return tup_login_uninit();
}


TUP_RESULT huawei_tup_login_authorize(IN const LOGIN_S_AUTHORIZE_PARAM* auth_param)
{
    return tup_login_authorize(auth_param);
}


TUP_RESULT huawei_tup_login_refresh_token(TUP_VOID)
{
    return tup_login_refresh_token();
}


TUP_RESULT huawei_tup_login_change_register_password(IN LOGIN_S_CHANGE_PWD_PARAM* param)
{
    return tup_login_change_register_password(param);
}


TUP_RESULT huawei_tup_login_firewall_detect(IN const LOGIN_S_DETECT_SERVER* detect_server)
{
    return 0;
}


TUP_RESULT huawei_tup_login_build_stg_tunnel(IN const LOGIN_S_STG_PARAM* server)
{
    return 0;
}

TUP_RESULT huawei_tup_login_destory_stg_tunnel()
{
    return 0;
}

TUP_RESULT huawei_tup_login_set_proxy(IN const LOGIN_S_PROXY_PARAM* proxy_param)
{
    return 0;
}

TUP_RESULT huawei_tup_login_update_stg_auth_info(IN const LOGIN_S_AUTH_INFO* auth_info)
{
    return 0;
}

TUP_RESULT huawei_tup_login_set_tls_param(IN LOGIN_TLS_PARM* param)
{
    return 0;
}

TUP_RESULT huawei_tup_login_get_tempuserinfo_from_confinfo(IN const LOGIN_S_CONF_INFO* confinfo_param)
{
    return 0;
}

TUP_RESULT huawei_tup_login_get_tempuserinfo_from_random(IN const LOGIN_S_RANDOM_INFO* random_param)
{
    return 0;
}

TUP_RESULT huawei_tup_login_port_detect(IN const LOGIN_S_DETECT_SERVER* detect_server)
{
    return 0;
}
