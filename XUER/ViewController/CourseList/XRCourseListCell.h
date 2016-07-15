//
//  XRCourseListCell.h
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRStarView.h"
#import "XRCourseListInfo.h"

@interface XRCourseListCell : UITableViewCell
{
    XRStarView          *_starView;
    IBOutlet UIView     *_starSuperView;
    IBOutlet UIImageView    *_contentImageView;
    IBOutlet UILabel        *_nameLabel;
    IBOutlet UILabel        *_isStudingLabel;
    IBOutlet UILabel        *_updateTimeLabel;
}
@property (nonatomic,strong) XRCourseListInfo   *courseListInfo;

@end
