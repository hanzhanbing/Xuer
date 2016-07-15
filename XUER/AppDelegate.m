//
//  AppDelegate.m
//  XUER
//
//  Created by 韩占禀 on 15/8/21.
//  Copyright (c) 2015年 韩占禀. All rights reserved.
//

#import "AppDelegate.h"
#import "XRShareCenter.h"
#import "XRGoodCourseController.h"
#import "XRAllCourseController.h"
#import "XRMyCourseController.h"
#import "XRNetCenter.h"
#import "XXYNavigationController.h"
#import "RealReachability.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (UITabBarController *)tabBarController {
    return [(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarController];
}

+ (UIViewController *)rootViewController {
    return [[(AppDelegate *)[[UIApplication sharedApplication] delegate] window] rootViewController];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [GLobalRealReachability startNotifier]; //监测网络
    
    [XRShareCenter registerShareSDK];
    
    [[XRConfigs share] loadAllInfo];
    [XRFilePath createDirPath];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.backgroundColor = [UIColor colorWithWhite:0.957 alpha:1.000];
    
    self.window.rootViewController = [self tabbarController];
    
    [self.window makeKeyAndVisible];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_is_reg withParams:@{@"username":@"test_wangffangshuai5"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_userins withParams:@{@"username":@"test_wangffangshuai4",@"password":@"wangffangshuai",@"realname":@"haha",@"sex":@"1"} withImagePath:[[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil] withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_useredit withParams:@{@"id":@"965",@"username":@"test_wangffangshuai4",@"password":@"124",@"realname":@"564",@"sex":@"0"} withImagePath:[[NSBundle mainBundle] pathForResource:@"1.png" ofType:nil] withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_userlogin withParams:@{@"username":@"test_wangffangshuai4",@"password":@"124"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_typelist withParams:nil withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_courselist withParams:@{@"arrchildid":@"2,8,9,10,11"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
    //搜索
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_courselist withParams:@{@"arrchildid":@"2,8,9,10,11"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_courseinfo withParams:@{@"id":@"14"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_joincourse withParams:@{@"uid":@"753",@"courseid":@"24",@"isjoin":@"1"} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
//        
//    }];

//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_coursecommentadd withParams:@{@"uid":@"965",@"cid":@"14",@"star":@"3",@"content":@"好，很好，非常好"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];

//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_coursecomment withParams:@{@"uid":@"965",@"cid":@"14"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_checkupdate withParams:@{@"uid":@"965",@"myversion":@"1.0"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_joincourse_z withParams:@{@"uid":@"965",@"cid":@"14",@"zid":@"112",@"isjoin":@"1"} withImagePath:nil withCompletion:^(NSDictionary *responseObject, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_searchlist withParams:@{@"keyword":@"iOS",@"page":@"1",@"count":@"10"} withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
//        
//    }];
    
//    [[XRNetCenter share] sendRequestWithNetType:XRNetType_indexlist withParams:nil withImagePath:nil withCompletion:^(NSDictionary *responseData, int status, NSError *error) {
//        
//    }];

    return YES;
}

-(UITabBarController *)tabbarController {
#pragma mark - 步骤1：初始化视图控制器
    
    XRGoodCourseController *goodCourseC = [[XRGoodCourseController alloc] init]; //精品课程
    
    XRAllCourseController *allCourseC = [[XRAllCourseController alloc] init]; //全部课程
    
    //XRMyCourseController *myCourseC = [[XRMyCourseController alloc] init]; //我的课程
    XRMyCourseController *myCourseC = [[XRMyCourseController alloc] init]; //我的课程
    
#pragma mark - 步骤2：将视图控制器绑定到导航控制器上
    XXYNavigationController *nav1C = [[XXYNavigationController alloc] initWithRootViewController:goodCourseC];
    nav1C.navigationBarHidden = YES;
    
    XXYNavigationController *nav2C = [[XXYNavigationController alloc] initWithRootViewController:allCourseC];
    nav2C.navigationBarHidden = YES;
    
    XXYNavigationController *nav3C = [[XXYNavigationController alloc] initWithRootViewController:myCourseC];
    nav3C.navigationBarHidden = YES;
    
#pragma mark - 步骤3：将导航控制器绑定到TabBar控制器上
    _tabBarController = [[UITabBarController alloc] init];
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, 49)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [_tabBarController.tabBar insertSubview:barBgView atIndex:0];
    _tabBarController.tabBar.opaque = YES;
    
    _tabBarController.viewControllers = @[nav1C,nav2C,nav3C]; //需要先绑定viewControllers数据源
    _tabBarController.selectedIndex = 0; //默认选中第几个图标（此步操作在绑定viewControllers数据源之后）
    
    //初始化TabBar数据源
    NSArray *titles = @[@"首页",@"课程",@"我的"];
    NSArray *images = @[@"shouye",@"kecheng",@"wode"];
    NSArray *selectedImages = @[@"shouye_selected",@"kecheng_selected",@"wode_selected"];
    
    //绑定TabBar数据源
    for (int i = 0; i<_tabBarController.tabBar.items.count; i++) {
        UITabBarItem *item = (UITabBarItem *)_tabBarController.tabBar.items[i];
        item.title = titles[i];
        item.image = [[UIImage imageNamed:[images objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[selectedImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kUIColorFromRGB(0x7b7b7b),NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(66, 157, 150),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    }
    
#pragma mark - 步骤4：将TabBar控制器作为根视图控制器
    self.window.rootViewController = _tabBarController;
    
    return _tabBarController;
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    //CC视频集成------->
    // 停止 drmServer
    [self.drmServer stop];
    // 下载
    [self.downloadingItems writeToPlistFile:DWDownloadingItemPlistFilename];
    [self.downloadFinishItems writeToPlistFile:DWDownloadFinishItemPlistFilename];
    
    for (DWDownloadItem *item in self.downloadingItems.items) {
        if (item.downloader) {
            [item.downloader pause];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"loadDownloadItems" object:nil];
    //<-------CC视频集成
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //CC视频集成------->
    // 启动 drmServer
    self.drmServer = [[DWDrmServer alloc] initWithListenPort:20140];
    BOOL success = [self.drmServer start];
    if (!success) {
        logerror(@"drmServer 启动失败");
    }
    
    // 下载
    self.downloadingItems = [[DWDownloadItems alloc] initWithPath:DWDownloadingItemPlistFilename];
    self.downloadFinishItems = [[DWDownloadItems alloc] initWithPath:DWDownloadFinishItemPlistFilename];
    self.downloadingItems.isBusy = NO;
    
    for (DWDownloadItem *item in self.downloadingItems.items) {
        switch (item.videoDownloadStatus) {
            case DWDownloadStatusStart:
                item.videoDownloadStatus = DWDownloadStatusWait;
                break;
                
            case DWDownloadStatusDownloading:
                item.videoDownloadStatus = DWDownloadStatusWait;
                break;
                
            case DWDownloadStatusPause:
                item.videoDownloadStatus = DWDownloadStatusWait;
                break;
                
            default:
                break;
        }
    }
    //<-------CC视频集成
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
