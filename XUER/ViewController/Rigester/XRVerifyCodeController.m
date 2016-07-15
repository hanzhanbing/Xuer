//
//  XRVerifyCodeController.m
//  XUER
//
//  Created by 韩占禀 on 15/8/25.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRVerifyCodeController.h"
#import "XRSetPasswordController.h"

#define kCountDownTime 59

@interface XRVerifyCodeController ()

@end

@implementation XRVerifyCodeController

-(void)viewLayout
{
    [_contentView setWidthToAutoresizeScreenWidth];
    [_phoneHintLabel setWidthToAutoresizeScreenWidth];
    [_verifyCodeTextField setWidthToAutoresizeScreenWidth];
    [_heightLineImageView setXToAddResizeScreenWidth];
    [_resendButton setXToAddResizeScreenWidth];
    [_timeLabel setXToAddResizeScreenWidth];
}

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavagationBarWithTitle:@"填写验证码" isNeedBackButton:YES];
    
    NSString *phoneStr = [NSString stringWithFormat:@"我们已经给你的手机号码%@发送了一条验证短信",_phoneNum];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:phoneStr];
    [string addAttribute:NSForegroundColorAttributeName value:kUIColorFromRGB(0xf8740a) range:NSMakeRange([@"我们已经给你的手机号码" length], [_phoneNum length])];
    _phoneHintLabel.attributedText = string;
    
    [self startCountDown];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_verifyCodeTextField becomeFirstResponder];
}

-(void)startCountDown
{
    [[XRNetCenter share] sendRequestWithNetType:XRNetType_userGetCode withParams:@{kPhone:_phoneNum} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
        if (!error && status == 200)
        {
            [[NSUserDefaults standardUserDefaults] setObject:responseData[@"code"] forKey:@"phoneCode"];
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
    
    _countDownTime = kCountDownTime;
    _timeLabel.text = [NSString stringWithFormat:@"%lu秒",_countDownTime];
    _resendButton.hidden = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
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

-(IBAction)resendButtonTouchUp:(id)sender
{
    [self startCountDown];
}

-(IBAction)gotoPasswordC:(id)sender
{
    NSString *phoneCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneCode"];
    if ([phoneCode isEqualToString:_verifyCodeTextField.text]) {
        XRSetPasswordController *setPasswordC = [[XRSetPasswordController alloc] init];
        setPasswordC.phoneNum = _phoneNum;
        [self.navigationController pushViewController:setPasswordC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
