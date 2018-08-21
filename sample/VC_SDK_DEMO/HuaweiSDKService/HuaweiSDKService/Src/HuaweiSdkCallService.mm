
#include "HuaweiSdkCallService.h"

TUP_VOID huawei_tup_call_log_start(IN TUP_INT32 log_level, IN TUP_INT32 max_size_kb, IN TUP_INT32 file_count, IN const TUP_CHAR* log_path)
{
    tup_call_log_start(log_level, max_size_kb, file_count, log_path);
    return;
}


TUP_RESULT huawei_tup_call_set_log_params(TUP_INT32 log_level, TUP_INT32 max_size_kb, TUP_INT32 file_count, const TUP_CHAR *log_path)
{
    return tup_call_set_log_params(log_level, max_size_kb, file_count, log_path);
}


TUP_RESULT huawei_tup_call_init(TUP_VOID)
{
    return tup_call_init();
}


TUP_RESULT huawei_tup_call_uninit(TUP_VOID)
{
    return tup_call_uninit();
}


TUP_RESULT huawei_tup_call_register_process_notifiy(IN CALL_FN_CALLBACK_PTR callback_process_notify)
{
    return tup_call_register_process_notifiy(callback_process_notify);
}


TUP_RESULT huawei_tup_call_register_capture_screen_func(IN CALL_FN_CAPTURE_SCREEN_PTR capture_screen_func)
{
    return tup_call_register_capture_screen_func(capture_screen_func);
}


TUP_RESULT huawei_tup_call_set_cfg(IN TUP_UINT32 cfgid, IN const TUP_VOID * val)
{
    return tup_call_set_cfg(cfgid, val);
}


TUP_RESULT huawei_tup_call_register(IN const TUP_CHAR* number, IN const TUP_CHAR* name, IN const TUP_CHAR* password)
{
    return tup_call_register(number, name, password);
}


TUP_RESULT huawei_tup_call_deregister(IN const TUP_CHAR* number)
{
    return tup_call_deregister(number);
}


TUP_RESULT huawei_tup_call_start_call(OUT TUP_UINT32 *callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* callee_number)
{
    return tup_call_start_call(callid, call_type, callee_number);
}


TUP_RESULT huawei_tup_call_accept_call(IN TUP_UINT32 callid, IN TUP_BOOL is_video)
{
    return tup_call_accept_call(callid, is_video);
}


TUP_RESULT huawei_tup_call_end_call(IN TUP_UINT32 callid)
{
    return tup_call_end_call(callid);
}


TUP_RESULT huawei_tup_call_alerting_call(IN TUP_UINT32 callid)
{
    return tup_call_alerting_call(callid);
}


TUP_RESULT huawei_tup_call_send_DTMF(IN TUP_UINT32 callid, IN CALL_E_DTMF_TONE tone)
{
    return tup_call_send_DTMF(callid, tone);
}


TUP_RESULT huawei_tup_call_hold_call(IN TUP_UINT32 callid)
{
    return tup_call_hold_call(callid);
}


TUP_RESULT huawei_tup_call_unhold_call(IN TUP_UINT32 callid)
{
    return tup_call_unhold_call(callid);
}


TUP_RESULT huawei_tup_call_set_video_window(IN TUP_UINT32 count, IN const CALL_S_VIDEOWND_INFO *window, IN TUP_UINT32 callid)
{
    return tup_call_set_video_window(count, window, callid);
}


TUP_RESULT huawei_tup_call_add_video(IN TUP_UINT32 callid)
{
    return tup_call_add_video(callid);
}


TUP_RESULT huawei_tup_call_del_video(IN TUP_UINT32 callid)
{
    return tup_call_del_video(callid);
}


TUP_RESULT huawei_tup_call_reply_add_video(IN TUP_UINT32 callid, IN TUP_BOOL is_accept)
{
    return tup_call_reply_add_video(callid, is_accept);
}


TUP_RESULT huawei_tup_call_divert_call(IN TUP_UINT32 callid, IN const TUP_CHAR* divert_number)
{
    return tup_call_divert_call(callid, divert_number);
}


TUP_RESULT huawei_tup_call_blind_transfer(IN TUP_UINT32 callid, IN const TUP_CHAR* transto_number)
{
    return tup_call_blind_transfer(callid, transto_number);
}


TUP_RESULT huawei_tup_call_set_IPTservice(IN CALL_E_SERVICE_CALL_TYPE type, IN void* data)
{
    return tup_call_set_IPTservice(type, data);
}


TUP_RESULT huawei_tup_call_media_mute_mic(IN TUP_UINT32 callid, IN TUP_BOOL is_mute)
{
    return tup_call_media_mute_mic(callid, is_mute);
}


TUP_RESULT huawei_tup_call_video_control(IN CALL_S_VIDEOCONTROL *video_control)
{
    return tup_call_video_control(video_control);
}


TUP_RESULT huawei_tup_call_set_video_capture_file(IN TUP_UINT32 callid, IN TUP_CHAR *file_name)
{
    return tup_call_set_video_capture_file(callid, file_name);
}


TUP_RESULT huawei_tup_call_media_startplay(IN TUP_UINT32 loops, IN const TUP_CHAR* play_file, OUT TUP_INT32* play_handle)
{
    return tup_call_media_startplay(loops, play_file, play_handle);
}


TUP_RESULT huawei_tup_call_media_stopplay(IN TUP_INT32 play_handle)
{
    return tup_call_media_stopplay(play_handle);
}


TUP_RESULT huawei_tup_call_media_get_devices(IO TUP_UINT32* num, OUT CALL_S_DEVICEINFO* device_info, IN CALL_E_DEVICE_TYPE device_type)
{
    return tup_call_media_get_devices(num, device_info, device_type);
}


TUP_RESULT huawei_tup_call_media_set_mic_index(IN TUP_UINT32 index)
{
    return tup_call_media_set_mic_index(index);
}


TUP_RESULT huawei_tup_call_media_set_speak_index(IN TUP_UINT32 index)
{
    return tup_call_media_set_speak_index(index);
}


TUP_RESULT huawei_tup_call_media_set_video_index(IN TUP_UINT32 index)
{
    return tup_call_media_set_video_index(index);
}


TUP_RESULT huawei_tup_call_media_get_mic_index(OUT TUP_UINT32* index)
{
    return tup_call_media_get_mic_index(index);
}


TUP_RESULT huawei_tup_call_media_get_speak_index(OUT TUP_UINT32* index)
{
    return tup_call_media_get_speak_index(index);
}


TUP_RESULT huawei_tup_call_media_get_video_index(OUT TUP_UINT32* index)
{
    return tup_call_media_get_video_index(index);
}


TUP_RESULT huawei_tup_call_set_mobile_audio_route(IN CALL_E_MOBILE_AUIDO_ROUTE route)
{
    return tup_call_set_mobile_audio_route(route);
}


TUP_RESULT huawei_tup_call_get_mobile_audio_route(OUT CALL_E_MOBILE_AUIDO_ROUTE *route)
{
    return tup_call_get_mobile_audio_route(route);
}


TUP_RESULT huawei_tup_call_set_video_orient(IN TUP_UINT32 callid, IN TUP_UINT32 index, IN const CALL_S_VIDEO_ORIENT *video_orient)
{
    return tup_call_set_video_orient(callid, index, video_orient);
}


TUP_RESULT huawei_tup_call_media_set_speak_volume(IN CALL_E_AO_DEV dev, IN TUP_UINT32 volume)
{
    return tup_call_media_set_speak_volume(dev, volume);
}


TUP_RESULT huawei_tup_call_media_get_speak_volume(OUT TUP_UINT32* volume)
{
    return tup_call_media_get_speak_volume(volume);
}


TUP_RESULT huawei_tup_call_open_preview(IN TUP_UPTR handle, IN TUP_UINT32 index)
{
    return tup_call_open_preview(handle, index);
}


TUP_RESULT huawei_tup_call_close_preview(TUP_VOID)
{
    return tup_call_close_preview();
}


TUP_RESULT huawei_tup_call_data_control(IN CALL_S_VIDEOCONTROL *data_control)
{
    return tup_call_data_control(data_control);
}


TUP_RESULT huawei_tup_call_start_data(IN TUP_UINT32 callid)
{
    return tup_call_start_data(callid);
}


TUP_RESULT huawei_tup_call_stop_data(IN TUP_UINT32 callid)
{
    return tup_call_stop_data(callid);
}


TUP_RESULT huawei_tup_call_get_data_maxframesize(IN TUP_UINT32 callid, OUT TUP_UINT32 *max_frame_size)
{
    return tup_call_get_data_maxframesize(callid, max_frame_size);
}


TUP_RESULT huawei_tup_call_serverconf_access_reservedconf(OUT TUP_UINT32 *callid, IN const TUP_CHAR *accesscode)
{
    return tup_call_serverconf_access_reservedconf(callid, accesscode);
}


TUP_RESULT huawei_tup_call_serverconf_access_reservedconf_ex(OUT TUP_UINT32 * callid, IN CALL_E_CALL_TYPE call_type, IN const CALL_S_CONF_PARAM * confParam)
{
    return tup_call_serverconf_access_reservedconf_ex(callid, call_type, confParam);
}


const TUP_CHAR* huawei_tup_call_get_err_description(IN TUP_UINT32 errornum)
{
    return tup_call_get_err_description(errornum);
}


TUP_RESULT huawei_tup_call_stop_local_server(TUP_VOID)
{
    return tup_call_stop_local_server();
}



TUP_VOID huawei_tup_call_hme_log_info(IN TUP_INT32 audio_log_level,
                                      IN TUP_INT32 audio_max_size, IN TUP_INT32 video_log_level, IN TUP_INT32 video_max_size)
{
    return tup_call_hme_log_info(audio_log_level, audio_max_size, video_log_level, video_max_size);
}

TUP_RESULT huawei_tup_call_set_hme_log_params(TUP_INT32 audio_log_level, TUP_INT32 audio_max_size, TUP_INT32 video_log_level, TUP_INT32 video_max_size)
{
    return tup_call_set_hme_log_params(audio_log_level, audio_max_size, video_log_level, video_max_size);
}


TUP_VOID huawei_tup_call_log_stop(TUP_VOID)
{
    return tup_call_log_stop();
}


