
#include "tup_conf_extendapi.h"

TUP_VOID huawei_tup_conf_tup_conf_init_isv(IN TUP_BOOL bpaasmode, IN const Isv_Param* isv_param);

TUP_RESULT  huawei_tup_conf_lock(IN CONF_HANDLE handle,IN TUP_BOOL lock);

TUP_RESULT  huawei_tup_conf_mute(IN CONF_HANDLE handle, IN TUP_BOOL bmute);

TUP_RESULT  huawei_tup_conf_set_component_option(IN CONF_HANDLE handle, IN TUP_UINT32 compt, IN TUP_UINT32 option_type, IN void* option, IN TUP_UINT32 len);

TUP_RESULT  huawei_tup_conf_set_chr_param(IN CONF_HANDLE handle, IN TC_CONF_CHR_CONFIG* chrConfig);

TUP_RESULT  huawei_tup_conf_export_chr_file(IN CONF_HANDLE handle, IN TUP_CHAR* cFilePath, IN TUP_UINT32 nSize);

TUP_RESULT  huawei_tup_conf_user_get_host(IN  CONF_HANDLE handle, OUT TUP_UINT32* ret_userid);

TUP_RESULT  huawei_tup_conf_user_get_presenter(IN CONF_HANDLE handle, OUT TUP_UINT32* ret_userid);

TUP_RESULT  huawei_tup_conf_setiplist(IN CONF_HANDLE handle, IN const TUP_CHAR * svrlist);

TUP_VOID  huawei_tup_conf_setipmap(IN CONF_HANDLE handle, IN IP_NAT_MAP* pnatmap, IN TUP_UINT32 count);

TUP_VOID  huawei_tup_conf_set_qos_option(IN CONF_HANDLE handle, IN TUP_UINT32 datatype, IN TUP_UINT32 nvalue);

TUP_VOID  huawei_tup_conf_log_delete(IN TUP_UINT32 nDay);

TUP_VOID  huawei_tup_conf_cache_delete();

TUP_RESULT  huawei_tup_conf_flowcontrol_limit(IN CONF_HANDLE   handle, IN TUP_UINT32 datatype, IN TUP_UINT32 limitsize);

TUP_RESULT  huawei_tup_conf_user_update_info(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT8* pUserInfo, IN TUP_UINT16 nInfoLen);

TUP_RESULT  huawei_tup_conf_send_data(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT8 msg_id, IN TUP_UINT8 * pbuffer, IN TUP_UINT32 len);

TUP_RESULT  huawei_tup_conf_update_param(IN CONF_HANDLE handle, IN const TUP_CHAR * param_name, IN TUP_VOID* pbuffer, IN TUP_UINT16 len);

/*************************************”Ô“Ù∏ﬂº∂π¶ƒ‹************************************/


TUP_RESULT  huawei_tup_conf_audio_play_file(IN CONF_HANDLE handle, IN const TUP_CHAR* pAudioFileName, IN TUP_INT32 nFileFormat, IN TUP_INT32 nLoop, IN float volume_scaling);

