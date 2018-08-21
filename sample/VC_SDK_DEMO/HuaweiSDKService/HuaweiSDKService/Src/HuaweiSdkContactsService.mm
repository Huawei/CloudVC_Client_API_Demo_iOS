

#import "HuaweiSdkContactsService.h"

@implementation HuaweiSdkContactsService

+ (TupContactsSDK *)huawei_sharedInstance
{
    return [TupContactsSDK sharedInstance];
}

- (void)huawei_destoryInstance
{
    [[TupContactsSDK sharedInstance] destoryInstance];
}

- (void)huawei_setLogParam:(TupContactsLoglevel)logLevel maxSizeKB:(NSUInteger)size fileCount:(NSUInteger)count logPath:(NSString *)logPath
{
    return [[TupContactsSDK sharedInstance] setLogParam:logLevel maxSizeKB:size fileCount:count logPath:logPath];
}

- (ContactsErrorId)huawei_setUserAccount:(NSString *)userAccount
{
    return [[TupContactsSDK sharedInstance] setUserAccount:userAccount];
}

- (ContactsErrorId)huawei_startNetContactsService:(TupContactNetAddressType)type
{
    return [[TupContactsSDK sharedInstance] startNetContactsService:type];
}

- (ContactsErrorId) huawei_addLocalContact:(TupContact*)_contact
{
    return [[TupContactsSDK sharedInstance] addLocalContact:_contact];
}

- (ContactsErrorId) huawei_delLocalContact:(TupContact*)_contact
{
    return [[TupContactsSDK sharedInstance] delLocalContact:_contact];
}

- (ContactsErrorId) huawei_modifyLocalContact:(TupContact *)_contact
{
    return [[TupContactsSDK sharedInstance] modifyLocalContact:_contact];
}

- (NSArray *) huawei_getAllLocalContacts
{
    return [[TupContactsSDK sharedInstance] getAllLocalContacts];
}

- (TupHistory *)huawei_addCallRecord:(NSString *)phoneNumber type:(TupHistoryCallRecordType)callRecordType
{
    return [[TupContactsSDK sharedInstance] addCallRecord:phoneNumber type:callRecordType];
}

- (ContactsErrorId) huawei_delCallRecord:(TupHistory *)_record
{
    return [[TupContactsSDK sharedInstance] delCallRecord:_record];
}

- (ContactsErrorId) huawei_modifyCallRecord:(TupHistory *)_record
{
    return [[TupContactsSDK sharedInstance] modifyCallRecord:_record];
}

- (NSArray *) huawei_getAllCallRecords
{
    return [[TupContactsSDK sharedInstance] getAllCallRecords];
}

- (void)huawei_cleanAllCallRecords
{
    return [[TupContactsSDK sharedInstance] cleanAllCallRecords];
}

- (void)huawei_cleanAllMissCallRecords
{
    return [[TupContactsSDK sharedInstance] cleanAllMissCallRecords];
}

- (ContactsErrorId)huawei_downloadFtpContacts:(NSString *)userName
                                     password:(NSString *)password
                                    ftpServer:(NSString *)ftpServer
                                     filePath:(NSString *)filePath
                                      version:(NSString *)version
                          downloadResultBlock:(FtpDownloadResultBlock)resultBlock
{
    return [[TupContactsSDK sharedInstance] downloadFtpContacts:userName password:password ftpServer:ftpServer filePath:filePath version:version downloadResultBlock:resultBlock];
}

- (NSArray *) huawei_getFtpContacts
{
    return [[TupContactsSDK sharedInstance] getFtpContacts];
}

- (ContactsErrorId)huawei_setLdapConfig:(NSString *)userName password:(NSString *)password ldapServer:(NSString *)ldapServer dn:(NSString *)dnValue
{
    return [[TupContactsSDK sharedInstance] setLdapConfig:userName password:password ldapServer:ldapServer dn:dnValue];
}

- (ContactsErrorId)huawei_searchLdapContact:(NSString *)keyword isClearCookie:(BOOL)clear searchResultBlock:(LdapSearchResultBlock)resultBlock
{
    return [[TupContactsSDK sharedInstance] searchLdapContact:keyword isClearCookie:clear searchResultBlock:resultBlock];
}

- (ContactsErrorId)huawei_setFireWallMode:(TupContactFireWallMode)mode
{
    return [[TupContactsSDK sharedInstance] setFireWallMode:mode];
}

- (ContactsErrorId)huawei_setTlsCerPath:(NSString *)cerPath
{
    return [[TupContactsSDK sharedInstance] setTlsCerPath:cerPath];
}

@end
