//
//  XRFeedbackController.m
//  XUER
//
//  Created by 韩占禀 on 15/10/5.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRFeedbackController.h"

@interface XRFeedbackController ()

@end

@implementation XRFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self addCustomNavagationBarWithTitle:@"意见反馈" isNeedBackButton:YES];
    _contactWayView.clipsToBounds = YES;
    _feedbackContentView.clipsToBounds = YES;
    UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 20, 60, 44)];
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [[self getCustomView] addSubview:submitButton];
    
    _feedbackTextView = [[TKPlaceHolderTextView alloc] initWithFrame:_feedbackContentView.bounds];
    [_feedbackContentView insertSubview:_feedbackTextView atIndex:0];
    _feedbackTextView.placeholder = @"写下问题和建议，我们将为您不断改进";
    _feedbackTextView.font = [UIFont systemFontOfSize:16];
    _feedbackTextView.delegate = self;
    _feedbackTextView.returnKeyType = UIReturnKeyNext;
    
    _contactWayTextView = [[TKPlaceHolderTextView alloc] initWithFrame:_contactWayView.bounds];
    [_contactWayView insertSubview:_contactWayTextView atIndex:0];
    _contactWayTextView.placeholder = @"手机或QQ号，以便我们必要时与您联系";
    _contactWayTextView.font = [UIFont systemFontOfSize:16];
    _contactWayTextView.delegate = self;
    _contactWayTextView.returnKeyType = UIReturnKeyDone;
    
    [_feedbackTextView becomeFirstResponder];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
    [self.view addGestureRecognizer:viewTap];
}

-(void)viewTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

-(void)submitButtonClick:(UIButton *)button
{
    if ([_feedbackTextView.text length] > 0 && [_contactWayTextView.text length] > 0)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *content = [NSString stringWithFormat:@"建议:%@\n联系方式:%@",_feedbackTextView.text,_contactWayTextView];
        [[XRNetCenter share] sendRequestWithNetType:XRNetType_yijian withParams:@{kUid:[XRConfigs share].userid.length>0?[XRConfigs share].userid:@"",kContent:content} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
            hud.labelText = @"意见反馈已发送";
            hud.mode = MBProgressHUDModeText;
            [hud hide:YES afterDelay:1.2];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self pop];
            });
        }];
    }
    else if ([_feedbackTextView.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入反馈内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else if ([_contactWayTextView.text length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _feedbackTextView)
    {
        if ([text isEqualToString:@"\n"])
        {
            [_contactWayTextView becomeFirstResponder];
            return NO;
        }
        return YES;
    }
    else
    {
        if ([text isEqualToString:@"\n"])
        {
            [self submitButtonClick:nil];
            return NO;
        }
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
