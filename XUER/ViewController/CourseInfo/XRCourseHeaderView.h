//
//  XRCourseHeaderView.h
//  XUER
//
//  Created by 韩占禀 on 15/9/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCourseInfo.h"
#import "XRStarView.h"

@interface XRCourseHeaderView : UIView
{
    IBOutlet UIImageView    *_iconImageView;
    IBOutlet UILabel        *_titleLabel;
    IBOutlet UIView         *_starSuperView;
    IBOutlet UILabel        *_commentCountLabel;
    IBOutlet UILabel        *_isstudingLabel;
    
    XRStarView              *_starView;
}

@property (nonatomic,strong) XRCourseInfo   *courseInfo;

@end
