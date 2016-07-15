//
//  XRMyCourseController.h
//  XUER
//
//  Created by mac on 16/3/23.
//  Copyright © 2016年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRMyCourseController : UIViewController<UITableViewDataSource,UITableViewDelegate>


{
        IBOutlet UIView         *_noDataView;
        IBOutlet UIView         *_loginView;
        IBOutlet UIButton       *_loginButton;
        IBOutlet UIView         *_contentView;
        IBOutlet UITableView    *_mainTableView;
}

@property (nonatomic,strong) NSMutableArray *myCourseArray;
@property (nonatomic,strong) NSMutableArray *myMessageArray;

@end
