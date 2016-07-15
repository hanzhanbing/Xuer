//
//  XRNetCenter.h
//  XUER
//
//  Created by 韩占禀 on 15/8/26.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBaseUrl @"http://www.xuer.com/theapi.php"

typedef void(^RequestCompletion)(NSDictionary *responseData,int status,NSError *error);

enum XRNetType
{
    XRNetType_userins,//注册
    XRNetType_useredit,//修改用户信息
    XRNetType_userlogin,//登录
    XRNetType_userFindPsw,//找回密码
    XRNetType_userGetCode,//获取验证码
    XRNetType_typelist,//全部课程
    XRNetType_courselist,//课程列表
    XRNetType_courseinfo,//课程信息
    XRNetType_messagelist,//消息列表
    XRNetType_messageinfo,//消息信息
    XRNetType_is_reg,//是否注册
    XRNetType_joincourse,//参加课程
    XRNetType_coursecommentadd,//发评论
    XRNetType_coursecomment,//评论列表
    XRNetType_checkupdate,//检查更新
    XRNetType_bannerlist,//banner列表
    XRNetType_joincourse_z,//学过课程章节
    XRNetType_searchlist,//搜索课程
    XRNetType_indexlist,//首页列表
    XRNetType_yijian,//意见反馈
    XRNetType_hotsearchwords,//热门搜索
};

@interface XRNetCenter : NSObject

+(XRNetCenter *)share;

-(void)sendRequestWithNetType:(enum XRNetType)type withParams:(NSDictionary *)params withImagePath:(NSString *)imagePath withCompletion:(RequestCompletion)completion;

@end
