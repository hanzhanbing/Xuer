//
//  XRLoginController.m
//  XUER
//
//  Created by 韩占禀 on 15/8/31.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRLoginController.h"
#import "XRRegisterPhoneController.h"
#import "XRForgetPswController.h"
#import "XRShareCenter.h"

@interface XRLoginController ()

@end

@implementation XRLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        CGRect frame = _wechatButton.frame;
        frame.origin.x = kScreenWidth/2;
        _wechatButton.frame = frame;
    }
    return self;
}

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
    
#warning - 下面这部分代码是非常必要的，是绕开苹果审核的解决办法，否则会被苹果拒绝
    if (![WXApi isWXAppInstalled])
    {
        _wechatButton.hidden = YES;
    }
    else
    {
        _wechatButton.hidden = NO;
    }
    
    if (![QQApiInterface isQQInstalled])
    {
        _qqButton.hidden = YES;
    }
    else
    {
        _qqButton.hidden = NO;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName:kUIColorAFromRGB(0xFFFFFF, 0.5)}];
    _phoneTextField.attributedPlaceholder = string;
    
    string = [[NSMutableAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName:kUIColorAFromRGB(0xFFFFFF, 0.5)}];
    _passwordTextField.attributedPlaceholder = string;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[_phoneTextField becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _phoneTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [self loginButtonTouchUp:nil];
    }
    return YES;
}

-(IBAction)loginButtonTouchUp:(id)sender
{
    [self.view endEditing:YES]; //隐藏键盘
    NSString *message = nil;
    NSString *phoneString = _phoneTextField.text;
    NSString *passwordString = _passwordTextField.text;
    if ([phoneString length] == 0)
    {
        message = @"请输入手机号";
    }
    else if (![XRConfigs validateMobile:phoneString])
    {
        message = @"请输入正确的手机号";
    }
    else if ([passwordString length] == 0)
    {
        message = @"请输入密码";
    }
    else if ([passwordString length] < 3)
    {
        message = @"输入密码不得小于3位";
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_userlogin withParams:@{kUsername:phoneString,kPassword:passwordString} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
            if (!error && status == 200)
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[XRConfigs share] setUserDic:responseData];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *message = nil;
                if (status == 1)
                {
                    message = @"登录失败,用户名为空";
                }
                else if (status == 2)
                {
                    message = @"登录失败,用户名或密码错误";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
    if (message)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(IBAction)registerButtonTouchUp:(id)sender
{
    XRRegisterPhoneController *registerPhoneC = [[XRRegisterPhoneController alloc] init];
    [self.navigationController pushViewController:registerPhoneC animated:YES];
}

- (IBAction)forgetPswButtonTouchUp:(id)sender {
    XRForgetPswController *forgetPswC = [[XRForgetPswController alloc] init];
    [self.navigationController pushViewController:forgetPswC animated:YES];
}

-(IBAction)thirdLoginButtonClick:(UIButton *)sender
{
    NSString *thirdTip = @"";
    ShareType type = ShareTypeSinaWeibo;
    switch (sender.tag)
    {
        case 151:
        {
            type = ShareTypeSinaWeibo;
        }
            break;
        case 152:
        {
#warning - 需要支持网页版 否则被苹果拒绝
//            if (![WXApi isWXAppInstalled])
//            {
//                thirdTip = @"您的手机没有安装微信";
//            }
            type = ShareTypeWeixiTimeline;
        }
            break;
        case 153:
        {
//            if (![QQApiInterface isQQInstalled])
//            {
//                thirdTip = @"您的手机没有安装QQ";
//            }
            type = ShareTypeQQSpace;
        }
            break;
            
        default:
            break;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    if (thirdTip.length>0) { //没有安装微信或者QQ
//        hud.labelText = thirdTip;
//        hud.mode = MBProgressHUDModeText;
//        [hud hide:YES afterDelay:1.2];
//    } else {
        [XRShareCenter thirdLoginWithType:type result:^(BOOL success, NSString *errorString) {
            if (success)
            {
                [hud hide:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"第三方登录" forKey:@"ThirdLogin"];
            }
            else
            {
                hud.labelText = [NSString stringWithFormat:@"登录失败:%@",errorString];
                hud.mode = MBProgressHUDModeText;
                [hud hide:YES afterDelay:1.2];
            }
        }];
//    }
}

- (IBAction)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
