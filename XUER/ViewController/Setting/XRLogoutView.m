//
//  XRLogoutView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRLogoutView.h"
#import "XRSettingController.h"
#import "XRLoginController.h"

@implementation XRLogoutView

-(IBAction)logoutButtonClick:(id)sender
{
    [[XRConfigs share] setUserDic:nil];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLogin"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_superVC popToRoot:NO];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
}

@end
