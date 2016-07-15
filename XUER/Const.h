//
//  Const.h
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#ifndef XUER_Const_h
#define XUER_Const_h

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kUIColorAFromRGB(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define NumberToString(x)      ([NSString stringWithFormat:@"%@",x])

#define kImg    @"img"
#define kTitle  @"title"

#define kAct    @"act"

#define kTp         @"tp"
#define kTaguid     @"taguid"
#define kUid        @"uid"
#define kUsername   @"username"
#define kPassword   @"password"
#define kPhone      @"phone"
#define kId         @"id"
#define kIds        @"ids"
#define kRealname   @"realname"
#define kLogo       @"logo"
#define kSex        @"sex"
#define kEmail      @"email"
#define kData       @"data"
#define kStatus     @"status"
#define kUserDic    @"userDic"
#define kArrchildid @"arrchildid"
#define kName       @"name"
#define kChildren   @"children"
#define kCatid      @"catid"
#define kStitle     @"stitle"
#define kThumb      @"thumb"
#define kPage       @"page"
#define kCount      @"count"
#define kUpdatetime @"updatetime"
#define kMv_url     @"mv_url"
#define kKc_hours   @"kc_hours"
#define kTp         @"tp"
#define kTeach_introduce    @"teach_introduce"
#define kStar               @"star"
#define kContent            @"content"
#define kTm                 @"tm"
#define kTeacherlist        @"teacherlist"
#define kChildren           @"children"
#define kComment            @"comment"
#define kIsstudied          @"isstudied"
#define kIntroduce          @"introduce"
#define kIsjoin             @"isjoin"
#define kSys_hours          @"sys_hours"
#define kListorder          @"listorder"
#define kCourse             @"course"
#define kCid                @"cid"
#define kCourseid           @"courseid"
#define kKeyword            @"keyword"
#define kZid                @"zid"
#define kProgress           @"progress"
#define kError              @"error"

#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define kScreenWidth   [UIScreen mainScreen].bounds.size.width

#define kLoginSuccNotification  @"kLoginSuccNotification"
#define kLoginFailNotification  @"kLoginFailNotification"
#define kLogoutSuccNotification  @"kLogoutSuccNotification"

#define kEvaluationSuccNotification @"kEvaluationSuccNotification"

#define kProgressUpdateNotification @"kProgressUpdateNotification"
#define kVideoDownloadFinishNotification    @"kVideoDownloadFinishNotification"

#define CanCommentCourse    @"CanCommentCourse"



//CC视频key和userid--->
#define DWACCOUNT_USERID @"159B280E26968646"
#define DWACCOUNT_APIKEY @"9mw7j63npBuFHFnwqY14m2QQbR922tLm"

#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

#import "AppDelegate.h"
#define DWAPPDELEGATE ((AppDelegate*)([[UIApplication sharedApplication] delegate]))

#if DEBUG
#define logtrace() NSLog(@"%s():%d ", __func__, __LINE__)
#define logdebug(format, ...) NSLog(@"%s():%d "format, __func__, __LINE__, ##__VA_ARGS__)
#else
#define logdebug(format, ...)
#define logtrace()
#endif

#define loginfo(format, ...) NSLog(@"%s():%d "format, __func__, __LINE__, ##__VA_ARGS__)

#define logerror(format, ...) NSLog(@"%s():%d ERROR "format, __func__, __LINE__, ##__VA_ARGS__)

#define DWDownloadingItemPlistFilename @"downloadingItems.plist"
#define DWDownloadFinishItemPlistFilename @"downloadFinishItems.plist"
//<-----CC视频

#define kDownloadingDefinition @"kDownloadingDefinition" //视频下载清晰度
#define kWatchingByMobileNetwork @"kWatchingByMobileNetwork" //移动网络观看视频
#define kDownloadingByMobileNetwork    @"kDownloadingByMobileNetwork" //移动网络下载视频
//<-----设置控制量

typedef enum : NSUInteger {
    TextCellType = 1,
    TextLinkCellType,
    TextPicLinkCellType,
} SysMessageType;

#endif
