//
//  XRInfo.m
//  XUER
//
//  Created by 韩占禀 on 15/9/26.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRInfo.h"

@implementation XRInfo

MJExtensionLogAllProperties

-(id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if (property.type.typeClass == [NSString class])
    {
        if ([oldValue isKindOfClass:[NSNull class]])
        {
            return @"";
        }
    }
    else if ([oldValue isKindOfClass:[NSNull class]])
    {
        return [[property.type.typeClass alloc] init];
    }
    return oldValue;
}

@end
