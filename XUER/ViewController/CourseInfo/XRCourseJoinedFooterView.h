//
//  XRCourseJoinedFooterView.h
//  XUER
//
//  Created by 韩占禀 on 15/10/2.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDirectoryInfo.h"

@class XRCourseInfoController;
@interface XRCourseJoinedFooterView : UIView
{
    IBOutlet UILabel    *_courseTitleLabel;
}

@property (nonatomic,strong) XRDirectoryInfo    *directoryInfo;
@property (nonatomic,assign) XRCourseInfoController *superVC;

@end
