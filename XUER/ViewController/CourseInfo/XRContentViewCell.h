//
//  XRContentViewCell.h
//  XUER
//
//  Created by 韩占禀 on 15/9/6.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCourseInfo.h"
#import "XREvaluateHeaderView.h"
#import "XREvaluateFinishedHeaderView.h"

@class XRCourseInfoController;
@interface XRContentViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIScrollView   *_scrollView;
    
    UITableView             *_introduceTableView;
    UITableView             *_directoryTableView;
    UITableView             *_evaluateTableView;
    XREvaluateHeaderView    *_evaluateHeaderView;
    XREvaluateFinishedHeaderView    *_evaluateFinishedHeaderView;
}

@property (nonatomic,assign) XRCourseInfoController *superVC;
@property (nonatomic,strong) XRCourseInfo   *courseInfo;

-(void)setIndex:(NSInteger)index;

@end
