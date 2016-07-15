//
//  XRDirectoryCell.h
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRDirectoryInfo.h"

@class XRCourseInfoController;
@interface XRDirectoryCell : UITableViewCell
{
    IBOutlet UIImageView *_coursePlay;
    IBOutlet UILabel    *_titleLabel;
    IBOutlet UIView     *_downloadView;
    IBOutlet UIImageView    *_downloadGrayImageView;
    IBOutlet UIView     *_downloadGreenView;
    IBOutlet UILabel    *_videoSizeLabel;
    IBOutlet UILabel    *_progressLabel;
}

@property (nonatomic,strong) XRDirectoryInfo    *directoryInfo;
@property (nonatomic,assign) XRCourseInfoController *superVC;

@end
