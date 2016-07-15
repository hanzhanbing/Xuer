//
//  XRIntroduceCell.h
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRTeacherInfo.h"

@class XRCourseInfoController;
@interface XRIntroduceCell : UITableViewCell
{
    IBOutlet UIImageView    *_iconImageView;
    IBOutlet UILabel        *_nameLabel;
    IBOutlet UILabel        *_introduceLabel;
    IBOutlet UIImageView    *_oneLineImageView;
}

@property (nonatomic,strong) XRTeacherInfo  *teacherInfo;
@property (nonatomic,assign) XRCourseInfoController *superVC;

+(CGFloat)heightWithTeacherInfo:(XRTeacherInfo *)teacherInfo;

@end
