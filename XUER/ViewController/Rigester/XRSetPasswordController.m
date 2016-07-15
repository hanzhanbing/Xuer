//
//  XRSetPasswordController.m
//  XUER
//
//  Created by 韩占禀 on 15/8/26.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRSetPasswordController.h"

@interface XRSetPasswordController ()

@property (nonatomic,strong) UIImagePickerController     *imagePickerC;

@end

@implementation XRSetPasswordController

-(void)viewLayout
{
    [_contentView setWidthToAutoresizeScreenWidth];
    [_passwordTextField setWidthToAutoresizeScreenWidth];
    [_finishButton setWidthToAutoresizeScreenWidth];
    
    UIImage *image = [[_finishButton backgroundImageForState:UIControlStateNormal] resizableImage];
    [_finishButton setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewLayout];
    [self addCustomNavagationBarWithTitle:@"设置密码" isNeedBackButton:YES];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:viewTap];
}

-(UIImagePickerController *)imagePickerC
{
    if (!_imagePickerC)
    {
        _imagePickerC = [[UIImagePickerController alloc] init];
        _imagePickerC.delegate = self;
        _imagePickerC.allowsEditing = YES;
        _imagePickerC.videoQuality = UIImagePickerControllerQualityType640x480;
    }
    
    return _imagePickerC;
}

-(IBAction)finishedRegister:(id)sender
{
    NSString *passwordStr = _passwordTextField.text;
    
    NSString *message = nil;
    if ([passwordStr length] == 0)
    {
        message = @"请输入密码";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if ([passwordStr length] < 6)
    {
        message = @"密码不能小于6位";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_is_reg withParams:@{kUsername:_phoneNum} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
            
            NSString *filePath = [XRFilePath filePathWithType:XRFilePathType_IconPath withFileName:nil];
            if (status == 200 || status == 2)
            {
                enum XRNetType type;
                if (status == 200)
                {
                    type = XRNetType_userins;
                }
                else
                {
                    type = XRNetType_useredit;
                }
                [[XRNetCenter share] sendRequestWithNetType:type withParams:@{kUsername:_phoneNum,kPassword:passwordStr} withImagePath:filePath withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
                    [[XRConfigs share] setUserDic:responseData];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccNotification object:nil];
                }];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSString *message = @"注册失败";
                if (status == 1)
                {
                    message = [message stringByAppendingString:@",用户名为空"];
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