TUP_VOID   huawei_tup_call_register_logfun(IN CALL_FN_DEBUG_CALLBACK_PTR callback_log)
{
    return tup_call_register_logfun(callback_log);
    
}

TUP_RESULT huawei_tup_call_get_cfg(IN TUP_UINT32 cfgid, OUT TUP_VOID* val,  IN TUP_UINT32 size)
{
    return tup_call_get_cfg(cfgid, val, size);
}

TUP_RESULT huawei_tup_call_enable_ipaddr_call()
{
    return tup_call_enable_ipaddr_call();
}

TUP_RESULT huawei_tup_call_disable_ipaddr_call()
{
    return tup_call_disable_ipaddr_call();
    
}

TUP_RESULT huawei_tup_call_authorize_account(IN const TUP_CHAR* number, IN const TUP_CHAR* name, IN const TUP_CHAR* password)
{
    return tup_call_authorize_account(number, name, password);
    
}

TUP_RESULT huawei_tup_call_cancel_login(TUP_VOID)
{
    return tup_call_cancel_login();
}

TUP_RESULT huawei_tup_call_register_for_account(IN TUP_UINT32 account_id)
{
    return tup_call_register_for_account(account_id);
}

TUP_RESULT huawei_tup_call_deregister_for_account(IN TUP_UINT32 account_id)
{
    return tup_call_deregister_for_account(account_id);
}

TUP_RESULT huawei_tup_call_start_refreshregister_for_account(IN TUP_UINT32 account_id)
{
    return tup_call_start_refreshregister_for_account(account_id);
}

TUP_RESULT huawei_tup_call_stop_refreshregister_for_account(IN TUP_UINT32 account_id)
{
    return tup_call_stop_refreshregister_for_account(account_id);
}

TUP_RESULT huawei_tup_call_stop_refreshregister(IN const TUP_CHAR* number)
{
    return tup_call_stop_refreshregister(number);
}

TUP_RESULT huawei_tup_call_start_refreshregister(IN const TUP_CHAR* number)
{
    return tup_call_start_refreshregister(number);
}

TUP_RESULT huawei_tup_call_get_registered_server(IN TUP_UINT32 ulSipAccountId, OUT CALL_S_SERVER_CFG *pstServerInfo)
{
    return tup_call_get_registered_server(ulSipAccountId, pstServerInfo);
}

TUP_RESULT huawei_tup_call_set_user_name(IN CALL_S_ACCOUNT_USER_NAME* user_name, IN TUP_UINT32 data_num)
{
    return tup_call_set_user_name(user_name,data_num);
}

TUP_RESULT huawei_tup_call_get_sipserver_link_status(IN TUP_UINT8 server_index)
{
    return tup_call_get_sipserver_link_status(server_index);
}

TUP_RESULT huawei_tup_call_get_sipserver_info(IN TUP_UINT32 callid, IN CALL_S_CURRENT_SIPSERVER* server_info)
{
    return tup_call_get_sipserver_info(callid,  server_info);
}

TUP_RESULT huawei_tup_call_get_sipserver_addrlist(IN TUP_UINT32 account_id,
                                                  OUT TUP_UINT32* addr_num,  OUT CALL_S_SIP_ADDR_INFO* addr_info)
												  {
    return tup_call_get_sipserver_addrlist(account_id,
                                                  addr_num,  addr_info);
}

TUP_RESULT huawei_tup_call_get_regserver_addrlist(IN CALL_E_PROTOCOL_TYPE  protocol_type,
                                                  IN TUP_UINT32 account_id, OUT TUP_UINT32* addr_num, OUT CALL_S_IPADDR *addr_info)
												  {
    return tup_call_get_regserver_addrlist(protocol_type,
                                                  account_id,  addr_num,addr_info);
}

TUP_RESULT huawei_tup_call_get_account_info(OUT CALL_S_SIP_ACCOUNT_INFO* account_info, OUT TUP_UINT32* count)
{
    return tup_call_get_account_info(account_info,count);
}

TUP_RESULT huawei_tup_call_uportal_refresh_token()
{
    return tup_call_uportal_refresh_token();
}

TUP_RESULT huawei_tup_call_create_callid(IN TUP_UINT32 account_id,  IN CALL_E_LINE_TYPE line_type, IN TUP_UINT32 lineid, OUT TUP_UINT32* callid)
{
    return tup_call_create_callid( account_id, line_type,lineid, callid);
}

TUP_RESULT huawei_tup_call_start_call_bycallid(IN TUP_UINT32 callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* callee_number)
{
    return tup_call_start_call_bycallid(callid, call_type, callee_number);
}

TUP_RESULT huawei_tup_call_start_call_bycallid_ex(IN const CALL_S_CALL_PARAMS* call_params)
{
    return tup_call_start_call_bycallid_ex( call_params);
}

TUP_RESULT huawei_tup_call_anonymous_call_bycallid(IN TUP_UINT32 callid, IN const TUP_CHAR* callee_number)
{
    return tup_call_anonymous_call_bycallid(callid, callee_number);
}

TUP_RESULT huawei_tup_call_start_anonymous_call_bycallid(IN TUP_UINT32 callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* callee_number)
{
    return tup_call_start_anonymous_call_bycallid(callid, call_type, callee_number);
}

TUP_RESULT huawei_tup_call_emergency_call(IN TUP_UINT32 callid, IN const TUP_CHAR* callee_number)
{
    return tup_call_emergency_call(callid,callee_number);
}

TUP_RESULT huawei_tup_call_anonymous_call(OUT TUP_UINT32* callid, IN const TUP_CHAR* callee_number)
{
    return tup_call_anonymous_call(callid,callee_number);
}

TUP_RESULT huawei_tup_call_start_anonymous_call(OUT TUP_UINT32* callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* callee_number)
{
    return tup_call_start_anonymous_call(callid, call_type, callee_number);
}

TUP_RESULT huawei_tup_call_accept_call_with_lineid(IN TUP_UINT32 callid, IN TUP_UINT32 lineid, IN TUP_BOOL is_video)
{
    return tup_call_accept_call_with_lineid(callid, lineid,is_video);
}

TUP_RESULT huawei_tup_call_end_call_with_cause(IN TUP_UINT32 callid, IN TUP_UINT32 cause)
{
    return tup_call_end_call_with_cause(callid,cause);
}

TUP_RESULT huawei_tup_call_end_allcall(TUP_VOID)
{
    return tup_call_end_allcall();
}

TUP_RESULT huawei_tup_call_reinvite(IN TUP_UINT32 callid)
{
    return tup_call_reinvite(callid);
}

TUP_RESULT huawei_tup_call_send_diaglog_info(IN TUP_UINT32 callid, IN CALL_S_DIALOG_INFO *dialog_info)
{
    return tup_call_send_diaglog_info(callid, dialog_info);
}

TUP_RESULT huawei_tup_call_ctd_get_list(TUP_VOID)
{
    return tup_call_ctd_get_list();
}

TUP_RESULT huawei_tup_call_start_call_ex(IN CALL_S_CALL_PARAMS* call_params)
{
    return tup_call_start_call_ex(call_params);
}

TUP_RESULT huawei_tup_call_ctd_destroy_call(IN TUP_UINT32 callid)
{
    return tup_call_ctd_destroy_call(callid);
}

TUP_RESULT huawei_tup_call_consult_transfer(IN TUP_UINT32 callid, IN const TUP_UINT32 transto_callid)
{
    return tup_call_consult_transfer(callid, transto_callid);
}

TUP_RESULT huawei_tup_call_get_account_callids(IN TUP_UINT32 account_id, OUT TUP_UINT32* callids, IO TUP_UINT32* callsnum)
{
    return tup_call_get_account_callids(account_id, callids, callsnum);
}

TUP_RESULT huawei_tup_call_get_callstatics(OUT CALL_S_STREAM_INFO* state)
{
    return tup_call_get_callstatics(state);
}

TUP_RESULT huawei_tup_call_get_channelinfo(IN TUP_UINT32 accountid, IN CALL_S_STREAM_INFO* streaminfo)
{
    return tup_call_get_channelinfo(accountid, streaminfo);
}

TUP_RESULT huawei_tup_call_reply_del_video(IN TUP_UINT32 callid, IN TUP_BOOL is_accept)
{
    return tup_call_reply_del_video(callid, is_accept);
}

TUP_RESULT huawei_tup_call_create_video_window(IN TUP_UINT32 count, IN const CALL_S_VIDEOWND_INFO* window)
{
    return tup_call_create_video_window(count, window);
}

TUP_RESULT huawei_tup_call_update_video_window(IN TUP_UINT32 count, IN const CALL_S_VIDEOWND_INFO * window, IN TUP_UINT32 callid)
{
    return tup_call_update_video_window(count, window, callid);
}

TUP_RESULT huawei_tup_call_destroy_video_window(IN CALL_E_VIDEOWND_TYPE wndtype)
{
    return tup_call_destroy_video_window(wndtype);
}

TUP_RESULT huawei_tup_call_change_video_window(IN TUP_UINT32 ctrl_type, IN const CALL_S_VIDEOWND_INFO* window)
{
    return tup_call_change_video_window(ctrl_type, window);
}

TUP_RESULT huawei_tup_call_open_local_preview_in_dialog(IN TUP_UINT32 callid)
{
    return tup_call_open_local_preview_in_dialog(callid);
}

TUP_RESULT huawei_tup_call_close_local_preview_in_dialog(IN TUP_UINT32 callid)
{
    return tup_call_close_local_preview_in_dialog(callid);
}

TUP_RESULT huawei_tup_call_open_remote_preview_in_dialog(IN TUP_UINT32 callid)
{
    return tup_call_open_remote_preview_in_dialog(callid);
}

TUP_RESULT huawei_tup_call_close_remote_preview_in_dialog(IN TUP_UINT32 callid)
{
    return tup_call_close_remote_preview_in_dialog(callid);
}

TUP_RESULT huawei_tup_call_open_audio_preview(TUP_VOID)
{
    return tup_call_open_audio_preview();
}

TUP_RESULT huawei_tup_call_close_audio_preview(TUP_VOID)
{
    return tup_call_close_audio_preview();
}

