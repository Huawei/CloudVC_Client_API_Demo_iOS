
#include "HuaweiSdkConfCtrlService.h"

TUP_API TUP_RESULT huawei_tup_confctrl_set_init_param(const CONFCTRL_S_INIT_PARAM* param)
{
    return tup_confctrl_set_init_param(param);
}

TUP_API TUP_VOID huawei_tup_confctrl_log_config(IN TUP_INT32 log_level, IN TUP_INT32 max_size_kb, IN TUP_INT32 file_count, IN const TUP_CHAR* log_path)
{
    return tup_confctrl_log_config(log_level, max_size_kb,file_count, log_path);
}

TUP_API TUP_RESULT huawei_tup_confctrl_init(TUP_VOID)
{
    return tup_confctrl_init();
}

TUP_API TUP_RESULT huawei_tup_confctrl_uninit(TUP_VOID)
{
    return tup_confctrl_uninit();
}

TUP_API TUP_RESULT huawei_tup_confctrl_register_process_notifiy(IN CONFCTRL_FN_CALLBACK_PTR callback_process_notify)
{
    return tup_confctrl_register_process_notifiy(callback_process_notify);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_conf_env_type(IN CONFCTRL_E_CONF_ENV_TYPE type)
{
    return tup_confctrl_set_conf_env_type(type);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_server_params(IN const CONFCTRL_S_SERVER_PARA* param)
{
    return tup_confctrl_set_server_params(param);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_token(IN const TUP_CHAR* token)
{
    return tup_confctrl_set_token(token);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_auth_code(IN TUP_CHAR* account, IN TUP_CHAR* password)
{
    return tup_confctrl_set_auth_code(account, password);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_auth_code_Ex(IN TUP_CHAR *account, IN TUP_CHAR *password, IN CONFCTRLC_E_CALL_TYPE type)
{
    return tup_confctrl_set_auth_code_Ex(account, password, type);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_vmr_list(IN const TUP_VOID* get_vmr_list)
{
    return tup_confctrl_get_vmr_list(get_vmr_list);
}

TUP_API TUP_RESULT huawei_tup_confctrl_book_conf(IN TUP_VOID* book_conf_info)
{
    return tup_confctrl_book_conf(book_conf_info);
}

TUP_API TUP_RESULT huawei_tup_confctrl_create_conf(IN const TUP_VOID* conf_info, OUT TUP_UINT32* handle)
{
    return tup_confctrl_create_conf(conf_info, handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_list(IN const TUP_VOID* get_conf_list)
{
    return tup_confctrl_get_conf_list(get_conf_list);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_info(IN const TUP_VOID* get_conf_info)
{
    return tup_confctrl_get_conf_info(get_conf_info);
}

TUP_API TUP_RESULT huawei_tup_confctrl_enter_chairman_password(IN TUP_UINT32 conf_handle, IN TUP_CHAR* password)
{
    return tup_confctrl_enter_chairman_password(conf_handle, password);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_dataconf_params(IN const CONFCTRL_S_GET_DATACONF_PARAMS* get_params)
{
    return tup_confctrl_get_dataconf_params(get_params);
}

TUP_API TUP_RESULT huawei_tup_confctrl_create_conf_handle(IN TUP_VOID* conf_info, IO TUP_UINT32* conf_handle)
{
    return tup_confctrl_create_conf_handle(conf_info, conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_destroy_conf_handle(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_destroy_conf_handle(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_add_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee_info)
{
    return tup_confctrl_add_attendee(conf_handle, attendee_info);
}

TUP_API TUP_RESULT huawei_tup_confctrl_remove_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee)
{
    return tup_confctrl_remove_attendee(conf_handle, attendee);
}

TUP_API TUP_RESULT huawei_tup_confctrl_mute_conf(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_mute)
{
    return tup_confctrl_mute_conf(conf_handle, is_mute);
}

TUP_API TUP_RESULT huawei_tup_confctrl_mute_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee, IN TUP_BOOL is_mute)
{
    return tup_confctrl_mute_attendee(conf_handle, attendee, is_mute);
}

TUP_API TUP_RESULT huawei_tup_confctrl_hang_up_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee)
{
    return tup_confctrl_hang_up_attendee(conf_handle, attendee);
}

TUP_API TUP_RESULT huawei_tup_confctrl_call_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee)
{
    return tup_confctrl_call_attendee(conf_handle, attendee);
}

TUP_API TUP_RESULT huawei_tup_confctrl_request_chairman(IN TUP_UINT32 conf_handle, IN TUP_CHAR* password, IN const TUP_CHAR* number)
{
    return tup_confctrl_request_chairman(conf_handle, password, number);
}

TUP_API TUP_RESULT huawei_tup_confctrl_release_chairman(IN TUP_UINT32 conf_handle, IN const TUP_CHAR* number)
{
    return tup_confctrl_release_chairman(conf_handle, number);
}

TUP_API TUP_RESULT huawei_tup_confctrl_postpone_conf(IN TUP_UINT32 conf_handle, IN TUP_UINT16 time)
{
    return tup_confctrl_postpone_conf(conf_handle, time);
}

TUP_API TUP_RESULT huawei_tup_confctrl_lockconf(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_lock)
{
    return tup_confctrl_lockconf(conf_handle, is_lock);
}

TUP_API TUP_RESULT huawei_tup_confctrl_handup(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_handup, IN const TUP_VOID* attendee)
{
    return tup_confctrl_handup(conf_handle, is_handup, attendee);
}

TUP_API TUP_RESULT huawei_tup_confctrl_p2p_transfer_to_conf(IN TUP_UINT32 callid, IN const TUP_VOID* create_conf_info, OUT TUP_UINT32* handle)
{
    return tup_confctrl_p2p_transfer_to_conf(callid, create_conf_info, handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_transferto_conf(TUP_UINT32 confid, TUP_UINT32 callid)
{
    return tup_confctrl_transferto_conf(confid, callid);
}

TUP_API TUP_RESULT huawei_tup_confctrl_upgrade_conf(IN TUP_UINT32 conf_handle, IN const CONFCTRL_S_ADD_MEDIA* upgrade_param)
{
    return tup_confctrl_upgrade_conf(conf_handle, upgrade_param);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_conf_mode(IN TUP_UINT32 conf_handle, CONFCTRL_E_CONF_MODE mode)
{
    return tup_confctrl_set_conf_mode(conf_handle, mode);
}

TUP_API TUP_RESULT huawei_tup_confctrl_subscribe_conf(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_subscribe_conf(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_accept_conf(IN TUP_UINT32 conf_handle, IN TUP_BOOL join_video_conf)
{
    return tup_confctrl_accept_conf(conf_handle, join_video_conf);
}

TUP_API TUP_RESULT huawei_tup_confctrl_reject_conf(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_reject_conf(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_leave_conf(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_leave_conf(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_end_conf(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_end_conf(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_hold_conf(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_hold_conf(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_unhold_conf(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_unhold_conf(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_watch_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee)
{
    return tup_confctrl_watch_attendee(conf_handle, attendee);
}

TUP_API TUP_RESULT huawei_tup_confctrl_broadcast_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee, IN TUP_BOOL toBroadcast)
{
    return tup_confctrl_broadcast_attendee(conf_handle, attendee, toBroadcast);
}

TUP_API TUP_VOID huawei_tup_confctrl_register_logfun(CONFCTRL_FN_LOG_CALLBACK_PTR callback_log)
{
    return tup_confctrl_register_logfun(callback_log);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_log_params(TUP_INT32 log_Level, TUP_INT32 max_size_kb, TUP_INT32 file_count, const TUP_CHAR *log_path)
{
    return tup_confctrl_set_log_params(log_Level, max_size_kb, file_count, log_path);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_attendee_list(IN TUP_UINT32 conf_handle, IO TE_ATTENDEE_DATA_IN_LIST* rem_sit_list)
{
    return tup_confctrl_get_attendee_list(conf_handle, rem_sit_list);
}

TUP_API TE_CONF_CTRL_INFO* huawei_tup_confctrl_get_conf_state(IN TUP_UINT32 conf_handle)
{
    return tup_confctrl_get_conf_state(conf_handle);
}

TUP_API TUP_RESULT huawei_tup_confctrl_request_attendees_number(IN TUP_UINT32 conf_handle, IN CONFCTRL_E_GET_TERMNUM_REQ_TYPE reqtype, IN const TUP_VOID *param)
{
    return tup_confctrl_request_attendees_number(conf_handle, reqtype, param);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_proxy(const CONFCTRL_S_PROXY_PARAM* proxy_param)
{
    return tup_confctrl_set_proxy(proxy_param);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_cipher(IN const CONFCTRL_S_CIPHERLIST *cipherList)
{
    return tup_confctrl_set_cipher(cipherList);
}

TUP_API TUP_VOID huawei_tup_confctrl_set_verify_mode(IN CONFCTRL_E_HTTPS_VERIFY_MODE verifyMode)
{
    return tup_confctrl_set_verify_mode(verifyMode);
}

TUP_API TUP_RESULT huawei_tup_confctrl_watch_svc_attendees(IN TUP_UINT32 conf_handle, IN TUP_VOID* watch_svc_attendees_info)
{
    return tup_confctrl_watch_svc_attendees(conf_handle, watch_svc_attendees_info);
}

TUP_API TUP_RESULT huawei_tup_confctrl_request_confctrl_right(IN TUP_UINT32 conf_handle, IN const TUP_CHAR* number, IN const TUP_CHAR* password, IN const TUP_CHAR* tmp_token)
{
    return tup_confctrl_request_confctrl_right(conf_handle, number, password, tmp_token);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_speaker_report(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_enable)
{
    return tup_confctrl_set_speaker_report(conf_handle, is_enable);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_tempuser_flag(IN TUP_BOOL is_tempuser)
{
    return tup_confctrl_set_tempuser_flag(is_tempuser);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_dataconf_params_ex(IN const CONFCTRL_S_GET_DATACONF_PARAMS* get_params)
{
    return tup_confctrl_get_dataconf_params_ex(get_params);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_resource(IN const CONFCTRL_S_REQUEST_CONF_RESOURCE* params)
{
    return tup_confctrl_get_conf_resource(params);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_tls_param(IN CONFCTRL_TLS_PARM* param)
{
    return tup_confctrl_set_tls_param(param);
}

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_authinfo(IN TUP_CHAR *conf_id)
{
    return tup_confctrl_get_conf_authinfo(conf_id);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_local_confname(IN TUP_VOID *conf_name)
{
    return tup_confctrl_set_local_confname(conf_name);
}

TUP_API TUP_RESULT huawei_tup_confctrl_set_mixed_picture(IN TUP_UINT32 conf_handle, IN const CONFCTRL_S_MIXED_PICTURE_PARAM* param)
{
    return tup_confctrl_set_mixed_picture(conf_handle, param);
}
