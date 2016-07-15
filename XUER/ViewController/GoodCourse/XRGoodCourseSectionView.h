//
//  XRGoodCourseSectionView.h
//  XUER
//
//  Created by 韩占禀 on 15/9/10.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCourseSecitonInfo.h"

@interface XRGoodCourseSectionView : UICollectionReusableView
{
    IBOutlet UILabel    *_sectionLabel;
}

@property (nonatomic,strong) XRCourseSecitonInfo    *sectionInfo;

@end
