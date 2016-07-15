//
//  XRCourseListCell.m
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseListCell.h"

@implementation XRCourseListCell

- (void)awakeFromNib {
    // Initialization code
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"XRStarView" owner:nil options:nil] firstObject];
    [_starSuperView addSubview:_starView];
}

-(void)setCourseListInfo:(XRCourseListInfo *)courseListInfo
{
    if (_courseListInfo != courseListInfo)
    {
        _courseListInfo = courseListInfo;
        [_contentImageView sd_setImageWithURL:[NSURL URLWithString:courseListInfo.thumb]];
        _nameLabel.text = courseListInfo.stitle;
        _isStudingLabel.text = [NSString stringWithFormat:@"%@人正在学习",courseListInfo.count];
        _updateTimeLabel.text = [NSString stringWithFormat:@"更新时间:%@",courseListInfo.updatetime];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
