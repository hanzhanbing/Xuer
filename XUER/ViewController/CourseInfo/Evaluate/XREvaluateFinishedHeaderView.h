//
//  XREvaluateFinishedHeaderView.h
//  XUER
//
//  Created by 韩占禀 on 15/10/2.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRCourseInfoController;
@interface XREvaluateFinishedHeaderView : UIView
{
    IBOutlet UIView     *_starSuperView;
    XRStarView          *_starView;
    
    IBOutlet UIButton   *_editButton;
}

@property (nonatomic,assign) XRCourseInfoController *superVC;

@property (nonatomic,assign) float starValue;

@end
