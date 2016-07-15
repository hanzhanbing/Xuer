//
//  XREightCourseCell.h
//  XUER
//
//  Created by lamco on 16/3/15.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRGoodCourseController.h"

@interface XREightCourseCell : UICollectionReusableView

@property (nonatomic,strong) NSArray    *dataSourceArray;
@property (nonatomic,assign) XRGoodCourseController *superVC;

@end
