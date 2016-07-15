//
//  XREvaluateHeaderView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/1.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XREvaluateHeaderView.h"
#import "XRCourseInfoController.h"
#import "XREvaluateContentView.h"
#import "XRLoginController.h"

@implementation XREvaluateHeaderView

-(void)awakeFromNib
{
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"XRStarView" owner:nil options:nil] firstObject];
    [_starSuperView addSubview:_starView];
    _starView.frame = _starSuperView.bounds;
    _starView.starType = StarType_Big;
}

-(IBAction)starButtonClick:(id)sender
{
    if (![XRConfigs share].username) //判断用户是否登录
    {
        __weak MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.superVC.view animated:YES];
        hud.labelText = @"请先登录";
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1.2];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，您还没有登录哦！快快去登录吧！" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//        [alert show];
    } else {
        XREvaluateContentView *evaluateView = [[[NSBundle mainBundle] loadNibNamed:@"XREvaluateContentView" owner:nil options:nil] firstObject];
        evaluateView.frame = [UIScreen mainScreen].bounds;
        evaluateView.superVC = _superVC;
        evaluateView.cid = _superVC.courseId;
        [evaluateView showInView:_superVC.view isEditOrAdd:@"add"];
    }
}

#pragma mark - UIAlertViewDelegate协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
    }
}

@end
