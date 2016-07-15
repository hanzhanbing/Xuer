//
//  XRMessageListInfo.h
//  XUER
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

#define textPadding 15

@interface XRMessageListInfo : NSObject

/*!
 *  @brief 消息类型
 */
@property (nonatomic,assign) int tp;
/*!
 *  @brief 消息时间
 */
@property (nonatomic,strong) NSString *tm;
/*!
 *  @brief 系统图标
 */
@property (nonatomic,strong) NSString *logo;
/*!
 *  @brief 消息标题
 */
@property (nonatomic,strong) NSString *title;
/*!
 *  @brief 消息内容
 */
@property (nonatomic,strong) NSString *con;
/*!
 *  @brief 链接图标
 */
@property (nonatomic,strong) NSString *link_logo;
/*!
 *  @brief 链接内容
 */
@property (nonatomic,strong) NSString *link_con;
/*!
 *  @brief 链接地址
 */
@property (nonatomic,strong) NSString *href;

@end
