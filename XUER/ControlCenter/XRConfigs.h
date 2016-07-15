//
//  XRConfigs.h
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XRConfigs : NSObject

@property (nonatomic,strong) NSString   *userid;
@property (nonatomic,strong) NSString   *username;
@property (nonatomic,strong) NSString   *realname;
@property (nonatomic,assign) int sex;//0女1男
@property (nonatomic,strong) NSString   *email;
@property (nonatomic,strong) NSString   *logo;

+(XRConfigs *)share;

-(void)loadAllInfo;

+ (BOOL)validateMobile:(NSString *)mobileNum;

-(void)setUserDic:(NSDictionary *)userDic;

/*!
 *  判断网络是否连接
 *  @param haveTip：YES 有网络提示弹框 NO 无网络提示弹框
 *  @return 返回 YES  代表网络已经连接  返回NO代表当前没有网络
 */
+ (BOOL)getNetWorkStatus:(BOOL)haveTip;

/*!
 *  判断网络是否是移动网络
 *  @return 返回YES是移动网络，返回NO不是移动网络
 */
+ (BOOL)isMobileNetwork;

@end
