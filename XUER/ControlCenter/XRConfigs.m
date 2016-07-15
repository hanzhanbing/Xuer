//
//  XRConfigs.m
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRConfigs.h"
#import "RealReachability.h"

static XRConfigs *_configs = nil;

@implementation XRConfigs

+(XRConfigs *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _configs = [[XRConfigs alloc] init];
    });
    return _configs;
}

-(void)loadAllInfo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [defaults objectForKey:kUserDic];
    if (userDic)
    {
        [self loadUserDic:userDic];
    }
}

-(void)setUserDic:(NSDictionary *)userDic
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userDic forKey:kUserDic];
    [defaults synchronize];
    
    [self loadUserDic:userDic];
}

-(void)loadUserDic:(NSDictionary *)userDic
{
    self.userid = userDic[kId];
    self.username = userDic[kUsername];
    self.realname = userDic[kRealname];
    self.sex = [userDic[kSex] intValue];
    self.email = userDic[kEmail];
    self.logo = userDic[kLogo];
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    if (mobileNum.length == 11 && [mobileNum substringToIndex:1].intValue == 1)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

#pragma mark -------------判断有无网络-------------
+ (BOOL)getNetWorkStatus:(BOOL)haveTip
{
    BOOL isExistenceNetwork = NO;
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable)
    {
        isExistenceNetwork = NO;
        if (haveTip==YES) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您的网络有问题\n请检查网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    if (status == RealStatusViaWiFi)
    {
        isExistenceNetwork = YES;
    }
    
    if (status == RealStatusViaWWAN)
    {
        isExistenceNetwork = YES;
    }
    
    return isExistenceNetwork;
}

#pragma mark -----------判断是否是移动网络-----------
+ (BOOL)isMobileNetwork
{
    BOOL isExistenceNetwork = NO;
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusViaWWAN)
    {
        isExistenceNetwork = YES;
    }
    
    return isExistenceNetwork;
}

@end
