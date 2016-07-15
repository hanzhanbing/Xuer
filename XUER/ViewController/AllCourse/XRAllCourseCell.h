//
//  XRAllCourseCell.h
//  XUER
//
//  Created by 韩占禀 on 15/8/25.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRTypeInfo.h"

@interface XRAllCourseCell : UICollectionViewCell
{
    IBOutlet UIImageView    *_bgImageView;
    IBOutlet UIImageView    *_imageView;
    IBOutlet UILabel        *_label;
}

@property (nonatomic,strong) XRTypeInfo *typeInfo;

@end
