//
//  XRCourseHeaderView.m
//  XUER
//
//  Created by 韩占禀 on 15/9/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseHeaderView.h"


@implementation XRCourseHeaderView

-(void)awakeFromNib
{
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"XRStarView" owner:nil options:nil] firstObject];
    [_starSuperView addSubview:_starView];
}

-(void)setCourseInfo:(XRCourseInfo *)courseInfo
{
    if (_courseInfo != courseInfo)
    {
        _courseInfo = courseInfo;
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_courseInfo.thumb] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _iconImageView.image = [image imageScaledInterceptToSize:CGSizeMake(640, 232) withNeed2x:YES];
        }];
        _titleLabel.text = _courseInfo.stitle;
        
        _starView.starValue = 5;
        _commentCountLabel.text = [NSString stringWithFormat:@"(%d)",(int)_courseInfo.commentArray.count];
        _isstudingLabel.text = [NSString stringWithFormat:@"%@人正在学习",_courseInfo.listorder];
    }
}

@end
