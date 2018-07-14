//
//  ManagerService.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ManagerService.h"
#import "Defines.h"

static ManagerService *_tupService = nil;

#define TUP_LOGIN_SERVICE_NAME   @"VCLoginService"
#define TUP_CALL_SERVICE_NAME    @"CallService"
#define TUP_CONFERENCE_SERVICE_NAME @"ConferenceService"
#define TUP_DATACONF_SERVICE_NAME    @"DataConferenceService"

@interface ManagerService ()
@property (nonatomic ,strong)id<LoginInterface> loginService;
@property (nonatomic ,strong)id<CallInterface> callService;
@property (nonatomic ,strong)id<ConferenceInterface> confService;
@property (nonatomic ,strong)id<DataConferenceInterface> dataConfService;

@end

@implementation ManagerService

-(instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

/**
 *This method is used to load each service
 *加载各个模块的业务
 */
-(BOOL)loadServices:(TUP_SERVICE_TYPE)serviceType
{
    switch (serviceType)
    {
        case TUP_CONFERENCE_SERVICE:
        {
            if (!_confService)
            {
                Class targetClass = NSClassFromString(TUP_CONFERENCE_SERVICE_NAME);
                _confService = [[targetClass alloc] init];
            }
            break;
        }
        case TUP_DATA_CONFERENCE_SERVICE:
        {
            if (!_dataConfService)
            {
                Class targetClass = NSClassFromString(TUP_DATACONF_SERVICE_NAME);
                _dataConfService =  [[targetClass alloc] init];
                DDLogInfo(@"data conference service init finish!");
            }
            break;
        }
        case TUP_LOGIN_SERVICE:
        {
            Class targetClass = NSClassFromString(TUP_LOGIN_SERVICE_NAME);
            _loginService = [[targetClass alloc] init];
            break;
        }
        case TUP_CALL_SERVICE:
        {
            Class targetClass = NSClassFromString(TUP_CALL_SERVICE_NAME);
            _callService = [[targetClass alloc] init];
            break;
        }
        default:
            break;
    }
    return YES;
}

#pragma mark - Pubilc Method
/**
 *This method is used to load all service that is necessary
 *加载所有需要的业务
 */
+(BOOL)loadAllService
{
    DDLogInfo(@"load all Service");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_tupService) {
            _tupService = [[ManagerService alloc] init];
        }
    });
    BOOL result = NO;
    [ManagerService loadService:TUP_CALL_SERVICE];
    [ManagerService loadService:TUP_LOGIN_SERVICE];
    result = [ManagerService loadService:TUP_CONFERENCE_SERVICE];
    result = [ManagerService loadService:TUP_DATA_CONFERENCE_SERVICE];
    return result;
}

/**
 *This method is used to unload all service
 *注销所有的业务
 */
+(BOOL)unLoadService
{
    _tupService.callService = nil;
    _tupService.dataConfService = nil;
    _tupService.confService = nil;
    _tupService.loginService = nil;
    _tupService = nil;
    return YES;
}

/**
 *This method is used to load the service according to service type
 *根据业务类型加载业务
 */
+(BOOL)loadService:(TUP_SERVICE_TYPE)serviceType
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_tupService) {
            _tupService = [[ManagerService alloc] init];
        }
    });
    return [_tupService loadServices:serviceType];
}

/**
 *This method is used to get the instance of LoginInterface
 *获取LoginInterface的实例
 */
+(id<LoginInterface>)loginService
{
    if (_tupService.loginService == nil)
    {
        //        DDLogInfo(@"------->> please load tup service first!!!!!");
        return nil;
    }
    return _tupService.loginService;
}

/**
 *This method is used to get the instance of CallInterface
 *获取CallInterface的实例
 */
+(id<CallInterface>)callService
{
    if (_tupService.callService == nil)
    {
        //        DDLogInfo(@"------->> please load tup service first!!!!!");
        return nil;
    }
    return _tupService.callService;
}

/**
 *This method is used to get the instance of ConferenceInterface
 *获取ConferenceInterface的实例
 */
+(id<ConferenceInterface>)confService
{
    if (_tupService.confService == nil)
    {
        //        DDLogInfo(@"------->> please load tup service first!!!!!");
        return nil;
    }
    return _tupService.confService;
}

/**
 *This method is used to get the instance of DataConferenceInterface
 *获取DataConferenceInterface的实例
 */
+(id<DataConferenceInterface>)dataConfService
{
    if (_tupService.dataConfService == nil)
    {
        //        DDLogInfo(@"------->> please load tup service first!!!!!");
        return nil;
    }
    return _tupService.dataConfService;
}

@end
