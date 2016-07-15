//
//  XRGoodCourseCell.h
//  XUER
//
//  Created by lamco on 16/3/24.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCourseItemInfo.h"

@interface XRGoodCourseCell : UICollectionViewCell
{
    UIImageView    *_iconImageView;
    UILabel        *_titleLabel;
}

@property (nonatomic,strong) XRCourseItemInfo *courseItemInfo;

@end
