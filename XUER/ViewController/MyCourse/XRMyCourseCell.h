//
//  XRMyCourseCell.h
//  XUER
//
//  Created by 韩占禀 on 15/9/11.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRProgressView.h"
#import "XRCourseListInfo.h"

@interface XRMyCourseCell : UITableViewCell
{
    IBOutlet UIImageView    *_iconImageView;
    IBOutlet UILabel        *_titleLabel;
    IBOutlet UILabel        *_progressLabel;
    IBOutlet UIView         *_progressSuperView;
    XRProgressView          *_progressView;
}

@property (nonatomic,strong) XRCourseListInfo   *courseListInfo;

@end