TUP_RESULT huawei_tup_call_get_aux_tokenstate(TUP_UINT32 callid, CALL_E_AUX_TOKEN_STATE *pTokenState)
{
    return tup_call_get_aux_tokenstate(callid,pTokenState);
}

TUP_RESULT huawei_tup_call_media_mute_speak(IN TUP_UINT32 callid, IN TUP_BOOL is_on)
{
    return tup_call_media_mute_speak(callid, is_on);
}

TUP_RESULT huawei_tup_call_media_mute_video(IN TUP_UINT32 callid, IN TUP_BOOL is_mute)
{
    return tup_call_media_mute_video(callid, is_mute);
}

TUP_RESULT huawei_tup_call_media_set_audio_outdev(IN CALL_E_AUDDEV_ROUTE route_dev)
{
    return tup_call_media_set_audio_outdev( route_dev);
}

TUP_RESULT huawei_tup_call_media_set_audio_indev(IN CALL_E_AUDDEV_ROUTE route_dev)
{
    return tup_call_media_set_audio_indev(route_dev);
}

TUP_RESULT huawei_tup_call_media_set_audio_ingain(IN TUP_FLOAT in_gain)
{
    return tup_call_media_set_audio_ingain(in_gain);
}

TUP_RESULT huawei_tup_call_media_get_audio_ingain(OUT TUP_FLOAT* in_gain)
{
    return tup_call_media_get_audio_ingain(in_gain);
}

TUP_RESULT huawei_tup_call_media_set_audio_outgain(IN TUP_FLOAT out_gain)
{
    return tup_call_media_set_audio_outgain(out_gain);
}

TUP_RESULT huawei_tup_call_media_get_audio_outgain(OUT TUP_FLOAT* out_gain)
{
    return tup_call_media_get_audio_outgain(out_gain);
}

TUP_RESULT huawei_tup_call_media_enable_audioengine(IN TUP_BOOL enable)
{
    return tup_call_media_enable_audioengine(enable);
}

TUP_RESULT huawei_tup_call_media_startplay_ex(IN CALL_S_MEDIA_PLAY_PARAM* media_play_param, OUT TUP_INT32* play_handle)
{
    return tup_call_media_startplay_ex(media_play_param,play_handle);
}

TUP_RESULT huawei_tup_call_media_startTcplay(IN TUP_INT32 tc_file_value, OUT TUP_INT32* play_handle)
{
    return tup_call_media_startTcplay(tc_file_value, play_handle);
}

TUP_RESULT huawei_tup_call_media_startLocalplay(IN TUP_UINT32 loops, IN const TUP_CHAR* play_file, OUT TUP_INT32* play_handle)
{
    return tup_call_media_startLocalplay(loops,  play_file,play_handle);
}

TUP_RESULT huawei_tup_call_media_stop_signal_tone(IN TUP_UINT32 sender_handle)
{
    return tup_call_media_stop_signal_tone(sender_handle);
}

TUP_RESULT huawei_tup_call_media_play_signal_tone(IN TUP_UINT32 toneid, IN TUP_BOOL is_cycle, IN TUP_UINT32 sender_handle)
{
    return tup_call_media_play_signal_tone(toneid, is_cycle,sender_handle);
}

TUP_RESULT huawei_tup_call_media_play_signal_tone_to_conf(IN TUP_UINT32 toneid, IN TUP_BOOL iscycle, IN TUP_UINT32 sender_handle)
{
    return tup_call_media_play_signal_tone_to_conf(toneid, iscycle, sender_handle);
}

TUP_RESULT huawei_tup_call_media_stop_signal_tone_to_conf(IN TUP_UINT32 senderhandle)
{
    return tup_call_media_stop_signal_tone_to_conf(senderhandle);
}

TUP_RESULT huawei_tup_call_media_get_speak_level(OUT TUP_UINT32* level)
{
    return tup_call_media_get_speak_level(level);
}

TUP_RESULT huawei_tup_call_media_set_mic_volume(IN CALL_E_AUDDEV_ROUTE aud_direction, IN TUP_UINT32 volume)
{
    return tup_call_media_set_mic_volume(aud_direction,volume);
}

TUP_RESULT huawei_tup_call_media_get_mic_volume(OUT TUP_UINT32* volume)
{
    return tup_call_media_get_mic_volume(volume);
}

TUP_RESULT huawei_tup_call_media_get_mic_level(OUT TUP_UINT32* level)
{
    return tup_call_media_get_mic_level(level);
}

TUP_RESULT huawei_tup_call_media_get_sys_spk_mute(OUT TUP_BOOL* is_mute)
{
    return tup_call_media_get_sys_spk_mute(is_mute);
}

TUP_RESULT huawei_tup_call_media_get_sys_mic_mute(OUT TUP_BOOL* is_mute)
{
    return tup_call_media_get_sys_mic_mute(is_mute);
}

TUP_RESULT huawei_tup_call_media_get_hdaccelerate(OUT CALL_S_VIDEO_HDACCELERATE *hd_accelerate)
{
    return tup_call_media_get_hdaccelerate(hd_accelerate);
}

TUP_RESULT huawei_tup_call_media_play_ring_tone(IN const TUP_INT8* ringfile, IN TUP_UINT32 senderhandler)
{
    return tup_call_media_play_ring_tone(ringfile,senderhandler);
}

TUP_RESULT huawei_tup_call_media_stop_ring_tone(IN TUP_UINT32 senderhandler)
{
    return tup_call_media_stop_ring_tone(senderhandler);
}

TUP_RESULT huawei_tup_call_play_signaltone(IN TUP_UINT32 callid, IN CALL_E_SIGTONE_TYPE tone)
{
    return tup_call_play_signaltone(callid,tone);
}

TUP_RESULT huawei_tup_call_stop_signaltone(IN TUP_UINT32 callid)
{
    return tup_call_stop_signaltone(callid);
}

TUP_RESULT huawei_tup_call_media_startrecord(IN TUP_UINT32 callid, IN const TUP_CHAR* file_name, IN TUP_BOOL is_video)
{
    return tup_call_media_startrecord(callid,file_name,is_video);
}

TUP_RESULT huawei_tup_call_media_stoprecord(IN TUP_UINT32 callid)
{
    return tup_call_media_stoprecord(callid);
}

TUP_RESULT huawei_tup_call_set_audio_dev_options(IN TUP_UINT32 anc, IN TUP_UINT32 aec, IN TUP_UINT32 agc)
{
    return tup_call_set_audio_dev_options(anc,aec,agc);
}

TUP_RESULT huawei_tup_call_set_AEC_params(IN const CALL_S_AUDIO_AEC_PARAMS* aec_params)
{
    return tup_call_set_AEC_params(aec_params);
}

TUP_RESULT huawei_tup_call_set_EQ_param(IN const CALL_S_AUDIO_EQ_CONFIG* pstEqConfig, IN CALL_E_AO_DEV enAudDirection)
{
    return tup_call_set_EQ_param(pstEqConfig,enAudDirection);
}

TUP_RESULT huawei_tup_call_get_EQ_param(IN CALL_S_AUDIO_EQ_CONFIG* pstEqConfig, IN CALL_E_AO_DEV enAudDirection)
{
    return tup_call_get_EQ_param(pstEqConfig,enAudDirection);
}

TUP_RESULT huawei_tup_call_set_preset_EQ_param(IN CALL_E_PRESET_EQ_TYPE enPresetEqType){
    return tup_call_set_preset_EQ_param(enPresetEqType);
}

TUP_RESULT huawei_tup_call_set_hardware_params(IN const CALL_S_HARDWARE_PARAMS* hardwareparams)
{
    return tup_call_set_hardware_params(hardwareparams);
}

TUP_RESULT huawei_tup_call_get_hardware_params(IN CALL_S_HARDWARE_PARAMS* hardwareparams)
{
    return tup_call_get_hardware_params(hardwareparams);
}

TUP_RESULT huawei_tup_call_set_vpuorder_enable(IN TUP_BOOL is_enable)
{
    return tup_call_set_vpuorder_enable(is_enable);
}

TUP_RESULT huawei_tup_call_enable_cabac_encode(IN TUP_UINT32 callid, IN TUP_BOOL is_enable, IN CALL_E_MEDIATYPE media_type)
{
    return tup_call_enable_cabac_encode(callid,is_enable, media_type);
}

TUP_RESULT huawei_tup_call_change_video_window_pos(IN CALL_E_VIDEOWND_TYPE wndtype, IN const TUP_INT32 coordinate[CALL_E_COORDINATE_BUTT])
{
    return tup_call_change_video_window_pos(wndtype, coordinate);
}

TUP_RESULT huawei_tup_call_change_video_window_type(IN CALL_E_VIDEOWND_TYPE wndtype, IN TUP_UINT32 displaytype)
{
    return tup_call_change_video_window_type(wndtype,displaytype);
}

TUP_RESULT huawei_tup_call_set_video_collect_mode(IN TUP_UINT32 ulCallID, IN TUP_UINT32 uiCollectMode)
{
    return tup_call_set_video_collect_mode(ulCallID, uiCollectMode);
}

TUP_RESULT huawei_tup_call_set_video_render(IN TUP_UINT32 callid, IN const CALL_S_VIDEO_RENDER_INFO* render)
{
    return tup_call_set_video_render(callid,render);
}

TUP_RESULT huawei_tup_call_set_capture_rotation(IN TUP_UINT32 callid, IN TUP_UINT32 capture_index, IN TUP_UINT32 capture_rotation)
{
    return tup_call_set_capture_rotation(callid,capture_index,capture_rotation);
}

TUP_RESULT huawei_tup_call_set_display_rotation(IN TUP_UINT32 callid, IN TUP_UINT32 render_type, IN TUP_UINT32 rotation)
{
    return tup_call_set_display_rotation(callid,render_type,rotation);
}

TUP_RESULT huawei_tup_call_serverconf_transferto_conf_non_refer(IN TUP_UINT32 callid, OUT TUP_UINT32 *confid, IN const TUP_CHAR *groupuri)
{
    return tup_call_serverconf_transferto_conf_non_refer(callid,confid,groupuri);
}

TUP_RESULT huawei_tup_call_serverconf_transferto_conf_ex(TUP_UINT32 callid, TUP_UINT32 transto_callid)
{
    return tup_call_serverconf_transferto_conf_ex(callid,transto_callid);
}

