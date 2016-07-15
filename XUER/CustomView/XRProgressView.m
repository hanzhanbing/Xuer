//
//  XRProgressView.m
//  XUER
//
//  Created by 韩占禀 on 15/9/11.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRProgressView.h"

@implementation XRProgressView

-(void)awakeFromNib
{
    _progress = -1;
}

-(void)setProgress:(CGFloat)progress
{
    if (progress < 0)
    {
        progress = 0;
    }
    if (progress > 1)
    {
        progress = 1;
    }
    if (_progress != progress)
    {
        _progress = progress;
        _progressView.width = self.width * _progress;
    }
}

@end
