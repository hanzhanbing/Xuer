//
//  XRCourseListController.h
//  XUER
//
//  Created by 韩占禀 on 15/9/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRTypeInfo.h"

@interface XRCourseListController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView         *_contentView;
    IBOutlet UITableView    *_mainTableView;
}

@property (nonatomic,strong) NSArray *courseTypeArray;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;
@property (nonatomic,strong) XRTypeInfo *typeInfo;

@end
