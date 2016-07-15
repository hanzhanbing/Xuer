//
//  XRCourseListInfo.m
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseListInfo.h"

@implementation XRCourseListInfo

-(void)setJindu:(NSString *)jindu
{
    if (_jindu != jindu)
    {
        _jindu = jindu;
        _progress = [[[jindu componentsSeparatedByString:@"%"] firstObject] floatValue]/100.0;
    }
}

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"courseId":@"id"};
}

@end