TUP_RESULT huawei_tup_call_serverconf_hold(IN TUP_UINT32 confid)
{
    return tup_call_serverconf_hold(confid);
}

TUP_RESULT huawei_tup_call_serverconf_unhold(IN TUP_UINT32 confid)
{
    return tup_call_serverconf_unhold(confid);
}

TUP_RESULT huawei_tup_call_serverconf_p2p_transferto_dataconf(OUT TUP_UINT32* confid, OUT TUP_UINT32* callid, IN TUP_UINT32 p2p_callid, IN const TUP_CHAR* groupuri)
{
    return tup_call_serverconf_p2p_transferto_dataconf(confid, callid, p2p_callid, groupuri);
}

TUP_RESULT huawei_tup_call_serverconf_create_confid(OUT TUP_UINT32 *confid, OUT TUP_UINT32 *callid)
{
    return tup_call_serverconf_create_confid(confid, callid);
}

TUP_RESULT huawei_tup_call_serverconf_set_type(IN TUP_UINT32 confid, IN TUP_UINT32 type)
{
    return tup_call_serverconf_set_type(confid,type);
}

TUP_RESULT huawei_tup_call_serverconf_create_by_confid(IN TUP_UINT32 confid, IN const TUP_CHAR *groupuri)
{
    return tup_call_serverconf_create_by_confid(confid,groupuri);
}

TUP_RESULT huawei_tup_call_serverconf_create_confid_ex (IN TUP_UINT32 accountid,
                                                        IN TUP_UINT32 incallid , OUT TUP_UINT32* confid, OUT TUP_UINT32* outcallid)
														{
    return tup_call_serverconf_create_confid_ex (accountid,
                                                        incallid , confid, outcallid);
}

TUP_RESULT huawei_tup_call_serverconf_accept_with_lineid(IN TUP_UINT32 confid, IN TUP_UINT32 lineid)
{
    return tup_call_serverconf_accept_with_lineid(confid, lineid);
}

TUP_RESULT huawei_tup_call_serverconf_add_extra_num(IN TUP_UINT32 confid, IN const TUP_CHAR *number)
{
    return tup_call_serverconf_add_extra_num(confid, number);
}

TUP_RESULT huawei_tup_call_serverconf_reject_p2pdataconf(IN TUP_UINT32 confid)
{
    return tup_call_serverconf_reject_p2pdataconf(confid);
}

TUP_RESULT huawei_tup_call_serverconf_access_reserved_conf_directly(IN TUP_UINT32 callid, IN const TUP_CHAR *accesscode)
{
    return tup_call_serverconf_access_reserved_conf_directly(callid,accesscode);
}

TUP_RESULT huawei_tup_call_serverconf_set_confsubject(IN TUP_UINT32 confid, IN const TUP_CHAR* confsubject)
{
    return tup_call_serverconf_set_confsubject(confid, confsubject);
}

TUP_RESULT huawei_tup_call_leave_all_server_conf(TUP_VOID)
{
    return tup_call_leave_all_server_conf();
}

TUP_RESULT huawei_tup_call_end_all_server_conf(TUP_VOID)
{
    return tup_call_end_all_server_conf();
}

TUP_RESULT huawei_tup_call_serverconf_merger(IN TUP_UINT32 confid, IN const TUP_CHAR* security_conf_num){
    return tup_call_serverconf_merger(confid,security_conf_num);
}

TUP_RESULT huawei_tup_call_serverconf_split(IN TUP_UINT32 confid, IN const TUP_CHAR* security_conf_num){
    return tup_call_serverconf_split(confid, security_conf_num);
}

TUP_RESULT huawei_tup_call_get_all_conf_list(TUP_VOID){
    return tup_call_get_all_conf_list();
}

TUP_RESULT huawei_tup_call_get_conf_list_for_account(IN TUP_UINT32 accountid, IN TUP_UINT32 pagesize, IN TUP_UINT32 curpage){
    return tup_call_get_conf_list_for_account(accountid, pagesize, curpage);
}

TUP_RESULT huawei_tup_call_serverconf_set_linked(IN TUP_UINT32 callid, IN TUP_BOOL islink)
{
    return tup_call_serverconf_set_linked(callid,islink);
}

TUP_RESULT huawei_tup_call_serverconf_send_DTMF(IN TUP_UINT32 confid, IN CALL_E_DTMF_TONE keyevt)
{
    return tup_call_serverconf_send_DTMF(confid,keyevt);
}

TUP_RESULT huawei_tup_call_serverconf_add_p2p_to_dataconf(IN TUP_UINT32 confid, IN const TUP_CHAR* p2p_number)
{
    return tup_call_serverconf_add_p2p_to_dataconf(confid, p2p_number);
}

TUP_RESULT huawei_tup_call_serverconf_get_securitynum(IN TUP_UINT32 confid, OUT TUP_CHAR* security_num, IN TUP_UINT32 numsize)
{
    return tup_call_serverconf_get_securitynum(confid,security_num,numsize);
}

TUP_RESULT huawei_tup_call_create_linkage_conf(IN TUP_UINT32 confid,
                                               IN TUP_UINT32 attendcount, IN const  TUP_CHAR* attendnumber, IN TUP_UINT32 pernumsize){
    return tup_call_create_linkage_conf(confid,
                                               attendcount,  attendnumber, pernumsize);
}

TUP_RESULT huawei_tup_call_videoconf_create_wnd(IN TUP_UINT32 confid, IN const CALL_S_VIDEOWND_INFO* videowndinfo, IN TUP_UINT32 wndnum){
    return tup_call_videoconf_create_wnd(confid, videowndinfo, wndnum);
}

TUP_RESULT huawei_tup_call_videoconf_destroy_wnd(IN TUP_UINT32 confid)
{
    return tup_call_videoconf_destroy_wnd(confid);
}

TUP_RESULT huawei_tup_call_videoconf_open_self_video(IN TUP_UINT32 confid)
{
    return tup_call_videoconf_open_self_video(confid);
}

TUP_RESULT huawei_tup_call_videoconf_close_self_video(IN TUP_UINT32 confid)
{
    return tup_call_videoconf_close_self_video(confid);
}

TUP_RESULT huawei_tup_call_videoconf_notify_attend_open_video(IN TUP_UINT32 confid, IN const TUP_CHAR* attendnum)
{
    return tup_call_videoconf_notify_attend_open_video(confid,attendnum);
}

TUP_RESULT huawei_tup_call_videoconf_notify_attend_close_video(IN TUP_UINT32 confid, IN const TUP_CHAR* attendnum)
{
    return tup_call_videoconf_notify_attend_close_video(confid, attendnum);
}

TUP_RESULT huawei_tup_call_videoconf_attach_attend_video_to_wnd(IN TUP_UINT32 confid,
                                                                IN const TUP_CHAR* attendnum, IN TUP_UINT32 wndid, IN TUP_UINT32 ishighstream)
																{
    return tup_call_videoconf_attach_attend_video_to_wnd(confid,
                                                                attendnum,  wndid, ishighstream);
}

TUP_RESULT huawei_tup_call_videoconf_detach_attend_video_from_wnd(IN TUP_UINT32 confid,
                                                           IN const TUP_CHAR* attendnum, IN TUP_UINT32 wndid)
														   {
    return tup_call_videoconf_detach_attend_video_from_wnd(confid, attendnum,wndid);
}

TUP_RESULT huawei_tup_call_videoconf_change_wnd_size(IN TUP_UINT32 confid, IN TUP_UINT32 wndid, IN const CALL_S_VIDEOWND_INFO* wndinfo){
    return tup_call_videoconf_change_wnd_size(confid,wndid,wndinfo);
}

TUP_RESULT huawei_tup_call_videoconf_switch_attend_video_resolution(IN TUP_UINT32 confid, IN const TUP_CHAR* attendnum, IN TUP_UINT32 ishighresolution){
    return tup_call_videoconf_switch_attend_video_resolution(confid,attendnum,ishighresolution);
}

TUP_RESULT huawei_tup_call_videoconf_close_self_all_video(IN TUP_UINT32 confid){
    return tup_call_videoconf_close_self_all_video(confid);
}

TUP_RESULT huawei_tup_call_videoconf_pause_attend_local_video(IN TUP_UINT32 confid, IN const TUP_CHAR* attendnum){
    return tup_call_videoconf_pause_attend_local_video(confid,attendnum);
}

TUP_RESULT huawei_tup_call_videoconf_resume_attend_local_video(IN TUP_UINT32 confid, IN const TUP_CHAR* attendnum)
{
    return tup_call_videoconf_resume_attend_local_video(confid,attendnum);
}

TUP_RESULT huawei_tup_call_videoconf_change_wnd_zorder(IN TUP_UINT32 confid, IN TUP_UINT32 zorder, IN TUP_UINT32 wndid)
{
    return tup_call_videoconf_change_wnd_zorder(confid,zorder,wndid);
}

TUP_RESULT huawei_tup_call_videoconf_voiceconf_tranfto_videoconf(IN TUP_UINT32 confid)
{
    return tup_call_videoconf_voiceconf_tranfto_videoconf(confid);
}

TUP_RESULT huawei_tup_call_videoconf_change_wnd_pos(IN TUP_UINT32 confid, IN const CALL_S_VIDEOWND_INFO* videoinfo, IN TUP_UINT32 infocount)
{
    return tup_call_videoconf_change_wnd_pos(confid, videoinfo,infocount);
}

TUP_RESULT huawei_tup_call_videoconf_open_preview(IN TUP_UINT32 confid, IN TUP_UINT32 wndid, IN const CALL_S_VIDEOCONF_VIDEO_PARAM* videoparam)
{
    return tup_call_videoconf_open_preview(confid,wndid,videoparam);
}

TUP_RESULT huawei_tup_call_videoconf_close_preview(IN TUP_UINT32 confid)
{
    return tup_call_videoconf_close_preview(confid);
}

TUP_RESULT huawei_tup_call_videoconf_get_video_device_status(IN TUP_UINT32 confid, IN const TUP_CHAR* attendnum)
{
    return tup_call_videoconf_get_video_device_status(confid,attendnum);
}

