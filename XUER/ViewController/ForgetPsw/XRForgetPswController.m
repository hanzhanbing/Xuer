


//  XRForgetPswController.m
//  XUER
//
//  Created by lamco on 16/3/4.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "XRForgetPswController.h"
#import "XRLoginController.h"

#define kCountDownTime 59

@interface XRForgetPswController ()

@end

@implementation XRForgetPswController

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self addCustomNavagationBarWithTitle:@"忘记密码" isNeedBackButton:YES];
    [_inputPhoneNumber becomeFirstResponder];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:viewTap];
}

-(void)startCountDown
{
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_userGetCode withParams:@{kPhone:_inputPhoneNumber.text} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
        if (!error && status == 200)
        {
            [[NSUserDefaults standardUserDefaults] setObject:responseData[@"code"] forKey:@"phoneCode"];
            _countDownTime = kCountDownTime;
            _timeLabel.text = [NSString stringWithFormat:@"%lu秒",_countDownTime];
            _resendButton.hidden = YES;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
        }
        else
        {
            NSString *message = nil;
            if (status == 1)
            {
                message = @"手机号错误";
            }
            else if (status == 2)
            {
                message = @"60秒内只能收取一次";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

-(void)changeTime
{
    _countDownTime--;
    _timeLabel.text = [NSString stringWithFormat:@"%lu秒",_countDownTime];
    if (_countDownTime <= 0)
    {
        _timeLabel.text = @"";
        _resendButton.hidden = NO;
        [_timer invalidate];
        
        //防止_timer被释放掉后还继续访问
        _timer = nil;
    }
}

#pragma mark - 重新获取验证码
- (IBAction)resendButtonTouchUp:(id)sender {
    [self startCountDown];
}

#pragma mark - 完成按钮点击
- (IBAction)doneButtonTouchUp:(id)sender {
    [self.view endEditing:YES]; //关闭键盘
    
    NSString *message = nil;
    NSString *phoneString = _inputPhoneNumber.text;
    NSString *passwordString = _inputNewPsw.text;
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
        message = @"请输入新密码";
    }
    else if ([passwordString length] < 6)
    {
        message = @"输入密码不得小于6位";
    }
    else
    {
        NSString *phoneCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneCode"];
        if ([phoneCode isEqualToString:_verifyCodeTextField.text]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [[XRNetCenter share] sendRequestWithNetType:XRNetType_userFindPsw withParams:@{kUsername:phoneString,kPassword:passwordString} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *message = nil;
                    if (!error && status == 200)
                    {
                        message = @"密码设置成功";
                        [self pop];
                    }
                    else
                    {
                        if (status == 1)
                        {
                            message = @"用户名为空";
                        }
                        else if (status == 2)
                        {
                            message = @"用户名不存在";
                        }
                    }
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil, nil];
                    [alert show];
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
    }
    if (message)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
