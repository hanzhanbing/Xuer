//
//  XREvaluateCell.m
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XREvaluateCell.h"
#import "XRCourseInfoController.h"
#import "UIView+Frame.h"

@implementation XREvaluateCell

- (void)awakeFromNib {
    // Initialization code
    _iconImageView.layer.cornerRadius = _iconImageView.width/2;
    _iconImageView.layer.masksToBounds = YES;
    
    _starView = [[[NSBundle mainBundle] loadNibNamed:@"XRStarView" owner:nil options:nil] firstObject];
    [_starSuperView addSubview:_starView];
    
    [_commentContentLabel setWidthToAutoresizeScreenWidth];
}

-(void)setCommentInfo:(XRCommentInfo *)commentInfo
{
//    if (_commentInfo != commentInfo)
    {
        _commentInfo = commentInfo;
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_commentInfo.logo] placeholderImage:[UIImage imageNamed:@"defaultIcon.png"]];
        
        NSString *realname = [_commentInfo.realname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([realname length] > 0)
        {
            _nameLabel.text = realname;
        }
        else
        {
            _nameLabel.text = @"无名氏";
        }
        
        [_nameLabel setSingleRowAutosizeLimitWidth:80];
        
        _commentContentLabel.text = _commentInfo.content;
        
        _commentTimeLabel.x = [_nameLabel getFrame_right]+10;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_commentInfo.tm.doubleValue];
        
        _commentTimeLabel.text = [NSDate stringForRecentDate:date];
        [_commentTimeLabel setSingleRowAutosizeLimitWidth:88];
        _starView.starValue = _commentInfo.star.floatValue;
        
        _starSuperView.x = [_commentTimeLabel getFrame_right]+10;
    }
}

@end
