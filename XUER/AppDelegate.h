//
//  AppDelegate.h
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWDownloadItem.h"
#import "DWDrmServer.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, strong) UIImageView   *imageView;

@property (strong, nonatomic)DWDrmServer *drmServer;//CC视频集成
@property (strong, nonatomic)DWDownloadItems *downloadFinishItems;
@property (strong, nonatomic)DWDownloadItems *downloadingItems;

+ (UITabBarController *)tabBarController;
+ (UIViewController *)rootViewController;

@end

