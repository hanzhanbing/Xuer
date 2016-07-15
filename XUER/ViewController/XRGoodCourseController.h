//
//  XRGoodCourseController.h
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRBannerView.h"

@interface XRGoodCourseController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    IBOutlet UICollectionView   *_mainCollectionView;
}

@property (nonatomic,strong) NSMutableArray    *bannerArr;
@property (nonatomic,strong) NSMutableArray    *goodCourseTypeArray;
@property (nonatomic,strong) NSMutableArray    *goodCourseArray;

@end
