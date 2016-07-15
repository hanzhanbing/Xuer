//
//  XRTypeInfo.h
//  XUER
//
//  Created by 韩占禀 on 15/8/31.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XRSubTypeInfo.h"

@interface XRTypeInfo : XRInfo

@property (nonatomic,strong) NSString   *arrchildid;//分类id
//@property (nonatomic,strong) NSString   *description;
@property (nonatomic,strong) NSString   *name;
@property (nonatomic,strong) NSString   *linkageid;
@property (nonatomic,strong) NSString   *img;
@property (nonatomic,strong) NSArray    *children;//子分类，用于在课程列表展示

@end
