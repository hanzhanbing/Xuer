//
//  XRCourseInfo.h
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XRTeacherInfo.h"
#import "XRDirectoryInfo.h"
#import "XRCommentInfo.h"

@interface XRCourseInfo : XRInfo

@property (nonatomic,strong) NSMutableArray *teacherArray;
@property (nonatomic,strong) NSMutableArray *directoryArray;
@property (nonatomic,strong) NSMutableArray *commentArray;
@property (nonatomic,strong) XRCommentInfo  *mycomment;

@property (nonatomic,strong) NSString       *stitle;//课程标题

@property (nonatomic,strong) NSString       *catid;//课程id
//@property (nonatomic,strong) NSString       *ctitle;//篇幅标题
@property (nonatomic,strong) NSString       *introduce;
@property (nonatomic,strong) NSString       *isjoin;
@property (nonatomic,strong) NSString       *sys_hours;
@property (nonatomic,strong) NSString       *listorder;
@property (nonatomic,strong) NSString       *thumb;

@end
