//
//  XRStarView.m
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRStarView.h"

@implementation XRStarView

-(void)awakeFromNib
{
    self.starValue = 0;
    _redStarView.clipsToBounds = YES;
    _starType = StarType_Normal;
}

-(void)setStarType:(enum StarType)starType
{
    if (_starType != starType)
    {
        _starType = starType;
        if (_starType == StarType_Normal)
        {
            _grayStarImageView.image = [UIImage imageNamed:@"starGray5.png"];
            _redStarImageView.image = [UIImage imageNamed:@"starRed5.png"];
        }
        else if (_starType == StarType_Big)
        {
            _grayStarImageView.image = [UIImage imageNamed:@"starGray5_Big.png"];
            _redStarImageView.image = [UIImage imageNamed:@"starRed5_Big.png"];
        }
    }
}

-(void)setIsCanTouch:(BOOL)isCanTouch
{
    if (_isCanTouch != isCanTouch)
    {
        _isCanTouch = isCanTouch;
        if (isCanTouch)
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(starViewTap:)];
            [self addGestureRecognizer:tap];
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _grayStarImageView.frame = frame;
    _redStarView.frame = frame;
    _redStarImageView.frame = frame;
    
    _redStarView.width = _redStarImageView.width * (_starValue/5.0);
}

-(void)setStarValue:(float)starValue
{
    if (starValue < 0)
    {
        starValue = 0;
    }
    if (starValue > 5)
    {
        starValue = 5;
    }
    if (_starValue != starValue)
    {
        _starValue = starValue;
        
        _redStarView.width = _redStarImageView.width * (starValue/5.0);
    }
}

-(void)starViewTap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    self.starValue = point.x/(self.width/5.0);
}

@end
