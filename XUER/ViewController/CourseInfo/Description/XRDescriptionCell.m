//
//  XRDescriptionCell.m
//  XUER
//
//  Created by scsys on 16/4/21.
//  Copyright © 2016年 a. All rights reserved.
//

#import "XRDescriptionCell.h"

@implementation XRDescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_introduceLabel setWidthToAutoresizeScreenWidth];
}

-(void)setIntroduce:(NSString *)introduce
{
    if (_introduce != introduce)
    {
        _introduce = introduce;
    
        //NSString *str = [_introduce stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        CGRect labFrame = _introduceLabel.frame;
        labFrame.size.width = kScreenWidth-20;
        _introduceLabel.frame = labFrame;
        _introduceLabel.text = _introduce;
        
        CGRect rect = [_introduce boundingRectWithSize:CGSizeMake(kScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        _introduceLabel.height = rect.size.height;
    }
}

+(CGFloat)heightWithIntroduce:(NSString *)introduce
{
    CGRect rect = [introduce boundingRectWithSize:CGSizeMake(kScreenWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return rect.size.height+30;
}

@end
