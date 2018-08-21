
#include "tup_confctrl_interface.h"

TUP_API TUP_RESULT huawei_tup_confctrl_set_init_param(const CONFCTRL_S_INIT_PARAM* param);

TUP_API TUP_VOID huawei_tup_confctrl_log_config(IN TUP_INT32 log_level, IN TUP_INT32 max_size_kb, IN TUP_INT32 file_count, IN const TUP_CHAR* log_path);

TUP_API TUP_RESULT huawei_tup_confctrl_init(TUP_VOID);

TUP_API TUP_RESULT huawei_tup_confctrl_uninit(TUP_VOID);

TUP_API TUP_RESULT huawei_tup_confctrl_register_process_notifiy(IN CONFCTRL_FN_CALLBACK_PTR callback_process_notify);

TUP_API TUP_RESULT huawei_tup_confctrl_set_conf_env_type(IN CONFCTRL_E_CONF_ENV_TYPE type);

TUP_API TUP_RESULT huawei_tup_confctrl_set_server_params(IN const CONFCTRL_S_SERVER_PARA* param);

TUP_API TUP_RESULT huawei_tup_confctrl_set_token(IN const TUP_CHAR* token);

TUP_API TUP_RESULT huawei_tup_confctrl_set_auth_code(IN TUP_CHAR* account, IN TUP_CHAR* password);

TUP_API TUP_RESULT huawei_tup_confctrl_set_auth_code_Ex(IN TUP_CHAR *account, IN TUP_CHAR *password, IN CONFCTRLC_E_CALL_TYPE type);

TUP_API TUP_RESULT huawei_tup_confctrl_get_vmr_list(IN const TUP_VOID* get_vmr_list);

TUP_API TUP_RESULT huawei_tup_confctrl_book_conf(IN TUP_VOID* book_conf_info);

TUP_API TUP_RESULT huawei_tup_confctrl_create_conf(IN const TUP_VOID* conf_info, OUT TUP_UINT32* handle);

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_list(IN const TUP_VOID* get_conf_list);

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_info(IN const TUP_VOID* get_conf_info);

TUP_API TUP_RESULT huawei_tup_confctrl_enter_chairman_password(IN TUP_UINT32 conf_handle, IN TUP_CHAR* password);

TUP_API TUP_RESULT huawei_tup_confctrl_get_dataconf_params(IN const CONFCTRL_S_GET_DATACONF_PARAMS* get_params);

TUP_API TUP_RESULT huawei_tup_confctrl_create_conf_handle(IN TUP_VOID* conf_info, IO TUP_UINT32* conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_destroy_conf_handle(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_add_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee_info);

TUP_API TUP_RESULT huawei_tup_confctrl_remove_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee);

TUP_API TUP_RESULT huawei_tup_confctrl_mute_conf(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_mute);

TUP_API TUP_RESULT huawei_tup_confctrl_mute_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee, IN TUP_BOOL is_mute);

TUP_API TUP_RESULT huawei_tup_confctrl_hang_up_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee);

TUP_API TUP_RESULT huawei_tup_confctrl_call_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee);

TUP_API TUP_RESULT huawei_tup_confctrl_request_chairman(IN TUP_UINT32 conf_handle, IN TUP_CHAR* password, IN const TUP_CHAR* number);

TUP_API TUP_RESULT huawei_tup_confctrl_release_chairman(IN TUP_UINT32 conf_handle, IN const TUP_CHAR* number);

TUP_API TUP_RESULT huawei_tup_confctrl_postpone_conf(IN TUP_UINT32 conf_handle, IN TUP_UINT16 time);

TUP_API TUP_RESULT huawei_tup_confctrl_lockconf(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_lock);

TUP_API TUP_RESULT huawei_tup_confctrl_handup(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_handup, IN const TUP_VOID* attendee);

TUP_API TUP_RESULT huawei_tup_confctrl_p2p_transfer_to_conf(IN TUP_UINT32 callid, IN const TUP_VOID* create_conf_info, OUT TUP_UINT32* handle);

