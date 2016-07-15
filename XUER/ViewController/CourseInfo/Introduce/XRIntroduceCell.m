//
//  XRIntroduceCell.m
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRIntroduceCell.h"
#import "XRCourseInfoController.h"

@implementation XRIntroduceCell

- (void)awakeFromNib {
    // Initialization code
    [_nameLabel setWidthToAutoresizeScreenWidth];
    [_introduceLabel setWidthToAutoresizeScreenWidth];
}

-(void)setTeacherInfo:(XRTeacherInfo *)teacherInfo
{
    if (_teacherInfo != teacherInfo)
    {
        _teacherInfo = teacherInfo;
        
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_teacherInfo.logo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _iconImageView.image = [image imageScaledInterceptToSize:_iconImageView.size withNeed2x:YES];
        }];
        _nameLabel.text = _teacherInfo.realname;
        
        NSString *str = [_teacherInfo.teach_introduce stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        _introduceLabel.text = str;
        
        CGRect rect = [teacherInfo.teach_introduce boundingRectWithSize:CGSizeMake(kScreenWidth-86, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
        _introduceLabel.height = rect.size.height;
        _oneLineImageView.y = [_introduceLabel getFrame_Bottom]+20;
    }
}

+(CGFloat)heightWithTeacherInfo:(XRTeacherInfo *)teacherInfo
{
    CGRect rect = [teacherInfo.teach_introduce boundingRectWithSize:CGSizeMake(kScreenWidth-86, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    return rect.size.height+58;
}

@end
