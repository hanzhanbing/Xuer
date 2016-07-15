//
//  XRMyMessageCell.m
//  XUER
//
//  Created by mac on 16/3/22.
//  Copyright © 2016年 a. All rights reserved.
//

#import "XRMyMessageCell.h"

@implementation XRMyMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMessageListInfo:(XRMessageListInfo *)messageListInfo{
    if (_messageListInfo != messageListInfo)
    {
        _messageListInfo = messageListInfo;
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_messageListInfo.logo]];
        _titleLabel.text = _messageListInfo.title;
        _contentLabel.text = _messageListInfo.con;
        _dateLabel.text = _messageListInfo.tm;
    }
}

@end
