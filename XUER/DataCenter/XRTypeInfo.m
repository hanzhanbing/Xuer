//
//  XRTypeInfo.m
//  XUER
//
//  Created by 韩占禀 on 15/8/31.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRTypeInfo.h"

@implementation XRTypeInfo

+(NSDictionary *)objectClassInArray
{
    return @{@"children":[XRSubTypeInfo class]};
}

@end
