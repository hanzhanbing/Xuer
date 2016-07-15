//
//  XRAllCourseCell.m
//  XUER
//
//  Created by 韩占禀 on 15/8/25.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "XRAllCourseCell.h"

@implementation XRAllCourseCell

- (void)awakeFromNib {
    // Initialization code
    
    [_bgImageView setWidthToAutoresizeScreenWidthWithCount:3];
    _bgImageView.image = [_bgImageView.image resizableImage];
    _imageView.centerX = (kScreenWidth-20)/3/2;
    [_label setWidthToAutoresizeScreenWidthWithCount:3];
}

-(void)setTypeInfo:(XRTypeInfo *)typeInfo
{
    if (_typeInfo != typeInfo)
    {
        _typeInfo = typeInfo;
        [_imageView sd_setImageWithURL:[NSURL URLWithString:typeInfo.img]];
        _label.text = typeInfo.name;
        //添加渐变效果
        _imageView.alpha = 0.01;
        [UIView animateWithDuration:1 animations:^{
            _imageView.alpha = 1.0;
        }];
    }
}

@end