TUP_RESULT huawei_tup_call_localconf_get_conferstate(IN CALL_S_CONFER_LOCAL_INFO* confinfo)
{
    return tup_call_localconf_get_conferstate(confinfo);
}

TUP_RESULT huawei_tup_call_localconf_mute_self(IN TUP_UINT32 callid)
{
    return tup_call_localconf_mute_self(callid);
}

TUP_RESULT huawei_tup_call_localconf_unmute_self(IN TUP_UINT32 callid)
{
    return tup_call_localconf_unmute_self(callid);
}

TUP_RESULT huawei_tup_call_localconf_hold(TUP_VOID)
{
    return tup_call_localconf_hold();
}

TUP_RESULT huawei_tup_call_localconf_unhold(TUP_VOID)
{
    return tup_call_localconf_unhold();
}

TUP_RESULT huawei_tup_call_localconf_create(IN TUP_UINT32 call_id)
{
    return tup_call_localconf_create(call_id);
}

TUP_RESULT huawei_tup_call_localconf_join(IN TUP_UINT32 call_id)
{
    return tup_call_localconf_join(call_id);
}

TUP_RESULT huawei_tup_call_localconf_drop_conferee(IN TUP_UINT32 call_id){
    return tup_call_localconf_drop_conferee(call_id);
}

TUP_RESULT huawei_tup_call_localconf_mute_conferee(IN TUP_UINT32 call_id)
{
	return tup_call_localconf_mute_conferee(call_id);
}

TUP_RESULT huawei_tup_call_localconf_unmute_conferee(IN TUP_UINT32 call_id)
{
    return tup_call_localconf_unmute_conferee(call_id);
}

TUP_RESULT huawei_tup_call_localconf_end(TUP_VOID)
{
    return tup_call_localconf_end();
}

TUP_RESULT huawei_tup_call_joint_setting(IN TUP_UINT32 accountid, IN TUP_BOOL right, IN const char* linkage_number)
{
    return tup_call_joint_setting(accountid,right,linkage_number);
}

TUP_RESULT huawei_tup_call_joint_start(TUP_VOID)
{
    return tup_call_joint_start();
}

TUP_RESULT huawei_tup_call_joint_stop(TUP_VOID)
{
    return tup_call_joint_stop();
}

TUP_RESULT huawei_tup_call_joint_switch(TUP_VOID)
{
    return tup_call_joint_switch();
}

TUP_RESULT huawei_tup_call_joint_sync_ipt_service(IN TUP_UINT32 accountid, IN CALL_E_SERVICE_CALL_TYPE servicetype)
{
    return tup_call_joint_sync_ipt_service(accountid,servicetype);
}

TUP_RESULT huawei_tup_call_joint_uptoconference(TUP_VOID)
{
    return tup_call_joint_uptoconference();
}

TUP_RESULT huawei_tup_call_joint_conf_result(IN TUP_UINT32 result)
{
    return tup_call_joint_conf_result(result);
}

TUP_RESULT huawei_tup_call_get_service_code(IN TUP_UINT32 account_id, IN CALL_S_IPT_DATA *ipt_data, OUT TUP_CHAR code[], IN TUP_UINT32 size)
{
    return tup_call_get_service_code(account_id, ipt_data, code, size);
}

TUP_RESULT huawei_tup_call_sync_service_right(TUP_VOID)
{
    return tup_call_sync_service_right();
}

TUP_RESULT huawei_tup_call_reload_serviceright(TUP_VOID)
{
    return tup_call_reload_serviceright();
}

TUP_RESULT huawei_tup_call_update_serviceright(IN TUP_UINT32 accountid, IN const CALL_S_SERVICERIGHT_CFG* servicecfg)
{
    return tup_call_update_serviceright(accountid,servicecfg);
}

TUP_RESULT huawei_tup_call_set_service_register(IN TUP_UINT32 accountid,
                                                IN CALL_E_SERVICE_RIGHT_TYPE service_type, IN TUP_UINT32 reg, IN const TUP_CHAR* param)
												{
    return tup_call_set_service_register(accountid,
                                                service_type, reg, param);
}

TUP_RESULT huawei_tup_call_get_serviceright(IN TUP_UINT32 accountid, OUT CALL_S_SERVICERIGHT_CFG* servicecfg)
{
    return tup_call_get_serviceright(accountid, servicecfg);
}

TUP_RESULT huawei_tup_call_set_DND_for_account(IN TUP_UINT32 account_id)
{
    return tup_call_set_DND_for_account( account_id);
}

TUP_RESULT huawei_tup_call_cancel_DND_for_account(IN TUP_UINT32 account_id)
{
    return tup_call_cancel_DND_for_account( account_id);
}

TUP_RESULT huawei_tup_call_set_alertsilence_on(IN TUP_UINT32 account_id)
{
    return tup_call_set_alertsilence_on(account_id);
}

TUP_RESULT huawei_tup_call_set_alertsilence_off(IN TUP_UINT32 account_id)
{
    return tup_call_set_alertsilence_off(account_id);
}

TUP_RESULT huawei_tup_call_set_privacy_on(IN TUP_UINT32 account_id)
{
    return tup_call_set_privacy_on(account_id);
}

TUP_RESULT huawei_tup_call_set_privacy_off(IN TUP_UINT32 account_id)
{
    return tup_call_set_privacy_off(account_id);
}

TUP_RESULT huawei_tup_call_pnotification_holdcall(IN TUP_UINT32 callid)
{
    return tup_call_pnotification_holdcall(callid);
}

TUP_RESULT huawei_tup_call_pnotification_unholdcall(IN TUP_UINT32 callid)
{
    return tup_call_pnotification_unholdcall(callid);
}

TUP_RESULT huawei_tup_call_server_recordcall_on(IN TUP_UINT32 callid)
{
    return tup_call_server_recordcall_on(callid);
}

TUP_RESULT huawei_tup_call_server_recordcall_off(IN TUP_UINT32 callid)
{
    return tup_call_server_recordcall_off(callid);
}

TUP_RESULT huawei_tup_call_callback(IN TUP_UINT32 account_id, IN const TUP_CHAR* callee_number)
{
    return tup_call_callback(account_id, callee_number);
}

TUP_RESULT huawei_tup_call_cancel_callback(IN TUP_UINT32 account_id, IN const TUP_CHAR* callee_number)
{
    return tup_call_cancel_callback(account_id, callee_number);
}

TUP_RESULT huawei_tup_call_get_callpark(IN TUP_UINT32 callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* pszparknum)
{
    return tup_call_get_callpark(callid,call_type, pszparknum);
}

TUP_RESULT huawei_tup_call_SCA_in_bridgeconf(IN TUP_UINT32 callid)
{
    return tup_call_SCA_in_bridgeconf(callid);
}

TUP_RESULT huawei_tup_call_progkey_modify_ind(IN TUP_INT32 broad_id, IN const TUP_INT32* keys, IN TUP_INT32 number)
{
    return tup_call_progkey_modify_ind(broad_id, keys, number);
}

TUP_RESULT huawei_tup_call_set_SCA_private(IN TUP_UINT32 accountid, IN CALL_E_SERVICE_CALL_TYPE calltype)
{
    return tup_call_set_SCA_private(accountid,calltype);
}

TUP_RESULT huawei_tup_call_group_pickup(IN TUP_UINT32 callid, IN CALL_E_CALL_TYPE call_type)
{
    return tup_call_group_pickup(callid,call_type);
}

TUP_RESULT huawei_tup_call_group_pickup_ex(IN TUP_UINT32 ulCallID, IN CALL_E_CALL_TYPE call_type, IN const CALL_S_PICKUP_INFO * group_packup_info)
{
    return tup_call_group_pickup_ex(ulCallID,call_type,group_packup_info);
}

TUP_RESULT huawei_tup_call_forward_config(IN const CALL_S_FORWARD_INFO* fwdconfig , IN TUP_UINT32 configcount){
    return tup_call_forward_config(fwdconfig , configcount);
}

TUP_RESULT huawei_tup_call_intercom_call(IN TUP_UINT32 callid, IN const TUP_CHAR* callee_number)
{
    return tup_call_intercom_call(callid,callee_number);
}

TUP_RESULT huawei_tup_call_VVM_listen(IN TUP_UINT32 callid,  IN const TUP_CHAR* callee_number)
{
    return tup_call_VVM_listen( callid, callee_number);
}

TUP_RESULT huawei_tup_call_VVM_query(IN const CALL_S_VVM_QUERY_MSG* query)
{
    return tup_call_VVM_query(query);
}

TUP_RESULT huawei_tup_call_VVM_forward(IN const CALL_S_VVM_FWD_MSG* fwd)
{
    return tup_call_VVM_forward(fwd);
}

TUP_RESULT huawei_tup_call_VVM_delete(IN const CALL_S_VVM_DEL_MSG* del)
{
    return tup_call_VVM_delete(del);
}

TUP_RESULT huawei_tup_call_VVM_pausal(IN TUP_UINT32 callid)
{
    return tup_call_VVM_pausal(callid);
}

TUP_RESULT huawei_tup_call_VVM_fast_forward(IN TUP_UINT32 callid)
{
    return tup_call_VVM_fast_forward(callid);
}

TUP_RESULT huawei_tup_call_VVM_rewind(IN TUP_UINT32 callid)
{
    return tup_call_VVM_rewind(callid);
}

TUP_RESULT huawei_tup_call_set_DICF_switct(IN TUP_UINT32 accountid, IN TUP_BOOL switches)
{
    return tup_call_set_DICF_switct(accountid, switches);
}

TUP_RESULT huawei_tup_call_set_all_account_DND_on(TUP_VOID)
{
    return tup_call_set_all_account_DND_on();
}

TUP_RESULT huawei_tup_call_set_all_account_DND_off(TUP_VOID)
{
    return tup_call_set_all_account_DND_off();
}

TUP_RESULT huawei_tup_call_set_all_account_absent_on(TUP_VOID)
{
    return tup_call_set_all_account_absent_on();
}

TUP_RESULT huawei_tup_call_set_all_account_absent_off(TUP_VOID)
{
    return tup_call_set_all_account_absent_off();
}

TUP_RESULT huawei_tup_call_set_MCID(IN TUP_UINT32 accountid)
{
    return tup_call_set_MCID(accountid);
}