TUP_API TUP_RESULT huawei_tup_confctrl_transferto_conf(TUP_UINT32 confid, TUP_UINT32 callid);

TUP_API TUP_RESULT huawei_tup_confctrl_upgrade_conf(IN TUP_UINT32 conf_handle, IN const CONFCTRL_S_ADD_MEDIA* upgrade_param);

TUP_API TUP_RESULT huawei_tup_confctrl_set_conf_mode(IN TUP_UINT32 conf_handle, CONFCTRL_E_CONF_MODE mode);

TUP_API TUP_RESULT huawei_tup_confctrl_subscribe_conf(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_accept_conf(IN TUP_UINT32 conf_handle, IN TUP_BOOL join_video_conf);

TUP_API TUP_RESULT huawei_tup_confctrl_reject_conf(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_leave_conf(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_end_conf(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_hold_conf(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_unhold_conf(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_watch_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee);

TUP_API TUP_RESULT huawei_tup_confctrl_broadcast_attendee(IN TUP_UINT32 conf_handle, IN TUP_VOID* attendee, IN TUP_BOOL toBroadcast);

TUP_API TUP_VOID huawei_tup_confctrl_register_logfun(CONFCTRL_FN_LOG_CALLBACK_PTR callback_log);

TUP_API TUP_RESULT huawei_tup_confctrl_set_log_params(TUP_INT32 log_Level, TUP_INT32 max_size_kb, TUP_INT32 file_count, const TUP_CHAR *log_path);

TUP_API TUP_RESULT huawei_tup_confctrl_get_attendee_list(IN TUP_UINT32 conf_handle, IO TE_ATTENDEE_DATA_IN_LIST* rem_sit_list);

TUP_API TE_CONF_CTRL_INFO* huawei_tup_confctrl_get_conf_state(IN TUP_UINT32 conf_handle);

TUP_API TUP_RESULT huawei_tup_confctrl_request_attendees_number(IN TUP_UINT32 conf_handle, IN CONFCTRL_E_GET_TERMNUM_REQ_TYPE reqtype, IN const TUP_VOID *param);

TUP_API TUP_RESULT huawei_tup_confctrl_set_proxy(const CONFCTRL_S_PROXY_PARAM* proxy_param);

TUP_API TUP_RESULT huawei_tup_confctrl_set_cipher(IN const CONFCTRL_S_CIPHERLIST *cipherList);

TUP_API TUP_VOID huawei_tup_confctrl_set_verify_mode(IN CONFCTRL_E_HTTPS_VERIFY_MODE verifyMode);

TUP_API TUP_RESULT huawei_tup_confctrl_watch_svc_attendees(IN TUP_UINT32 conf_handle, IN TUP_VOID* watch_svc_attendees_info);

TUP_API TUP_RESULT huawei_tup_confctrl_request_confctrl_right(IN TUP_UINT32 conf_handle, IN const TUP_CHAR* number, IN const TUP_CHAR* password, IN const TUP_CHAR* tmp_token);

TUP_API TUP_RESULT huawei_tup_confctrl_set_speaker_report(IN TUP_UINT32 conf_handle, IN TUP_BOOL is_enable);

TUP_API TUP_RESULT huawei_tup_confctrl_set_tempuser_flag(IN TUP_BOOL is_tempuser);

TUP_API TUP_RESULT huawei_tup_confctrl_get_dataconf_params_ex(IN const CONFCTRL_S_GET_DATACONF_PARAMS* get_params);

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_resource(IN const CONFCTRL_S_REQUEST_CONF_RESOURCE* params);

TUP_API TUP_RESULT huawei_tup_confctrl_set_tls_param(IN CONFCTRL_TLS_PARM* param);

TUP_API TUP_RESULT huawei_tup_confctrl_get_conf_authinfo(IN TUP_CHAR *conf_id);

TUP_API TUP_RESULT huawei_tup_confctrl_set_local_confname(IN TUP_VOID *conf_name);

TUP_API TUP_RESULT huawei_tup_confctrl_set_mixed_picture(IN TUP_UINT32 conf_handle, IN const CONFCTRL_S_MIXED_PICTURE_PARAM* param);
