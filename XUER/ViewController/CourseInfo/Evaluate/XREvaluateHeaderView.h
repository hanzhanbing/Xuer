//
//  XREvaluateHeaderView.h
//  XUER
//
//  Created by 韩占禀 on 15/10/1.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRStarView.h"

@class XRCourseInfoController;
@interface XREvaluateHeaderView : UIView
{
    IBOutlet UIView *_starSuperView;
    XRStarView      *_starView;
}

@property (nonatomic,assign) XRCourseInfoController *superVC;

@end