TUP_RESULT huawei_tup_call_set_IPTservice_batch(IN const CALL_S_IPT_DATA* IPTdata)
{
    return tup_call_set_IPTservice_batch(IPTdata);
}

TUP_RESULT huawei_tup_call_set_IPTservice_for_accout(IN TUP_UINT32 accountid, IN CALL_S_IPT_DATA* IPTdata)
{
    return tup_call_set_IPTservice_for_accout(accountid,IPTdata);
}

TUP_RESULT huawei_tup_call_set_callbarring_for_account(IN TUP_UINT32 accountid, IN const CALL_S_IPT_DATA* IPTdata)
{
    return tup_call_set_callbarring_for_account( accountid,IPTdata);
}

TUP_RESULT huawei_tup_call_cancel_callbarring_for_account(IN TUP_UINT32 accountid, IN const CALL_S_IPT_DATA* IPTdata)
{
    return tup_call_cancel_callbarring_for_account(accountid,IPTdata);
}

TUP_RESULT huawei_tup_call_set_absent_for_account(IN TUP_UINT32 accountid)
{
    return tup_call_set_absent_for_account(accountid);
}

TUP_RESULT huawei_tup_call_cancel_absent_for_account(IN TUP_UINT32 accountid)
{
    return tup_call_cancel_absent_for_account(accountid);
}

TUP_RESULT huawei_tup_call_publish_setting_status(IN TUP_UINT32 account_id, IN TUP_UINT32 status_type)
{
    return tup_call_publish_setting_status(account_id,status_type);
}

TUP_RESULT huawei_tup_call_mobile_extend_call(IN TUP_UINT32 callid, IN const TUP_CHAR* pszMPNum)
{
    return tup_call_mobile_extend_call(callid, pszMPNum);
}

TUP_RESULT huawei_tup_call_answer_intercom_call(IN TUP_UINT32 callid)
{
    return tup_call_answer_intercom_call(callid);
}

TUP_RESULT huawei_tup_call_direct_callpark(IN TUP_UINT32 callid, IN const TUP_CHAR* direct_num)
{
    return tup_call_direct_callpark(callid, direct_num);
}

TUP_RESULT huawei_tup_call_callpark(IN TUP_UINT32 callid)
{
    return tup_call_callpark(callid);
}

TUP_RESULT huawei_tup_call_private_hold_call (IN TUP_UINT32 callid)
{
    return tup_call_private_hold_call (callid);
}

TUP_RESULT huawei_tup_call_abbrdial_Call(IN TUP_UINT32 callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* callee_number)
{
    return tup_call_abbrdial_Call(callid,call_type, callee_number);
}

TUP_RESULT huawei_tup_call_point_pickup(IN TUP_UINT32 callid, IN CALL_E_CALL_TYPE call_type, IN const TUP_CHAR* callee_number)
{
    return tup_call_point_pickup(callid,call_type,callee_number);
}

TUP_RESULT huawei_tup_call_point_pickup_ex(IN TUP_UINT32 ulCallID, IN CALL_E_CALL_TYPE call_type, IN const CALL_S_PICKUP_INFO * point_packup_info)
{
    return tup_call_point_pickup_ex(ulCallID,call_type,point_packup_info);
}

TUP_RESULT huawei_tup_call_SCA_insert (IN TUP_UINT32 call_id)
{
    return tup_call_SCA_insert (call_id);
}

TUP_RESULT huawei_tup_call_SCA_retrieve (IN TUP_UINT32 call_id)
{
    return tup_call_SCA_retrieve (call_id);
}

TUP_RESULT huawei_tup_call_SCA_sub_state(IN TUP_UINT32 account_id)
{
    return tup_call_SCA_sub_state(account_id);
}

TUP_RESULT huawei_tup_call_SCA_offhook (IN TUP_UINT32 account_id, IN TUP_UINT32 sca_line_id)
{
    return tup_call_SCA_offhook (account_id, sca_line_id);
}

TUP_RESULT huawei_tup_call_SCA_onhook(IN TUP_UINT32 ulSipAccountID, IN TUP_UINT32 sca_line_id)
{
    return tup_call_SCA_onhook(ulSipAccountID,sca_line_id);
}

TUP_RESULT huawei_tup_call_onekey_transferto_VM(IN TUP_UINT32 callid, IN const TUP_CHAR* divert_number, IN TUP_BOOL is_callpicked)
{
    return tup_call_onekey_transferto_VM(callid,divert_number,is_callpicked);
}

TUP_RESULT huawei_tup_call_switch_DND_type(IN TUP_UINT32 DNDtype, IN TUP_UINT32 localDNDtype)
{
    return tup_call_switch_DND_type(DNDtype,localDNDtype);
}

TUP_RESULT huawei_tup_call_huntgroup_signin(IN TUP_UINT32 callid, IN const TUP_CHAR *group_number)
{
    return tup_call_huntgroup_signin(callid,group_number);
}

TUP_RESULT huawei_tup_call_huntgroup_signout(IN TUP_UINT32 callid, IN const TUP_CHAR *group_number)
{
    return tup_call_huntgroup_signout(callid,group_number);
}

TUP_RESULT huawei_tup_call_huntgroup_getstatus(IN TUP_UINT32 ulSipAccountID, OUT CALL_S_CONTACT_STATUS *pstStatus)
{
    return tup_call_huntgroup_getstatus(ulSipAccountID,pstStatus);
}

TUP_RESULT huawei_tup_call_paging_accept(IN TUP_UINT32 ulGroupID)
{
    return tup_call_paging_accept(ulGroupID);
}

TUP_RESULT huawei_tup_call_paging_end(IN TUP_UINT32 ulGroupID)
{
    return tup_call_paging_end(ulGroupID);
}

TUP_RESULT huawei_tup_call_contact_removed_indicate(IN TUP_UINT32 account_id, IN const TUP_CHAR* contact_number){
    return tup_call_contact_removed_indicate(account_id,contact_number);
}

TUP_RESULT huawei_tup_call_get_contact_status(IN TUP_UINT32 number, IO CALL_S_CONTACT_STATUS status[])
{
    return tup_call_get_contact_status(number,status);
}

TUP_RESULT huawei_tup_call_subscribe_contact(IN TUP_UINT32 account_id, IN TUP_UINT32 contact_type, IN const TUP_CHAR* contact_num){
    return tup_call_subscribe_contact(account_id, contact_type, contact_num);
}

TUP_RESULT huawei_tup_call_unsubscribe_contact(IN TUP_UINT32 account_id, IN TUP_UINT32 contact_type, IN const TUP_CHAR* contact_num)
{
    return tup_call_unsubscribe_contact(account_id,contact_type,contact_num);
}

TUP_RESULT huawei_tup_call_subscriber_RLS(IN TUP_UINT32 accountid)
{
    return tup_call_subscriber_RLS(accountid);
}

TUP_RESULT huawei_tup_call_unsubscriber_RLS(IN TUP_UINT32 accountid)
{
    return tup_call_unsubscriber_RLS(accountid);
}

TUP_RESULT huawei_tup_call_connect_tc(TUP_VOID)
{
    return tup_call_connect_tc();
}

TUP_RESULT huawei_tup_call_disconnect_tc(TUP_VOID){
    return tup_call_disconnect_tc();
}

TUP_RESULT huawei_tup_call_get_tc_ipaddr(OUT CALL_S_IF_INFO* inetaddr){
    return tup_call_get_tc_ipaddr(inetaddr);
}

TUP_RESULT huawei_tup_call_get_audio_mode(OUT TUP_UINT32* auido_mode)
{
    return tup_call_get_audio_mode(auido_mode);
}

TUP_RESULT huawei_tup_call_get_tc_log(TUP_VOID){
    return tup_call_get_tc_log();
}

TUP_RESULT huawei_tup_call_set_micdev_mute(OUT TUP_INT32 is_mute)
{
    return tup_call_set_micdev_mute(is_mute);
}

TUP_RESULT huawei_tup_call_set_spkdev_mute(IN TUP_INT32 is_mute)
{
    return tup_call_set_spkdev_mute(is_mute);
}

TUP_VOID* huawei_tup_call_get_notifiy_msg_by_msgbody(IN TUP_UINT8* msgbody)
{
    return tup_call_get_notifiy_msg_by_msgbody(msgbody);
}

TUP_VOID huawei_tup_call_set_client_name(IN const TUP_CHAR* client_name)
{
    return tup_call_set_client_name(client_name);
}

TUP_RESULT huawei_tup_call_set_notify_client_name(IN const TUP_CHAR* client_name, IN TUP_BOOL bIsUI, IN TUP_BOOL bIsReg)
{
    return tup_call_set_notify_client_name(client_name,bIsUI,bIsReg);
}

TUP_RESULT huawei_tup_call_register_process_notifiy_ex(IN CALL_FN_CALLBACK_PTR callback_process_notify)
{
    return tup_call_register_process_notifiy_ex(callback_process_notify);
}

TUP_RESULT huawei_tup_call_deregister_process_notifiy_ex(TUP_VOID)
{
    return tup_call_deregister_process_notifiy_ex();
}

TUP_RESULT huawei_tup_call_enable_test_callback(IN TUP_BOOL bEnable)
{
    return tup_call_enable_test_callback(bEnable);
}

TUP_RESULT huawei_tup_call_eqpt_test_start_record(IN CALL_E_AUDDEV_ROUTE audioinputdev, IN TUP_UINT32 volume,
                                                  IN TUP_UINT32 samplefreq, IN TUP_UINT32 bitwide, IN TUP_UINT32 recordtime, IN TUP_UINT32 audiotype)
												  {
    return tup_call_eqpt_test_start_record(audioinputdev, volume,
                                                  samplefreq,bitwide,recordtime,audiotype);
}

TUP_RESULT huawei_tup_call_eqpt_test_stop_record(IN CALL_E_AUDDEV_ROUTE audioinputdev)
{
    return tup_call_eqpt_test_stop_record(audioinputdev);
}

TUP_RESULT huawei_tup_call_eqpt_test_start_play(IN CALL_E_AUDDEV_ROUTE audiooutputdev,
                                                IN TUP_UINT32 volume, IN TUP_UINT32 samplefreq, IN TUP_UINT32 bitwide, IN TUP_UINT32 AMPtype)
												{
    return tup_call_eqpt_test_start_play(audiooutputdev,
                                                volume,samplefreq,bitwide,AMPtype);
}

