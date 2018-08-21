//
//  ViewController.m
//  VC_SDK_DEMO
//
//  Created by EC Open support team.
//  Copyright(C), 2017, Huawei Tech. Co., Ltd. ALL RIGHTS RESERVED.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ManagerService.h"
#import "DataConfBaseViewController.h"

@interface ViewController ()<LoginServiceDelegate>
@property (nonatomic,assign)BOOL isBeKickOut;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [ManagerService loginService].delegate = self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _isBeKickOut = NO;
    self.title = @"Main";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginEventCallback:(TUP_LOGIN_EVENT_TYPE)loginEvent result:(NSDictionary *)resultDictionary
{
    switch (loginEvent)
    {
        case LOGINOUT_EVENT:
        {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self goToLoginViewController];
                });
            break;
        }
        default:
            break;
    }
}

- (void)goToLoginViewController {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *loginNavigationViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
    [UIApplication sharedApplication].delegate.window.rootViewController = loginNavigationViewController;
}

-(void)dealloc
{
    [ManagerService loginService].delegate = nil;
}

-(void)showMessage:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
