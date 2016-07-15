//
//  TextPicLinkCell.m
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "TextPicLinkCell.h"

@interface TextPicLinkCell ()
{
    UILabel     *timeLab;
    UIButton    *textView;
    UIImageView *iconImg;
    UIImageView *linkImg;
    NSString    *url;
}
@end

@implementation TextPicLinkCell

- (void)addContentView {
    //时间
    timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textColor = [UIColor whiteColor];
    timeLab.textAlignment = NSTextAlignmentCenter;
    timeLab.backgroundColor = [UIColor colorWithWhite:0.780 alpha:1.000];
    timeLab.layer.cornerRadius = 5;
    [timeLab.layer setMasksToBounds:YES];
    [self addSubview:timeLab];
    
    //消息图标
    iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 45, 45)];
    [self addSubview:iconImg];
    
    //内容
    textView = [UIButton buttonWithType:UIButtonTypeCustom];
    textView.titleLabel.numberOfLines = 0;
    textView.titleLabel.font = [UIFont systemFontOfSize:14];
    [textView setTitleColor:[UIColor colorWithRed:0.224 green:0.227 blue:0.235 alpha:1.000] forState:UIControlStateNormal];
    textView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    textView.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
    [self addSubview:textView];
    
    //链接图标
    linkImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    [textView addSubview:linkImg];
    
    //链接按钮
    self.linkbtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.linkbtn setTitleColor:[UIColor colorWithRed:0.463 green:0.525 blue:0.576 alpha:1.000] forState:UIControlStateNormal];
    self.linkbtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [textView addSubview:self.linkbtn];
}

- (void)setContentView:(XRMessageListInfo *)cellInfo {
    //设置frame
    CGSize timeSize = [cellInfo.tm sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    timeLab.frame = CGRectMake((kScreenWidth-timeSize.width-10)/2, 5, timeSize.width+10, 20);
    
    CGSize contentSize = [cellInfo.con sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130, MAXFLOAT)];
    textView.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, CGRectGetMinY(iconImg.frame), kScreenWidth-90, contentSize.height+70);
    
    linkImg.frame = CGRectMake(15, contentSize.height+25, 30, 30);
    
    CGSize linkContentSize = [cellInfo.link_con sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    self.linkbtn.frame = CGRectMake(CGRectGetMaxX(linkImg.frame)+5, 0, linkContentSize.width>kScreenWidth-140?kScreenWidth-140:linkContentSize.width, 20);
    self.linkbtn.centerY = linkImg.centerY;
    
    //设置内容
    iconImg.image = [UIImage imageNamed:@"icon"];
    
    timeLab.text = cellInfo.tm;
    
    NSString *textBg = cellInfo.tp==0 ? @"qipao-wenzi" : @"qipao-youlianjie";
    UIImage *normal = [UIImage imageNamed:textBg];
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.8 topCapHeight:normal.size.height * 0.7];
    [textView setBackgroundImage:normal forState:UIControlStateNormal];
    [textView setTitle:cellInfo.con forState:UIControlStateNormal];
    
    linkImg.image = [UIImage imageNamed:@"icon"];
    
    [self.linkbtn setTitle:cellInfo.link_con forState:UIControlStateNormal];
    
    url = cellInfo.link_logo;
}

+ (NSString *)getIdentifier {
    return @"TextPicLinkCellIdentifier";
}

+ (CGFloat)getHeight:(XRMessageListInfo *)cellInfo {
    CGFloat height = 0;
    CGSize contentSize = [cellInfo.con sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130, MAXFLOAT)];
    height+=30;
    height+=contentSize.height+20;
    height+=50;
    height+=5;
    return height;
}

@end