TUP_RESULT  huawei_tup_conf_audio_stop_play_file(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_audio_begin_wizard();

TUP_RESULT  huawei_tup_conf_audio_end_wizard();

TUP_RESULT  huawei_tup_conf_audio_get_level(OUT TUP_UINT32 *pLevel, IN TUP_INT32 deviceType);

TUP_RESULT  huawei_tup_conf_audio_get_statistics(IN CONF_HANDLE handle, IN TUP_BOOL bmic, OUT TC_AUDIO_STATISTICS *pstatics);

TUP_RESULT  huawei_tup_conf_audio_get_mutestatus(IN CONF_HANDLE handle, IN TUP_BOOL bmic, OUT TUP_INT32 *pmute);

TUP_RESULT  huawei_tup_conf_audio_set_mutestatus(IN CONF_HANDLE handle, IN TUP_BOOL bmic, IN TUP_BOOL bmute);

/*************************∆¡ƒªπ≤œÌ∏ﬂº∂Ω”ø⁄*************************/

TUP_RESULT  huawei_tup_conf_as_request_privilege(IN CONF_HANDLE handle, IN TUP_INT8 privilege);

TUP_RESULT  huawei_tup_conf_as_set_privilege(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_INT8 privilege, IN TUP_UINT32 action);

TUP_RESULT  huawei_tup_conf_as_inputwndmsg(IN CONF_HANDLE handle, IN TUP_UINT32 msgtype, IN TUP_ULONG wparam, IN TUP_LONG lparam, IN TUP_VOID* pdata, IN TUP_UINT32 datalen);

TUP_RESULT  huawei_tup_conf_as_begin_annotation(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_as_end_annotation(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_as_getapplist(IN CONF_HANDLE handle, OUT TC_AS_WndInfo *papplist , OUT TUP_UINT32 *pappcount);

TUP_RESULT  huawei_tup_conf_as_setsharingapp(IN CONF_HANDLE handle, IN TUP_VOID* pappwnd, IN TUP_UINT32 action);

TUP_RESULT  huawei_tup_conf_as_setparam(IN CONF_HANDLE handle, IN TC_AS_PARAM* param);

TUP_RESULT  huawei_tup_conf_as_getparam(IN CONF_HANDLE handle, OUT const TC_AS_PARAM* param);

TUP_RESULT  huawei_tup_conf_as_pause(IN CONF_HANDLE handle, IN TUP_BOOL pause);

TUP_RESULT  huawei_tup_conf_as_flush_screendata(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_as_lock_screen_data(IN CONF_HANDLE handle, OUT TC_AS_SCREENDATA* pscreendata);

TUP_RESULT  huawei_tup_conf_as_unlock_screen_data(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_as_attach(IN CONF_HANDLE handle, IN TUP_INT32 channel_type, IN TUP_VOID* hwnd);

TUP_RESULT  huawei_tup_conf_as_detach(IN CONF_HANDLE handle, IN TUP_INT32 channel_type);

TUP_RESULT  huawei_tup_conf_as_set_scale_rate(IN CONF_HANDLE handle, IN float fScaleRate, IN float fTransX, IN float fTransY);

TUP_RESULT  huawei_tup_conf_as_set_transparentwindow(IN CONF_HANDLE handle, IN TUP_VOID *hwnd, IN TUP_UINT32 action);

TUP_RESULT  huawei_tup_conf_as_request_keyframe(IN CONF_HANDLE handle, IN TUP_UINT32 reason);

TUP_RESULT  huawei_tup_conf_as_get_displayinfo(IN CONF_HANDLE handle, OUT TC_MonitorInfo* pdisplay_info, OUT TUP_UINT32* ret_count);

TUP_RESULT  huawei_tup_conf_as_get_displaythumbnail(IN CONF_HANDLE handle, IN TUP_UINT32  index, IN TUP_UINT32  width, IN TUP_UINT32 height, IN TUP_UINT8* pbuffer);

TUP_RESULT  huawei_tup_conf_as_set_sharing_display(IN CONF_HANDLE handle, IN TUP_UINT32  index);

TUP_RESULT  huawei_tup_conf_as_save(IN CONF_HANDLE handle, IN const char* filename);

TUP_RESULT  huawei_tup_conf_as_get_auxflow_statistics(IN CONF_HANDLE handle, IN TC_DEC_RECV_STATISTICS* params);

TUP_RESULT  huawei_tup_conf_as_set_auxflow_tmmbr(IN CONF_HANDLE handle, IN TUP_UINT32 uTmmbr);

/********************************************* ”∆µ∏ﬂº∂Ω”ø⁄*********************************************/

TUP_RESULT  huawei_tup_conf_video_getparam(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid, OUT TC_VIDEO_PARAM* pvparam);

TUP_RESULT  huawei_tup_conf_video_pause(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, IN TUP_BOOL bwizard);

TUP_RESULT  huawei_tup_conf_video_resume(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid);

TUP_RESULT  huawei_tup_conf_video_notify(IN CONF_HANDLE handle, IN TUP_UINT32 notifycmd, IN TUP_UINT32 userid, IN TC_VIDEO_PARAM* pvparam);

TUP_RESULT  huawei_tup_conf_video_switch_channel(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, IN TUP_BOOL highchannel );

TUP_RESULT  huawei_tup_conf_video_closeall(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_video_set_capture_rotate(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid, IN TUP_INT32 nRotate);

TUP_RESULT  huawei_tup_conf_video_snapshot(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid, IN const TUP_CHAR* filename, IN TC_VIDEO_PARAM* vparam);

TUP_RESULT  huawei_tup_conf_video_render_snapshot(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, IN const TUP_CHAR* filename);

TUP_RESULT  huawei_tup_conf_video_get_devicestatus(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, OUT TUP_UINT32* ret_devicetatus);

TUP_RESULT  huawei_tup_conf_video_get_devicebitrate(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, OUT TC_VIDEO_PARAM* vparam);

TUP_RESULT  huawei_tup_conf_video_get_encode_statistics(IN CONF_HANDLE handle, IN TUP_UINT32 index, OUT TC_ENC_STATISTICS* statistics);

TUP_RESULT  huawei_tup_conf_video_get_decode_statistics(IN CONF_HANDLE handle, IN TUP_VOID* hwnd, OUT TC_DEC_RECV_STATISTICS* statistics);

TUP_RESULT  huawei_tup_conf_video_show_deviceproperty(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, OUT TUP_VOID* parent_hwnd);

TUP_RESULT  huawei_tup_conf_video_preview_start(IN TUP_UINT32 deviceid, IN TUP_VOID* pwnd, IN TC_VIDEO_PARAM* pvparam);

TUP_RESULT  huawei_tup_conf_video_preview_stop(IN TUP_UINT32 deviceid);

TUP_RESULT  huawei_tup_conf_video_preview_start_ex(CONF_HANDLE handle, TUP_UINT32 deviceid, TUP_VOID *pwnd, TC_VIDEO_PARAM *pvparam);

TUP_RESULT  huawei_tup_conf_video_preview_stop_ex(CONF_HANDLE handle, TUP_UINT32 deviceid, TUP_BOOL bOpenVideo);

TUP_RESULT  huawei_tup_conf_video_preview_setparam(IN TUP_UINT32 deviceid, IN TC_VIDEO_PARAM* pvparam);

TUP_RESULT  huawei_tup_conf_video_wizstart_runcapture(IN TUP_UINT32 deviceid, IN TC_VIDEO_PARAM* pvparam);

TUP_RESULT  huawei_tup_conf_video_wizend_runcapture(IN TUP_UINT32 deviceid);

TUP_RESULT  huawei_tup_conf_video_wizstart_render(IN TUP_UINT32 deviceid, IN void* pWnd);

TUP_RESULT  huawei_tup_conf_video_wizend_render(IN TUP_UINT32 deviceid, IN void* pWnd);

TUP_RESULT  huawei_tup_conf_video_wizset_param(IN TUP_UINT32 deviceid, TC_VIDEO_PARAM* pvParam);

TUP_RESULT  huawei_tup_conf_video_always_runcapture(IN CONF_HANDLE handle);

TUP_VOID  huawei_tup_conf_video_setcoderatetable(CONF_HANDLE handle, int ResolutionWidth, int ResolutionHeight, int *CodeRate);

TUP_RESULT  huawei_tup_conf_video_setautoadjustparam(CONF_HANDLE handle, TC_RESOLUTION_TABLE* pstTable, TUP_UINT32 uiAdjNum, TC_VIDEO_ARS* pstArsParam, TUP_BOOL bIsAutoAdjSpeedEnabled);

TUP_VOID  huawei_tup_conf_set_adjust_param(CONF_HANDLE handle, TC_ADJUST_PARAM* pstAdjustParam);

/*************************Œƒµµ∞◊∞Â∏ﬂº∂Ω”ø⁄*************************/

TUP_RESULT  huawei_tup_conf_ds_import(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN const TUP_CHAR* filename);

TUP_RESULT  huawei_tup_conf_ds_load(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN const TUP_CHAR* filename, OUT TUP_UINT32* ret_docid);

TUP_RESULT  huawei_tup_conf_ds_copy_page(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, OUT TUP_UINT32* new_pageid);

TUP_RESULT  huawei_tup_conf_ds_delete_doc(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid);

TUP_RESULT  huawei_tup_conf_ds_delete_page(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid);

TUP_RESULT  huawei_tup_conf_ds_get_doc_property(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 nPropertyID, OUT TUP_UINT8* lpBuf, OUT TUP_UINT32* nRetLen);

TUP_RESULT  huawei_tup_conf_ds_get_page_property(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_UINT32 nPropertyID,
                                                         OUT TUP_UINT8* lpBuf, OUT TUP_UINT32* nRetLen);

TUP_VOID  huawei_tup_conf_ds_set_bgcolor(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN COLORRGBA bgColor);

TUP_VOID  huawei_tup_conf_ds_set_dispmode(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN DsDispMode dispMode);

TUP_RESULT  huawei_tup_conf_ds_set_page_origin(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TC_POINT org, IN TUP_BOOL sync, IN TUP_BOOL redraw);

TUP_RESULT  huawei_tup_conf_ds_rotate_page(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN DsRotateFlipType rftype, IN TUP_BOOL sync);

TUP_RESULT  huawei_tup_conf_ds_set_zoom(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 zoomtype, IN TUP_UINT32 factor, IN TUP_BOOL sync, IN TUP_BOOL redraw);

TUP_VOID*  huawei_tup_conf_ds_lock_surfacebmp(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, OUT TUP_UINT32* width, OUT TUP_UINT32* height);

TUP_VOID  huawei_tup_conf_ds_unlock_surfacebmp(IN CONF_HANDLE handle, IN COMPONENT_IID ciid);

TUP_RESULT  huawei_tup_conf_ds_get_doc_count(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, OUT TUP_UINT32* count);

TUP_RESULT  huawei_tup_conf_ds_get_docid_byindex(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_INT32 index, OUT TUP_UINT32* docid);

TUP_RESULT  huawei_tup_conf_ds_get_docindex_byid(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, OUT TUP_INT* index);

TUP_RESULT  huawei_tup_conf_ds_get_page_count(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, OUT TUP_UINT32* count);

TUP_RESULT  huawei_tup_conf_ds_get_pageno_byid(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, OUT TUP_INT* pageno);

TUP_RESULT  huawei_tup_conf_ds_get_pageid_byno(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_INT32 pageno, OUT TUP_UINT32* pageid);

TUP_RESULT  huawei_tup_conf_ds_get_pageinfo(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, OUT DsPageInfo* pageinfo);

TUP_RESULT  huawei_tup_conf_ds_get_docinfo(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, OUT DsDocInfo* pdocinfo);

TUP_VOID*  huawei_tup_conf_ds_get_thumbnail(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_INT32 width, IN TUP_INT32 height);

TUP_VOID  huawei_tup_conf_ds_release_thumbnail(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid);

TUP_RESULT  huawei_tup_conf_ds_save(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN const char* filename);

TUP_RESULT  huawei_tup_conf_ds_saveas_picture(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN const TUP_CHAR* filename);

/*************************±Í◊¢ª˘±æΩ”ø⁄*************************/

TUP_RESULT  huawei_tup_conf_annotation_set_config(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN AnnotationConfig config);

TUP_RESULT  huawei_tup_conf_annotation_hittest_line(CONF_HANDLE   handle,
                                                            COMPONENT_IID ciid,
                                                            TUP_UINT32    docid,
                                                            TUP_UINT32    pageid,
                                                            TC_POINT     ptStart,
                                                            TC_POINT    ptEnd,
                                                            TUP_INT32     hitmode,
                                                            TUP_UINT32    userid,
                                                            TUP_UINT32 ** selectids,
                                                            TUP_INT *     nCount);

/****************************µÁª∞ƒ£øÈΩ”ø⁄*************************************************/

TUP_RESULT  huawei_tup_conf_phone_conf_mute(IN CONF_HANDLE handle, IN TUP_BOOL mute_status);

TUP_RESULT  huawei_tup_conf_phone_conf_lock(IN CONF_HANDLE handle, IN TUP_BOOL lock_status);

TUP_RESULT  huawei_tup_conf_phone_conf_extend(IN CONF_HANDLE handle, IN TUP_UINT32 extend_time);

TUP_RESULT  huawei_tup_conf_phone_conf_chairman_req(IN CONF_HANDLE handle, IN TUP_UINT16 record_id, IN TUP_CHAR* chair_pwd);

TUP_RESULT  huawei_tup_conf_phone_conf_chairman_release(IN CONF_HANDLE handle, IN TUP_UINT16 record_id);

TUP_RESULT  huawei_tup_conf_phone_conf_broadcast(IN CONF_HANDLE handle, IN TUP_UINT16 record_id);

TUP_RESULT  huawei_tup_conf_phone_conf_voice_active(IN CONF_HANDLE handle, IN TUP_BOOL enable);

TUP_RESULT  huawei_tup_conf_phone_conf_free_discuss(IN CONF_HANDLE handle);

TUP_RESULT huawei_tup_conf_phone_conf_raise_hand( IN CONF_HANDLE handle, IN TUP_UINT16 record_id, IN TUP_BOOL raise );

TUP_RESULT  huawei_tup_conf_phone_conf_status_get(IN CONF_HANDLE handle, OUT TUP_UINT32 * status);

TUP_RESULT  huawei_tup_conf_phone_call_kill_off(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id);

TUP_RESULT  huawei_tup_conf_phone_call_out(IN CONF_HANDLE handle, IN TUP_CHAR* uri, IN TUP_UINT32 pin_num, IN TUP_CHAR* user_name, IN TUP_BOOL bHost, IN TUP_UINT32 userid);

TUP_RESULT  huawei_tup_conf_phone_call_hangup(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id);

TUP_RESULT  huawei_tup_conf_phone_call_recall(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id);

TUP_RESULT  huawei_tup_conf_phone_call_set_name(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id, IN TUP_CHAR* user_name);

TUP_RESULT  huawei_tup_conf_phone_call_mute(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id, IN TUP_BOOL mute_status);

TUP_RESULT  huawei_tup_conf_phone_call_mute_speaker(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id, IN TUP_BOOL mute_status);

TUP_RESULT  huawei_tup_conf_phone_bind_user(IN CONF_HANDLE handle, IN TUP_UINT16 call_record_id, IN TUP_UINT32 userid, IN TUP_BOOL bBind);

TUP_RESULT  huawei_tup_conf_phone_send_message_to_mgw(IN CONF_HANDLE handle, IN TUP_UINT32 cmd_type, IN TUP_UINT8* data, IN TUP_UINT32 data_len);

TUP_RESULT  huawei_tup_conf_phone_broadcast_multiframe(IN CONF_HANDLE handle, IN const char* userMT, IN TUP_BOOL status);

TUP_RESULT huawei_tup_conf_check_certificate_overdue(IN const char *certfile_path, OUT TC_CERT_DATA_TIME *expire_time);

TUP_RESULT huawei_tup_conf_verify_certificate(IN const char *certfile_path);

TUP_RESULT  huawei_tup_conf_set_data_callback(IN conference_multi_callback callback, IN CONF_HANDLE handle);
