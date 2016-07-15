//
//  TextCell.m
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import "TextCell.h"

@interface TextCell ()
{
    UILabel     *timeLab;
    UIButton    *textView;
    UIImageView *iconImg;
}
@end

@implementation TextCell

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
    textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
    [self addSubview:textView];
}

- (void)setContentView:(XRMessageListInfo *)cellInfo {
    //设置frame
    CGSize timeSize = [cellInfo.tm sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 20)];
    timeLab.frame = CGRectMake((kScreenWidth-timeSize.width-10)/2, 5, timeSize.width+10, 20);
    
    CGSize contentSize = [cellInfo.con sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130, MAXFLOAT)];
    textView.frame = CGRectMake(CGRectGetMaxX(iconImg.frame)+5, CGRectGetMinY(iconImg.frame), kScreenWidth-90, contentSize.height+20);
    
    //设置内容
    iconImg.image = [UIImage imageNamed:@"icon"];
    
    timeLab.text = cellInfo.tm;

    NSString *textBg = cellInfo.tp==0 ? @"qipao-wenzi" : @"qipao-wenzi";
    UIImage *normal = [UIImage imageNamed:textBg];
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.8 topCapHeight:normal.size.height * 0.7];
    [textView setBackgroundImage:normal forState:UIControlStateNormal];
    [textView setTitle:cellInfo.con forState:UIControlStateNormal];
}

+ (NSString *)getIdentifier {
    return @"TextCellIdentifier";
}

+ (CGFloat)getHeight:(XRMessageListInfo *)cellInfo {
    CGFloat height = 0;
    CGSize contentSize = [cellInfo.con sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(kScreenWidth-130, MAXFLOAT)];
    height+=30;
    if (contentSize.height>45) {
        height+=contentSize.height+20;
    } else {
        height+=45;
    }
    height+=5;
    return height;
}

@end
