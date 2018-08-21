

#import <Foundation/Foundation.h>
#import "TupContactsDef.h"
#import "TupContact.h"
#import "TupHistory.h"
#import "TupContactsSDK.h"

@interface HuaweiSdkContactsService : NSObject

+ (TupContactsSDK *)huawei_sharedInstance;

- (void)huawei_destoryInstance;

- (void)huawei_setLogParam:(TupContactsLoglevel)logLevel maxSizeKB:(NSUInteger)size fileCount:(NSUInteger)count logPath:(NSString *)logPath;

- (ContactsErrorId)huawei_setUserAccount:(NSString *)userAccount;

- (ContactsErrorId)huawei_startNetContactsService:(TupContactNetAddressType)type;

- (ContactsErrorId) huawei_addLocalContact:(TupContact*)_contact;

- (ContactsErrorId) huawei_delLocalContact:(TupContact*)_contact;

- (ContactsErrorId) huawei_modifyLocalContact:(TupContact *)_contact;

- (NSArray *) huawei_getAllLocalContacts;

- (TupHistory *)huawei_addCallRecord:(NSString *)phoneNumber type:(TupHistoryCallRecordType)callRecordType;

- (ContactsErrorId) huawei_delCallRecord:(TupHistory *)_record;

- (ContactsErrorId) huawei_modifyCallRecord:(TupHistory *)_record;

- (NSArray *) huawei_getAllCallRecords;

- (void)huawei_cleanAllCallRecords;

- (void)huawei_cleanAllMissCallRecords;

- (ContactsErrorId)huawei_downloadFtpContacts:(NSString *)userName
                                     password:(NSString *)password
                                    ftpServer:(NSString *)ftpServer
                                     filePath:(NSString *)filePath
                                      version:(NSString *)version
                          downloadResultBlock:(FtpDownloadResultBlock)resultBlock;

- (NSArray *) huawei_getFtpContacts;

- (ContactsErrorId)huawei_setLdapConfig:(NSString *)userName password:(NSString *)password ldapServer:(NSString *)ldapServer dn:(NSString *)dnValue;

- (ContactsErrorId)huawei_searchLdapContact:(NSString *)keyword isClearCookie:(BOOL)clear searchResultBlock:(LdapSearchResultBlock)resultBlock;

- (ContactsErrorId)huawei_setFireWallMode:(TupContactFireWallMode)mode;

- (ContactsErrorId)huawei_setTlsCerPath:(NSString *)cerPath;

@end
