//
//  XRBannerView.h
//  XUER
//
//  Created by 韩占禀 on 15/10/3.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@class XRGoodCourseController;
@interface XRBannerView : UICollectionReusableView<SDCycleScrollViewDelegate>
{
    SDCycleScrollView           *_cycleScrollView;
}

@property (nonatomic,strong) NSMutableArray    *bannerArr;//bannerArr存放图片url
@property (nonatomic,assign) XRGoodCourseController *superVC;

@end
