
#include "tup_conf_baseapi.h"

TUP_RESULT  huawei_tup_conf_init(IN TUP_BOOL selfthread, IN const Init_param * pinitparam);

TUP_RESULT  huawei_tup_conf_uninit(TUP_VOID);

TUP_VOID  huawei_tup_conf_heart(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_new(IN conference_multi_callback callback, IN const TC_CONF_INFO* confinfo,
                                           IN TUP_UINT32 option, OUT CONF_HANDLE* handle);

TUP_RESULT huawei_tup_conf_set_local_ip(IN const TUP_CHAR* localip);

TUP_RESULT  huawei_tup_conf_join(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_leave(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_terminate(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_release(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_load_component(IN CONF_HANDLE handle, IN TUP_UINT32 compts);

TUP_RESULT  huawei_tup_conf_reg_component_callback(IN CONF_HANDLE handle, IN TUP_UINT32 compt, IN component_multi_callback callback);

TUP_RESULT  huawei_tup_conf_user_kickout(IN CONF_HANDLE handle, IN TUP_UINT32 userid);

TUP_RESULT  huawei_tup_conf_user_set_role(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 role);

TUP_RESULT  huawei_tup_conf_user_request_role(IN CONF_HANDLE handle, IN TUP_UINT32 role, IN const char* pszkey);

TUP_RESULT  huawei_tup_conf_as_set_owner(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 action);

TUP_RESULT  huawei_tup_conf_as_set_sharetype(IN CONF_HANDLE handle, IN TUP_INT32 sharingtype);

TUP_RESULT  huawei_tup_conf_as_start(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_as_stop(IN CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_as_get_screendata(IN CONF_HANDLE handle, OUT TC_AS_SCREENDATA* pscreendata);

TUP_RESULT  huawei_tup_conf_video_get_deviceinfo(IN CONF_HANDLE handle, OUT TC_DEVICE_INFO* device_info, OUT TUP_UINT32* ret_count);

TUP_RESULT  huawei_tup_conf_video_get_devicecapbilityinfo(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid, OUT TC_VIDEO_PARAM* capbility_info, OUT TUP_UINT32* ret_count);

TUP_RESULT  huawei_tup_conf_video_open(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid, IN TUP_BOOL preview );

TUP_RESULT  huawei_tup_conf_video_close(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid);

TUP_RESULT  huawei_tup_conf_video_setparam(IN CONF_HANDLE handle, IN TUP_UINT32 deviceid, IN TC_VIDEO_PARAM* pvparam);

TUP_RESULT  huawei_tup_conf_video_attach(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, IN TUP_VOID* pwnd, IN TUP_BOOL highchannel , IN TUP_UINT8 showmode );

TUP_RESULT  huawei_tup_conf_video_detach(IN CONF_HANDLE handle, IN TUP_UINT32 userid, IN TUP_UINT32 deviceid, IN TUP_VOID* pwnd, IN TUP_BOOL bleavechannel);

TUP_RESULT  huawei_tup_conf_video_attach_batch(CONF_HANDLE handle, TC_MEDIA_USER_IND* puserList, TUP_UINT32 dwcount);

TUP_RESULT  huawei_tup_conf_video_detach_all_substream(CONF_HANDLE handle);

TUP_RESULT  huawei_tup_conf_ds_new_doc(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, OUT TUP_UINT32* ret_docid);

TUP_RESULT  huawei_tup_conf_ds_new_page(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_INT32 width, IN TUP_INT32 height, OUT TUP_UINT32* ret_pageid);

TUP_RESULT  huawei_tup_conf_ds_open(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN const TUP_CHAR* filename, IN TUP_UINT32 option, OUT TUP_UINT32* ret_docid);

TUP_RESULT  huawei_tup_conf_ds_close(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid);

TUP_RESULT  huawei_tup_conf_ds_set_current_page(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_BOOL sync);

TUP_RESULT  huawei_tup_conf_ds_set_canvas_size(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TC_SIZE size, IN TUP_BOOL redraw);

TUP_VOID* huawei_tup_conf_ds_get_surfacebmp(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, OUT TUP_UINT32* ret_width, OUT TUP_UINT32* ret_height);

TUP_RESULT  huawei_tup_conf_ds_get_syncinfo(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, OUT DsSyncInfo* info);

TUP_RESULT  huawei_tup_conf_annotation_init_resource(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN Anno_Resource_Item* pitems, IN TUP_INT32 count);

TUP_RESULT  huawei_tup_conf_annotation_reg_customer_type(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN DsDefineAnnot* pdefintypes, IN TUP_INT32 count);

TUP_RESULT  huawei_tup_conf_annotation_create_start(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid,
                                                               IN TUP_UINT32 type, IN TUP_UINT32 subtype, IN TC_POINT point);

TUP_RESULT  huawei_tup_conf_annotation_create_update(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_VOID* pdata);

TUP_RESULT  huawei_tup_conf_annotation_create_done(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_BOOL bCancel, OUT TUP_UINT32* ret_annoid);

TUP_RESULT  huawei_tup_conf_annotation_select_start(CONF_HANDLE handle, COMPONENT_IID ciid, TUP_UINT32 docid, TUP_UINT32 pageid,TC_POINT point);

TUP_RESULT  huawei_tup_conf_annotation_select_update(CONF_HANDLE handle, COMPONENT_IID ciid, TC_POINT point);

TUP_RESULT  huawei_tup_conf_annotation_select_done(CONF_HANDLE handle, COMPONENT_IID ciid,TC_POINT point, TUP_INT32 hitmode,
                                                              TUP_UINT32    userid, TUP_UINT32 ** selectids,    TUP_INT *    nCount);
TUP_RESULT  huawei_tup_conf_annotation_laserpointer_start(IN CONF_HANDLE handle, IN COMPONENT_IID ciid,
                                                                     IN TC_SIZE dispSize, IN TUP_INT bLocal, IN TUP_INT localIndex, IN TUP_INT picFormat, IN TUP_VOID* pData, IN TUP_INT dataLen, IN TUP_INT picW, IN TUP_INT picH, IN TC_POINT ptOffset);

TUP_RESULT  huawei_tup_conf_annotation_laserpointer_moveto(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TC_POINT point);

TUP_RESULT  huawei_tup_conf_annotation_laserpointer_stop(IN CONF_HANDLE handle, IN COMPONENT_IID ciid);

TUP_RESULT  huawei_tup_conf_annotation_text_create(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid,
                                                              IN DsAnnotTextInfo* pInfo, OUT TUP_UINT32* ret_annoid);

TUP_RESULT  huawei_tup_conf_annotation_text_update(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_UINT32 annoid, IN DsAnnotTextInfo* pInfo, IN TUP_BOOL redraw);

TUP_RESULT  huawei_tup_conf_annotation_text_getinfo(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_UINT32 annoid, OUT DsAnnotTextInfo* pInfo);

TUP_RESULT  huawei_tup_conf_annotation_edit_start(IN CONF_HANDLE handle,
                                                             IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_UINT32* annotids, IN TUP_INT32 count,
                                                             IN TUP_UINT32 refannotid, IN DS_HITTEST_CODE edittype, IN TC_POINT startpoint);

TUP_RESULT  huawei_tup_conf_annotation_edit_update(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TC_POINT currentpoint);

TUP_RESULT  huawei_tup_conf_annotation_edit_done(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_BOOL cancel);

TUP_RESULT  huawei_tup_conf_annotation_hittest(IN CONF_HANDLE handle,
                                                          IN COMPONENT_IID ciid,
                                                          IN TUP_UINT32 docid,
                                                          IN TUP_UINT32 pageid,
                                                          IN TC_POINT pt,
                                                          IN TUP_INT32 hitmode,
                                                          IN TUP_UINT32 userid,
                                                          OUT TUP_UINT32* selectId,
                                                          OUT DS_HITTEST_CODE* hit_result,
                                                          OUT TUP_UINT32* annotType);

TUP_RESULT  huawei_tup_conf_annotation_hittest_rect(IN CONF_HANDLE handle,
                                                               IN COMPONENT_IID ciid,
                                                               IN TUP_UINT32 docid,
                                                               IN TUP_UINT32 pageid,
                                                               IN TC_RECT2* rect,
                                                               IN TUP_INT32 hitmode,
                                                               IN TUP_UINT32 userid,
                                                               OUT TUP_UINT32** selectids,
                                                               OUT TUP_INT* count);

TUP_RESULT  huawei_tup_conf_annotation_setselect(IN CONF_HANDLE handle,
                                                            IN COMPONENT_IID ciid,
                                                            IN TUP_UINT32 docid,
                                                            IN TUP_UINT32 pageid,
                                                            IN TUP_UINT32* ids,
                                                            IN TUP_INT32 count,
                                                            IN TUP_INT32 selectmode,
                                                            IN TUP_UINT32 userid,
                                                            IN TUP_BOOL redraw);

TUP_RESULT  huawei_tup_conf_annotation_delete(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid, IN TUP_UINT32* ids, IN TUP_INT32 count);

TUP_RESULT  huawei_tup_conf_annotation_set_pen(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_INT32 pentype, IN DsPenInfo newpen, OUT DsPenInfo* oldpen);

TUP_RESULT  huawei_tup_conf_annotation_set_brush(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN DsBrushInfo newbrush, OUT DsBrushInfo* oldbrush);

TUP_RESULT  huawei_tup_conf_annotation_get_annotinfo(IN CONF_HANDLE handle, IN COMPONENT_IID ciid, IN TUP_UINT32 docid, IN TUP_UINT32 pageid,
                                                                IN TUP_UINT32 annotid, OUT DsAnnotInfo* pannotinfo);

TUP_RESULT  huawei_tup_conf_audio_setparam(IN CONF_HANDLE handle, IN TC_AUDIO_PARAM* audio_param);

TUP_RESULT  huawei_tup_conf_audio_open(IN CONF_HANDLE handle,TUP_BOOL bmic, IN TUP_UINT32 deviceid);

TUP_RESULT  huawei_tup_conf_audio_close(IN CONF_HANDLE handle,TUP_BOOL bmic);

TUP_RESULT  huawei_tup_conf_audio_mute(IN CONF_HANDLE handle,TUP_BOOL bmic, IN TUP_BOOL bMute);

TUP_RESULT  huawei_tup_conf_audio_get_volume(IN CONF_HANDLE handle,TUP_BOOL bmic,TUP_BOOL bsystem, OUT TUP_UINT32 *volume);

TUP_RESULT  huawei_tup_conf_audio_set_volume(IN CONF_HANDLE handle,TUP_BOOL bmic,TUP_BOOL bsystem, IN TUP_UINT32 volume);

TUP_RESULT  huawei_tup_conf_audio_get_device(IN CONF_HANDLE handle,TUP_BOOL binput, TC_AUDIO_DEVICE_INFO *device_info, TUP_UINT32 *ret_count);

TUP_RESULT  huawei_tup_conf_chat_sendmsg_ex(IN CONF_HANDLE handle, IN TUP_INT32 nType, IN TUP_UINT32 userid, IN TUP_CHAR* lpdata, IN TUP_INT32 nLen, IN TUP_CHAR* dispSenderName);

