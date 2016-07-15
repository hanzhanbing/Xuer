//
//  XRSectionView.h
//  XUER
//
//  Created by 韩占禀 on 15/9/7.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XRCourseInfoController;
@interface XRSectionView : UIView
{
    IBOutlet UIButton   *_introduceButton;
    IBOutlet UIButton   *_directoryButton;
    IBOutlet UIButton   *_evaluateButton;
    IBOutlet UIView     *_lineView;
}

@property (nonatomic,assign) NSInteger  selectedIndex;
@property (nonatomic,assign) XRCourseInfoController *superVC;

@end
