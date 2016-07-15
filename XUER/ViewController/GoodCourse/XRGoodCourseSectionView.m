//
//  XRGoodCourseSectionView.m
//  XUER
//
//  Created by 韩占禀 on 15/9/10.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRGoodCourseSectionView.h"

@implementation XRGoodCourseSectionView

- (void)awakeFromNib {
    // Initialization code
}

-(void)setSectionInfo:(XRCourseSecitonInfo *)sectionInfo
{
    if (_sectionInfo != sectionInfo)
    {
        _sectionInfo = sectionInfo;
        
        _sectionLabel.text = sectionInfo.title;
    }
}

@end