TUP_RESULT huawei_tup_call_eqpt_test_stop_play(IN CALL_E_AUDDEV_ROUTE audiooutputdev)
{
    return tup_call_eqpt_test_stop_play(audiooutputdev);
}

TUP_RESULT huawei_tup_call_server_record(TUP_UINT32 callid, CALL_E_ID_TYPE record_type, TUP_BOOL record_on, TUP_UINT32 media_type)
{
    return tup_call_server_record(callid,record_type, record_on, media_type);
}

TUP_RESULT huawei_tup_call_set_blflist(TUP_UINT32 count, const CALL_S_BLF_ITEM *blf_array)
{
    return tup_call_set_blflist(count,blf_array);
}

TUP_RESULT       huawei_tup_call_get_call_info(TUP_UINT32 callid, CALL_E_CALL_INFO_ID infoid, TUP_VOID *val)
{
    return tup_call_get_call_info(callid,infoid,val);
}

TUP_RESULT       huawei_tup_call_register_call_event_proc(CALL_S_CALL_EVENT_PROC *callback_process_notify)
{
    return tup_call_register_call_event_proc(callback_process_notify);
}

TUP_RESULT       huawei_tup_call_set_mboile_video_orient(TUP_UINT32 ulCallID, TUP_UINT32 uiIndex, const CALL_S_VIDEO_ORIENT *pstVideoOrient)
{
    return tup_call_set_mboile_video_orient(ulCallID,uiIndex,pstVideoOrient);
}

TUP_RESULT       huawei_tup_call_set_mboile_video_render(TUP_UINT32 ulCallID, const CALL_S_VIDEO_RENDER_INFO *pstRender)
{
    return tup_call_set_mboile_video_render(ulCallID, pstRender);
}

TUP_RESULT       huawei_tup_call_start_H323_stack()
{
    return tup_call_start_H323_stack();
}

TUP_RESULT       huawei_tup_call_register_with_protocol
(const TUP_CHAR *            number,
 const TUP_CHAR *            name,
 const TUP_CHAR *            password,
 const CALL_S_REGISTER_MODE *regist_mode)
 {
    return tup_call_register_with_protocol
(number,
 name,
 password,
 regist_mode);
}

TUP_RESULT       huawei_tup_call_deregister_with_protocol(CALL_E_PROTOCOL_TYPE protocol)
{
    return tup_call_deregister_with_protocol(protocol);
}

TUP_RESULT       huawei_tup_call_deregister_advance(TUP_UINT32 accountid, CALL_E_PROTOCOL_TYPE protocol)
{
    return tup_call_deregister_advance(accountid,protocol);
}

TUP_RESULT       huawei_tup_call_create_callid_with_protocol
(IN CALL_E_PROTOCOL_TYPE  protocol,
 IN OUT CALL_E_CALL_TYPE *call_type,
 OUT TUP_UINT32 *         callid)
 {
    return tup_call_create_callid_with_protocol
(protocol,
 call_type,
 callid);
}

TUP_RESULT       huawei_tup_call_start_call_advance
(IN TUP_UINT32      call_id,
 IN const TUP_CHAR *callee_number)
 {
    return tup_call_start_call_advance
(call_id,
 callee_number);
}

TUP_RESULT       huawei_tup_call_set_call_capability
(IN TUP_UINT32           callid,
 IN CALL_E_PROTOCOL_TYPE protocol,
 IN CALL_E_LOCAL_CAP_ID  cap_id,
 IN TUP_VOID *           val)
 {
    return tup_call_set_call_capability
(callid,
 protocol,
 cap_id,
 val);
}

TUP_RESULT       huawei_tup_call_loopback_request(const CALL_S_LOOPBACK_REQUEST *pstLoopbackRequest)
{
    return tup_call_loopback_request(pstLoopbackRequest);
}

TUP_RESULT       huawei_tup_call_loopback_answer(const CALL_S_LOOPBACK_ANSWER *pstLoopbackAnswer)
{
    return tup_call_loopback_answer(pstLoopbackAnswer);
}

TUP_RESULT       huawei_tup_call_mic_mute_indicate(TUP_UINT32 callid, TUP_BOOL is_muted)
{
    return tup_call_mic_mute_indicate(callid,is_muted);
}

TUP_RESULT       huawei_tup_call_request_ims_confinfo(TUP_UINT32 callid)
{
    return tup_call_request_ims_confinfo(callid);
}

TUP_RESULT huawei_tup_call_debug_command(CALL_E_DEBUG_COMMAND cmd, const CALL_S_DEBUG_COMMAND *cmd_param)
{
    return tup_call_debug_command(cmd,cmd_param);
}

TUP_RESULT huawei_tup_call_set_end_call_reason(TUP_UINT32 callid, CALL_E_END_CALL_REASON reason, TUP_UINT32 val)
{
    return tup_call_set_end_call_reason(callid,reason, val);
}

TUP_RESULT huawei_tup_call_enable_air_data(TUP_BOOL enable)
{
    return tup_call_enable_air_data( enable);
}

TUP_RESULT huawei_tup_call_set_air_codec(CALL_E_CODER_TYPE coder_type, CALL_S_CODEC_INFO* codec)
{
    return tup_call_set_air_codec(coder_type, codec);
}

TUP_RESULT huawei_tup_call_start_local_airaux(TUP_VOID)
{
    return tup_call_start_local_airaux();
}

TUP_RESULT huawei_tup_call_stop_local_airaux(TUP_VOID)
{
    return tup_call_stop_local_airaux();
}

TUP_RESULT huawei_tup_call_init_air_audio(IN CALL_S_AIR_AUDIO_PARAM* air_audio_param)
{
    return tup_call_init_air_audio(air_audio_param);
}

TUP_RESULT huawei_tup_call_send_call_audio(IN TUP_UINT32 call_id, IN TUP_BOOL is_send, IN TUP_UINT32 subprocess_id)
{
    return tup_call_send_call_audio(call_id,is_send, subprocess_id);
}

TUP_RESULT huawei_tup_call_media_audio_op(IN TUP_UINT32 subprocess_id, IN CALL_S_AUDIO_OP* audio_op)
{
    return tup_call_media_audio_op(subprocess_id,audio_op);
}

TUP_RESULT huawei_tup_call_audio_gain_op(IN TUP_UINT32 call_id, IN CALL_S_CALL_AUDIO_CHN_OP* audio_op)
{
    return tup_call_audio_gain_op(call_id,audio_op);
}

TUP_RESULT huawei_tup_call_uinit_air_audio()
{
    return tup_call_uinit_air_audio();
}

TUP_RESULT huawei_tup_call_serverconf_access_reserved_conf_directly_ex(TUP_UINT32 callid, CALL_E_CALL_TYPE call_type, const CALL_S_CONF_PARAM *pstconfparam)
{
    return tup_call_serverconf_access_reserved_conf_directly_ex( callid, call_type,pstconfparam);
}

TUP_RESULT huawei_tup_call_serverconf_create_videoconf(TUP_UINT32 *confid, const CALL_S_CONF_VIDEOCONF_INFO * video_conf_info)
{
    return tup_call_serverconf_create_videoconf(confid, video_conf_info);
}

TUP_RESULT huawei_tup_call_serverconf_set_imsconf(TUP_UINT32 callid, const CALL_S_CONF_IMS * ims_conf_info)
{
    return tup_call_serverconf_set_imsconf(callid,ims_conf_info);
}

TUP_RESULT huawei_tup_call_set_delayed_sendpkt(IN TUP_BOOL is_delayed_mode)
{
    return tup_call_set_delayed_sendpkt(is_delayed_mode);
}

TUP_RESULT huawei_tup_call_set_redec_mode(IN TUP_BOOL is_redec_mode)
{
    return tup_call_set_redec_mode(is_redec_mode);
}

TUP_RESULT huawei_tup_call_set_superdec_mode(IN TUP_BOOL is_superdec_mode)
{
    return tup_call_set_superdec_mode(is_superdec_mode);
}

TUP_RESULT huawei_tup_call_set_skip_frame_mode(IN TUP_BOOL is_skip_mode)
{
    return tup_call_set_skip_frame_mode(is_skip_mode);
}

TUP_RESULT huawei_tup_call_set_h263plus_aux_enc_fmt(IN TUP_BOOL is_pcs_aux_enc_fmt)
{
    return tup_call_set_h263plus_aux_enc_fmt(is_pcs_aux_enc_fmt);
}

TUP_RESULT huawei_tup_call_subcribe_acbcall(TUP_UINT32 account_id, TUP_UINT32 call_back_type, const TUP_CHAR* call_back_number)
{
    return tup_call_subcribe_acbcall(account_id,call_back_type,call_back_number);
}

TUP_RESULT huawei_tup_call_unsubcribe_acbcall(TUP_UINT32 account_id, const TUP_CHAR* call_back_number)
{
    return tup_call_unsubcribe_acbcall( account_id,  call_back_number);
}

TUP_RESULT huawei_tup_call_start_acbcall(TUP_UINT32 call_id, TUP_UINT32 call_back_type, const TUP_CHAR* call_back_number)
{
    return tup_call_start_acbcall(call_id,  call_back_type, call_back_number);
}

TUP_RESULT huawei_tup_call_set_feature(IN const CALL_S_FEATURE *pstFeature)
{
    return tup_call_set_feature(pstFeature);
}

//TUP_RESULT huawei_tup_call_media_enable_audioengine(IN TUP_BOOL enable)
//{
//    return tup_call_media_enable_audioengine(enable);
//}

TUP_RESULT huawei_tup_call_add_svc_video_window(IN TUP_UINT32 callid, IN const CALL_S_SVC_VIDEOWND_INFO *window)
{
    return tup_call_add_svc_video_window(callid,window);
}

TUP_RESULT huawei_tup_call_update_svc_video_window(IN TUP_UINT32 callid, IN const CALL_S_SVC_VIDEOWND_INFO *window)
{
    return tup_call_update_svc_video_window(callid,window);
}

