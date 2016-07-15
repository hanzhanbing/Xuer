//
//  XRShareCenter.h
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"

#define kShareFinishedNotification   @"kShareFinishedNotification"

typedef void(^ThirdLoginResult)(BOOL success, NSString *errorString);

@interface XRShareCenter : NSObject

+(void)registerShareSDK;

+(void)thirdLoginWithType:(ShareType)type result:(ThirdLoginResult)loginResult;

+(void)shareToSocialPlatformWithType:(ShareType)type;

@end
