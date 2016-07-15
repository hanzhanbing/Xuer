//
//  XRCourseSecitonInfo.m
//  XUER
//
//  Created by 韩占禀 on 15/9/10.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseSecitonInfo.h"

@implementation XRCourseSecitonInfo

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"courseArray":@"course"};
}

+(NSDictionary *)objectClassInArray
{
    return @{@"courseArray":@"XRCourseItemInfo"};
}

@end
