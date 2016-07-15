//
//  XRSearchResultController.h
//  XUER
//
//  Created by lamco on 16/3/23.
//  Copyright © 2016年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRSearchResultController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView *_contentView;
    IBOutlet UITableView *_mainTableView;
}

@property (nonatomic,copy) NSString *searchKey;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end
