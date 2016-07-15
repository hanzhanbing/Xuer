//
//  XRSettingCell.m
//  XUER
//
//  Created by 韩占禀 on 15/10/5.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRSettingCell.h"
#import "AFNetworking.h"

@implementation XRSettingCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setIsFirst:(BOOL)isFirst
{
    _upLineView.hidden = !isFirst;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
