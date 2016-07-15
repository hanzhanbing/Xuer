//
//  XRCourseNoJoinFooterView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/2.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseNoJoinFooterView.h"
#import "XRCourseInfoController.h"

@implementation XRCourseNoJoinFooterView

-(IBAction)joinButtonClick:(id)sender
{
    [_superVC joinCourse];
}

@end
