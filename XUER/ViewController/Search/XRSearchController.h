//
//  XRSearchController.h
//  XUER
//
//  Created by 韩占禀 on 15/9/11.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XRSearchController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView         *_contentView;
    IBOutlet UITextField    *_searchTextField;
    IBOutlet UIImageView    *_searchBgImageView;
    IBOutlet UITableView    *_mainTableView;
}

@property (nonatomic,strong) NSMutableArray *hotSourceArray;
@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end
