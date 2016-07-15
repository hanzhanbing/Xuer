//
//  XRMyCourseCell.m
//  XUER
//
//  Created by 韩占禀 on 15/9/11.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRMyCourseCell.h"

@implementation XRMyCourseCell

- (void)awakeFromNib {
    // Initialization code
    
    _progressView = [[[NSBundle mainBundle] loadNibNamed:@"XRProgressView" owner:nil options:nil] firstObject];
    [_progressSuperView addSubview:_progressView];
}

-(void)setCourseListInfo:(XRCourseListInfo *)courseListInfo
{
    if (_courseListInfo != courseListInfo)
    {
        _courseListInfo = courseListInfo;
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:courseListInfo.thumb]];
        _titleLabel.text = courseListInfo.stitle;
        _progressLabel.text = [NSString stringWithFormat:@"已学过%@",courseListInfo.jindu];
        _progressView.progress = courseListInfo.progress;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
