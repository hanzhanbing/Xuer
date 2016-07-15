//
//  XRDirectoryInfo.m
//  XUER
//
//  Created by 韩占禀 on 15/9/9.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRDirectoryInfo.h"

@implementation XRDirectoryInfo

-(void)setMv_url:(NSString *)mv_url
{
    if (_mv_url != mv_url)
    {
        _mv_url = mv_url;
        _videoId = [[mv_url componentsSeparatedByString:@"vid="] lastObject];
        _videoId = [[_videoId componentsSeparatedByString:@"&"] firstObject];
        _progress = 0;
    }
}

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"sectionID":@"id"};
}

@end
