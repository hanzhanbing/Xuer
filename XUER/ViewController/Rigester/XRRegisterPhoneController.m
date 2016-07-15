//
//  XRRigsterPhoneController.m
//  XUER
//
//  Created by 韩占禀 on 15/8/25.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRRegisterPhoneController.h"
#import "XRVerifyCodeController.h"

@interface XRRegisterPhoneController ()

@end

@implementation XRRegisterPhoneController

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    _nextButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    _nextButton.frame = CGRectMake(35, 104, kScreenWidth-70, 40);
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"loginButton"] forState:UIControlStateNormal];
    _nextButton.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addCustomNavagationBarWithTitle:@"填写手机号码" isNeedBackButton:YES];
    [_phoneTextField becomeFirstResponder];
    
    UIImage *image = [[_nextButton backgroundImageForState:UIControlStateNormal] resizableImage];
    [_nextButton setBackgroundImage:image forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:tap];
}

- (IBAction)gotoVerifyCodeC:(id)sender {
    if ([XRConfigs validateMobile:_phoneTextField.text])
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_is_reg withParams:@{kUsername:_phoneTextField.text} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (status == 200)
            {
                XRVerifyCodeController *verifyCodeC = [[XRVerifyCodeController alloc] init];
                verifyCodeC.phoneNum = _phoneTextField.text;
                [self.navigationController pushViewController:verifyCodeC animated:YES];
            }
            if (status == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            if (status == 2)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户已存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
    else if ([_phoneTextField.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号格式不正确" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
