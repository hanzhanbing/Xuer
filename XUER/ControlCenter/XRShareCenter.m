//
//  XRShareCenter.m
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRShareCenter.h"

static XRShareCenter    *_shareCenter = nil;

@implementation XRShareCenter

+(XRShareCenter *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareCenter = [[XRShareCenter alloc] init];
    });
    return _shareCenter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)registerShareSDK
{
    [ShareSDK registerApp:@"aea3818a9c1d"];
    
    [ShareSDK connectWeChatWithAppId:@"wx24fbe9e6721b6569"   //微信APPID
                           appSecret:@"6e0df38c7a269064168b9508d8efa97f"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    [ShareSDK connectQQWithAppId:@"1104788131" qqApiCls:[QQApiInterface class]];
    
    [ShareSDK connectQZoneWithAppKey:@"1104788131"
                           appSecret:@"FI06WV49kC7QUsj6"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
//    [ShareSDK  connectSinaWeiboWithAppKey:@"2247022143"
//                            appSecret:@"96f06918765efba2d6d10d27c39d0740"
//                              redirectUri:@"http://www.xuer.com"];
    
    [ShareSDK  connectSinaWeiboWithAppKey:@"1826486655"
                            appSecret:@"6a454224fda55eda01b586d05e11ee11"
                              redirectUri:@"http://www.xuer.com"];
}

+(void)thirdLoginWithType:(ShareType)type result:(ThirdLoginResult)loginResult
{
    //[ShareSDK cancelAuthWithType:type];
    [ShareSDK getUserInfoWithType:type authOptions:nil result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        NSLog(@"thirdLoginWithType:%@,%@",userInfo,[error errorDescription]);
        if (result)
        {
            NSString *username = userInfo.uid;
            NSString *nickname = userInfo.nickname;
            NSString *profileImage = userInfo.profileImage;
            
            [[XRNetCenter share] sendRequestWithNetType:XRNetType_is_reg withParams:@{kUsername:username} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
                if (status == 2)
                {
                    [[XRNetCenter share] sendRequestWithNetType:XRNetType_userlogin withParams:@{kUsername:username,kPassword:username} withImagePath:nil withCompletion:^(NSDictionary *responseData,int status, NSError *error) {
                        if (status == 200)
                        {
                            [[XRConfigs share] setUserDic:responseData];
                            loginResult(YES,nil);
                        }
                        else
                        {
                            loginResult(NO,error.localizedDescription);
                        }
                    }];
                }
                else if (status == 200)
                {
                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:profileImage]];
                        
                        NSString *iconPath = [XRFilePath filePathWithType:XRFilePathType_IconPath withFileName:nil];
                        [data writeToFile:iconPath atomically:YES];
                        
                        [[XRNetCenter share] sendRequestWithNetType:XRNetType_userins withParams:@{kUsername:username,kPassword:username,kRealname:nickname,@"sex":@"1"} withImagePath:iconPath withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
                            if (status == 200)
                            {
                                [[XRConfigs share] setUserDic:responseData];
                                loginResult(YES,nil);
                            }
                            else
                            {
                                loginResult(NO,error.localizedDescription);
                            }
                        }];
                    });
                }
            }];
        }
        else
        {
            loginResult(NO,error.errorDescription);
        }
    }];
}

+(void)shareToSocialPlatformWithType:(ShareType)type
{
    //如果第二次还想弹出登录框的时候，可以调用这句话
    [ShareSDK cancelAuthWithType:type];
    
    NSString *img = [[NSBundle mainBundle] pathForResource:@"icon_512.png" ofType:nil];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"我在学啊网学习，你也赶紧来吧！"
                                       defaultContent:@"我在学啊网学习，你也赶紧来吧！"
                                                image:[ShareSDK imageWithPath:img]
                                                title:@"学啊网"
                                                  url:@"http://www.xuer.com"
                                          description:@"学啊网是北京蓝科新宇股份科技有限公司旗下高端在线教育产品，有优势教学资源，聘请国内一线讲师，采用国际最先进高清视频录制技术，实现课堂真实环境的完美还原！结合“互联网+”教学模式线下+线上互动的新媒体教学方式，以解决当前应届大学生就业难为已任，给学员提供一站式学习就业解决方案！通过学啊网，与全国各大高校合作搭建在线学习平台，促进校企合作，为社会培育除了专业知识之外更具有“一技之长”的高素质人才！学啊网功能模块：高清在线视频系统、在线问答系统、在线考试系统、在线交流论坛、猎聘服务等模块，全方位提高学员整体素质，巩固学习成果！"
                                            mediaType:SSPublishContentMediaTypeNews];
    //自定义UI分享
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:nil
              shareOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        NSLog(@"%@",error.errorDescription);
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"发表成功");
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"分享成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"发布失败!");
                            NSString *message = [NSString stringWithFormat:@"分享失败,%@",error.errorDescription];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alert show];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:kShareFinishedNotification object:nil];
                    }];
}

@end
