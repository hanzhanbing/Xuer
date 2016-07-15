//
//  XRGoodCourseCell.m
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "XRGoodCourseCell.h"

@implementation XRGoodCourseCell

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //图片
        CGFloat imgW = (kScreenWidth-8*3)/2;
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(0, 0, imgW, imgW/2);
        [self addSubview:_iconImageView];
        //文字
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, imgW/2, imgW, 35);
        _titleLabel.textColor = [UIColor colorWithWhite:0.180 alpha:1.000];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLabel];
    }
    return self;
}

-(void)setCourseItemInfo:(XRCourseItemInfo *)courseItemInfo
{
    if (_courseItemInfo != courseItemInfo)
    {
        _courseItemInfo = courseItemInfo;
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:courseItemInfo.thumb]];
        _titleLabel.text = courseItemInfo.stitle;
    }
}

@end
