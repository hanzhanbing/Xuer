//
//  XRCourseInfo.m
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseInfo.h"

@implementation XRCourseInfo

+(NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"teacherArray":@"teacherlist",
             @"directoryArray":@"mulu",
             @"commentArray":@"comment",
             };
}

+(NSDictionary *)objectClassInArray
{
    return @{
             @"teacherArray":@"XRTeacherInfo",
             @"commentArray":@"XRCommentInfo",
             }; //@"directoryArray":@"XRDirectoryInfo",
}

-(void)setDirectoryArray:(NSMutableArray *)directoryArray{
    
    NSLog(@"%@",directoryArray);
    
    NSMutableArray *dirArr = [NSMutableArray array];
    for (int i = 0; i<directoryArray.count; i++) {
        if (i % 2 == 0) {
            XRDirectoryInfo *dirInfo = [[XRDirectoryInfo alloc] init];
            dirInfo.title = directoryArray[i][@"title"];
            [dirArr addObject:dirInfo];
        } else {
            NSArray *kcArr = directoryArray[i];
            for (int j = 0; j<kcArr.count; j++) {
                XRDirectoryInfo *dirInfo = [[XRDirectoryInfo alloc] init];
                NSString *mv_url = kcArr[j][@"mv_url"];
                NSString *videoId = [[mv_url componentsSeparatedByString:@"vid="] lastObject];
                videoId = [[videoId componentsSeparatedByString:@"&"] firstObject];
                dirInfo.sectionID = kcArr[j][@"id"];
                dirInfo.title = kcArr[j][@"title"];
                dirInfo.updatetime = kcArr[j][@"updatetime"];
                dirInfo.mv_url = mv_url;
                dirInfo.videoId = videoId;
                dirInfo.kc_hours = kcArr[j][@"kc_hours"];
                dirInfo.isstudied = kcArr[j][@"isstudied"];
                NSString *pro = [NSString stringWithFormat:@"%@",kcArr[j][@"progress"]];
                pro = pro.length>0?pro:@"0";
                dirInfo.progress = [pro floatValue];
                [dirArr addObject:dirInfo];
            }
        }
    }
    _directoryArray = dirArr;
}

@end
