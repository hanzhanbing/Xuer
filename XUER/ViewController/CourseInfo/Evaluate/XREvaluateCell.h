//
//  XREvaluateCell.h
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCommentInfo.h"

@class XRCourseInfoController;
@interface XREvaluateCell : UITableViewCell
{
    IBOutlet UIImageView    *_iconImageView;
    IBOutlet UILabel        *_nameLabel;
    IBOutlet UILabel        *_commentTimeLabel;
    IBOutlet UILabel        *_commentContentLabel;
    IBOutlet UIView         *_starSuperView;
    XRStarView              *_starView;
}

@property (nonatomic,assign) XRCourseInfoController *superVC;
@property (nonatomic,strong) XRCommentInfo  *commentInfo;

@end