TUP_RESULT huawei_tup_call_remove_svc_video_window(IN TUP_UINT32 callid, IN const CALL_S_SVC_VIDEOWND_INFO *window)
{
    return tup_call_remove_svc_video_window(callid,window);
}

TUP_RESULT huawei_tup_call_set_cfg_asyn(TUP_UINT32 cfgid, const TUP_VOID *val)
{
    return tup_call_set_cfg_asyn( cfgid, val);
}

TUP_UINT32 huawei_tup_call_get_no_use_account_id(TUP_UINT32 protocol){
    return tup_call_get_no_use_account_id(protocol);
}

TUP_RESULT huawei_tup_call_media_get_call_account_isIdle(IN TUP_UINT32 accountid)
{
    return tup_call_media_get_call_account_isIdle( accountid);
}

TUP_RESULT huawei_tup_call_media_get_call_basic_isIdle(TUP_VOID)
{
    return tup_call_media_get_call_basic_isIdle();
}

TUP_RESULT huawei_tup_call_media_startplay_ex_for_account_id(IN CALL_S_MEDIA_PLAY_PARAM* media_play_param, OUT TUP_INT32* play_handle)
{
    return tup_call_media_startplay_ex_for_account_id(media_play_param,play_handle);
}

TUP_RESULT huawei_tup_call_get_account_index(TUP_UINT32 callid, TUP_UINT32 *accountid)
{
    return tup_call_get_account_index(callid,accountid);
}

TUP_BOOL huawei_tup_call_is_support_muti_use(TUP_VOID)
{
    return tup_call_is_support_muti_use();
}

TUP_UINT32 huawei_tup_call_set_enable_muti_used(TUP_BOOL enable)
{
    return tup_call_set_enable_muti_used( enable);
}

TUP_UINT32 huawei_tup_call_release_account_by_id(TUP_UINT32 accountid, TUP_UINT32 protocol)
{
    return tup_call_release_account_by_id( accountid,  protocol);
}

TUP_RESULT huawei_tup_call_media_set_account_mic_index(TUP_UINT32 accountid , TUP_UINT32 index)
{
    return tup_call_media_set_account_mic_index( accountid ,  index);
}

TUP_RESULT huawei_tup_call_media_set_account_speak_index(TUP_UINT32 accountid , TUP_UINT32 index)
{
    return tup_call_media_set_account_speak_index( accountid ,  index);
}

TUP_RESULT huawei_tup_call_media_set_account_video_index(TUP_UINT32 accountid , TUP_UINT32 index)
{
    return tup_call_media_set_account_video_index( accountid ,  index);
}

TUP_RESULT huawei_tup_call_media_get_account_mic_index(TUP_UINT32 accountid, TUP_UINT32 *index)
{
    return tup_call_media_get_account_mic_index( accountid,  index);
}

TUP_RESULT huawei_tup_call_media_get_account_speak_index(TUP_UINT32 accountid, TUP_UINT32 *index)
{
    return tup_call_media_get_account_speak_index( accountid,  index);
}

TUP_RESULT huawei_tup_call_media_get_account_video_index(TUP_UINT32 accountid, TUP_UINT32 *index)
{
    return tup_call_media_get_account_video_index( accountid,  index);
}

TUP_RESULT huawei_tup_call_set_account_mobile_audio_route(TUP_UINT32 accountid, CALL_E_MOBILE_AUIDO_ROUTE route)
{
    return tup_call_set_account_mobile_audio_route( accountid,  route);
}

TUP_RESULT huawei_tup_call_media_get_account_devices(IN TUP_UINT32 accountid, OUT TUP_UINT32 *puiNum, OUT CALL_S_DEVICEINFO *deviceinfo, OUT CALL_E_DEVICE_TYPE devicetype)
{
    return tup_call_media_get_account_devices( accountid,  puiNum, deviceinfo,devicetype);
}

TUP_RESULT huawei_tup_call_set_video_orient_for_account(IN TUP_UINT32 accountid, IN TUP_UINT32 ulCallID, IN TUP_UINT32 uiIndex, const CALL_S_VIDEO_ORIENT *pstVideoOrient){
    return tup_call_set_video_orient_for_account(accountid,  ulCallID,  uiIndex, pstVideoOrient);
}

TUP_RESULT huawei_tup_call_open_preview_for_account(IN TUP_UINT32 accountId, IN TUP_UPTR handle, IN TUP_UINT32 index)
{
    return tup_call_open_preview_for_account( accountId, handle, index);
}

TUP_RESULT huawei_tup_call_media_get_hdaccelerate_for_account(IN TUP_UINT32 accountid, OUT CALL_S_VIDEO_HDACCELERATE *hd_accelerate){
    return tup_call_media_get_hdaccelerate_for_account(accountid,hd_accelerate);
}

TUP_RESULT huawei_tup_call_authorize_ad_account(const TUP_CHAR* account_number, const TUP_CHAR* pwd_number)
{
    return tup_call_authorize_ad_account(account_number, pwd_number);
}

TUP_RESULT huawei_tup_call_get_vmr(IN TUP_UINT32 accountId)
{
    return tup_call_get_vmr(  accountId);
}

TUP_RESULT huawei_tup_call_get_conf_list(IN TUP_UINT32 accountId)
{
    return tup_call_get_conf_list( accountId);
}

TUP_RESULT huawei_tup_call_media_set_waveout_mute(TUP_BOOL is_mute)
{
    return tup_call_media_set_waveout_mute( is_mute);
}

TUP_RESULT huawei_tup_call_media_get_waveout_mute(TUP_BOOL *pMute)
{
    return tup_call_media_get_waveout_mute( pMute);
}
TUP_RESULT huawei_tup_call_register_data_resolution_func(IN CALL_FN_RESOLUTION_PTR resolution_func)
{
    return tup_call_register_data_resolution_func(resolution_func);
}

TUP_RESULT huawei_tup_call_init_for_multiuser(TUP_VOID)
{
    return tup_call_init_for_multiuser();
}

TUP_RESULT huawei_tup_call_register_process_notifiy_for_account(TUP_UINT32 accountid, CALL_FN_CALLBACK_PTR pfnCallBack)
{
    return tup_call_register_process_notifiy_for_account( accountid,  pfnCallBack);
}

TUP_RESULT huawei_tup_call_switch_channel(TUP_UINT32 callid, TUP_BOOL bStop, CALL_E_MEDIATYPE eMediaType)
{
    return tup_call_switch_channel( callid,  bStop,  eMediaType);
}

TUP_RESULT huawei_tup_call_set_enc_linked_info(IN TUP_UINT32 callid, IN CALL_S_LINKINFO stLinkInfo, IN CALL_E_LINKTYPE enLinkType)
{
    return tup_call_set_enc_linked_info( callid,  stLinkInfo,  enLinkType);
}

TUP_RESULT huawei_tup_call_take_picture(TUP_UINT32 index, TUP_UINT32 width, TUP_UINT32 height, const TUP_CHAR* path)
{
    return tup_call_take_picture( index,  width,  height, path);
}

TUP_UINT32 huawei_tup_call_start_signal_diag(IN TUP_UINT32 protocol, IN TUP_INT32 max_size, IN TUP_INT32 file_count, IN const TUP_CHAR* file_path)
{
    return tup_call_start_signal_diag( protocol,max_size, file_count, file_path);
}

TUP_VOID huawei_tup_call_stop_signal_diag(IN TUP_UINT32 protocol)
{
    return tup_call_stop_signal_diag( protocol);
}

TUP_RESULT huawei_tup_call_set_data_tmmbr(IN TUP_UINT32 ulCallID, IN TUP_UINT32 uiDataTmmbrBandwidth, OUT TUP_UINT32* pReAssignedDataTmmbrBandwidth)
{
    return tup_call_set_data_tmmbr( ulCallID, uiDataTmmbrBandwidth,  pReAssignedDataTmmbrBandwidth);
}

TUP_RESULT huawei_tup_call_set_tmmbr_sipinfo(IN TUP_BOOL is_support_tmmbr_sipinfo)
{
    return tup_call_set_tmmbr_sipinfo( is_support_tmmbr_sipinfo);
}

TUP_RESULT huawei_tup_call_set_chr_video_device_change_event(IN TUP_BOOL is_input_device)
{
    return tup_call_set_chr_video_device_change_event(is_input_device);
}

TUP_RESULT huawei_tup_call_set_line_id(TUP_UINT32 call_id, TUP_UINT32 line_id, CALL_E_LINE_TYPE line_type)
{
    return tup_call_set_line_id( call_id,  line_id,  line_type);
}

//TUP_RESULT huawei_tup_call_subcribe_conference_info(TUP_UINT32 account_id, const TUP_CHAR* conference_uri)
//{
//    return tup_call_subcribe_conference_info( account_id,  conference_uri);
//}
//
//TUP_RESULT huawei_tup_call_unsubcribe_conference_info(TUP_UINT32 account_id)
//{
//    return tup_call_unsubcribe_conference_info( account_id);
//}

TUP_RESULT huawei_tup_call_serverconf_remove_attendee(TUP_UINT32 callid, const TUP_CHAR* attendnum)
{
    return tup_call_serverconf_remove_attendee( callid, attendnum);
}

TUP_RESULT huawei_tup_call_hoteling_login(const CALL_S_HOTELING_LOGIN_ACCOUNTINFO * hoteling_login_account_info)
{
    return tup_call_hoteling_login(hoteling_login_account_info);
}

TUP_RESULT huawei_tup_call_hoteling_logout(TUP_VOID)
{
    return tup_call_hoteling_logout();
}

TUP_RESULT huawei_tup_call_set_blflisturi(TUP_UINT32 count, const CALL_S_BLFLISTURI_ITEM *blflisuri_array)
{
    return tup_call_set_blflisturi( count, blflisuri_array);
}

TUP_RESULT huawei_tup_call_svc_control_recv_aux(IN TUP_UINT32 ulCallID, IN TUP_BOOL bStartRecv)
{
    return tup_call_svc_control_recv_aux( ulCallID, bStartRecv);
}

TUP_RESULT huawei_tup_call_set_all_svc_video_windows(IN TUP_UINT32 callid, IN const CALL_S_SVC_VIDEOWND_INFO *window_array, IN TUP_UINT32 count)
{
    return tup_call_set_all_svc_video_windows(callid, window_array, count);
}