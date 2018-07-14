//
//  ContactDetailViewController.m
//  VC_SDK_DEMO
//
//  Created by tupservice on 2018/1/5.
//  Copyright © 2018年 cWX160907. All rights reserved.
//

#import "ContactDetailViewController.h"

@interface ContactDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *accountText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UITextField *departText;
@property (weak, nonatomic) IBOutlet UITextField *myPhoneText;
@property (weak, nonatomic) IBOutlet UITextField *dptPhone;
@property (weak, nonatomic) IBOutlet UITextField *groupText;
@property (weak, nonatomic) IBOutlet UIButton *addContactBtn;
@property (weak, nonatomic) IBOutlet UIButton *modifyContact;
@property (assign, nonatomic) BOOL isFriend;

@end

@implementation ContactDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _contact.name;
    _isFriend = NO;
    if (_contact)
    {
        _nameText.text = _contact.name;
        _accountText.text = _contact.account;
        _emailText.text = _contact.email;
        _addressText.text = _contact.address;
        _departText.text = _contact.department;
        _myPhoneText.text = _contact.mobilePhone;
        _dptPhone.text = _contact.officePhone;
        _groupText.text = _contact.group;
    }
    
    NSMutableArray * contacts = [NSMutableArray arrayWithArray:[[TupContactsSDK sharedInstance] getAllLocalContacts]];
    for (TupContact *contact in contacts) {
        if ([contact.account isEqualToString:_contact.account]) {
            [_addContactBtn setTitle:@"Delete" forState:UIControlStateNormal];
            _isFriend = YES;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)AddContactAction:(id)sender {
    ContactsErrorId result;
    
    if (!_isFriend) {
        result = [[TupContactsSDK sharedInstance]addLocalContact:_contact];
        DDLogInfo(@"addLocalContact, result:%d",result);
    }else{
        result = [[TupContactsSDK sharedInstance] delLocalContact:_contact];
    }
    
    if (result == ContactsSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)ModifyContact:(id)sender {
    _contact.name = _nameText.text;
    _contact.account = _accountText.text;
    _contact.email = _emailText.text;
    _contact.address = _addressText.text;
    _contact.department = _departText.text;
    _contact.mobilePhone = _myPhoneText.text;
    _contact.officePhone = _dptPhone.text;
    _contact.group = _groupText.text;
    
    ContactsErrorId result = [[TupContactsSDK sharedInstance]modifyLocalContact:_contact];
    DDLogInfo(@"modifyLocalContact result :%d",result);
    if (result == ContactsSuccess) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end
