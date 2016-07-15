//
//  XRSettingController.h
//  XUER
//
//  Created by 韩占禀 on 15/10/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRPersonInfoView.h"
#import "XRLogoutView.h"

@interface XRSettingController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIView         *_contentView;
    IBOutlet UITableView    *_mainTableView;
    
    XRPersonInfoView        *_personInfoView;
    XRLogoutView            *_logoutView;
}

@property (nonatomic,strong) NSArray *dataSourseArray;

@end
