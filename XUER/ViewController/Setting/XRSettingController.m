//
//  XRSettingController.m
//  XUER
//
//  Created by 韩占禀 on 15/10/4.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRSettingController.h"
#import "XRSettingCell.h"
#import "XRSettingSwitchCell.h"
#import "XRSettingDefaultCell.h"
#import "XRAbountController.h"
#import "XRFeedbackController.h"
#import <ShareSDK/ShareSDK.h>

@interface XRSettingController ()

@end

@implementation XRSettingController

-(void)viewLayout
{
    [_contentView setWidthToAutoresizeScreenWidth];
    [_contentView setHeightToAutoresizeScreenHeight];
    [_mainTableView setWidthToAutoresizeScreenWidth];
    [_mainTableView setHeightToAutoresizeScreenHeight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self viewLayout];
    [self addCustomNavagationBarWithTitle:@"设置" isNeedBackButton:YES];
    
    _personInfoView = [[[NSBundle mainBundle] loadNibNamed:@"XRPersonInfoView" owner:nil options:nil] firstObject];
    _mainTableView.tableHeaderView = _personInfoView;
    _personInfoView.superVC = self;
    
    _logoutView = [[[NSBundle mainBundle] loadNibNamed:@"XRLogoutView" owner:nil options:nil] firstObject];
    _logoutView.superVC = self;
    _mainTableView.tableFooterView = _logoutView;
    
    if (![XRConfigs share].username) //判断用户是否登录
    {
        _mainTableView.tableFooterView = nil;
    } else {
        _mainTableView.tableFooterView = _logoutView;
    }
    
    //@"视频下载清晰度",,@"允许使用2G/3G/4G网络下载视频" ,@"清除离线下载内容"
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdLogin"] isEqualToString:@"第三方登录"]) {
        _dataSourseArray = @[@[@"允许使用2G/3G/4G网络观看视频"],@[@"解除第三方账号绑定",@"意见反馈",@"给予星评",@"关于"],@[@"清除缓存"]];
    } else {
        _dataSourseArray = @[@[@"允许使用2G/3G/4G网络观看视频"],@[@"意见反馈",@"给予星评",@"关于"],@[@"清除缓存"]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucc:) name:kLoginSuccNotification object:nil]; //登录成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucc:) name:kLogoutSuccNotification object:nil]; //注销成功
}

-(void)loginSucc:(NSNotification *)noti
{
    _mainTableView.tableFooterView = _logoutView;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdLogin"] isEqualToString:@"第三方登录"]) {
        _dataSourseArray = @[@[@"允许使用2G/3G/4G网络观看视频"],@[@"解除第三方账号绑定",@"意见反馈",@"给予星评",@"关于"],@[@"清除缓存"]];
    } else {
        _dataSourseArray = @[@[@"允许使用2G/3G/4G网络观看视频"],@[@"意见反馈",@"给予星评",@"关于"],@[@"清除缓存"]];
    }
    [_mainTableView reloadData];
}

-(void)logoutSucc:(NSNotification *)noti
{
    _mainTableView.tableFooterView = nil;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdLogin"] isEqualToString:@"第三方登录"]) {
        _dataSourseArray = @[@[@"允许使用2G/3G/4G网络观看视频"],@[@"解除第三方账号绑定",@"意见反馈",@"给予星评",@"关于"],@[@"清除缓存"]];
    } else {
        _dataSourseArray = @[@[@"允许使用2G/3G/4G网络观看视频"],@[@"意见反馈",@"给予星评",@"关于"],@[@"清除缓存"]];
    }
    [_mainTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSourseArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = _dataSourseArray[section];
    return sectionArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        XRSettingSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRSettingSwitchCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRSettingSwitchCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *sectionArray = _dataSourseArray[indexPath.section];
        cell.titleLabel.text = sectionArray[indexPath.row];
        cell.isFirst = (indexPath.row == 0);
        if ([cell.titleLabel.text isEqualToString:@"视频下载清晰度"]) {
            cell.isSwitchHidden = YES;
            cell.isSegmentHidden = NO;
            NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kDownloadingDefinition];
            cell.segmentBtn.selectedSegmentIndex = setting.length>0?[setting integerValue]:0; //0:清晰 1:高清
        } else {
            cell.isSwitchHidden = NO;
            cell.isSegmentHidden = YES;
            if ([cell.titleLabel.text isEqualToString:@"允许使用2G/3G/4G网络观看视频"]) {
                cell.switchBtn.tag = 100;
                NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kWatchingByMobileNetwork];
                cell.switchBtn.on = setting.length>0?[setting integerValue]:0; //0:关闭 1:打开
            }
            if ([cell.titleLabel.text isEqualToString:@"允许使用2G/3G/4G网络下载视频"]) {
                cell.switchBtn.tag = 101;
                NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kDownloadingByMobileNetwork];
                cell.switchBtn.on = setting.length>0?[setting integerValue]:0; //0:关闭 1:打开
            }
        }
        return cell;
    }
    else if (indexPath.section == 1)
    {
        XRSettingDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRSettingDefaultCell" owner:nil options:nil] firstObject];
        }
        NSArray *sectionArray = _dataSourseArray[indexPath.section];
        cell.titleLabel.text = sectionArray[indexPath.row];
        cell.isFirst = (indexPath.row == 0);
        return cell;
    }
    else
    {
        XRSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XRSettingCell"];
        if (!cell)
        {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"XRSettingCell" owner:nil options:nil] firstObject];
        }
        NSArray *sectionArray = _dataSourseArray[indexPath.section];
        cell.titleLabel.text = sectionArray[indexPath.row];
        cell.isFirst = (indexPath.row == 0);
        if ([cell.titleLabel.text isEqualToString:@"清除缓存"])
        {
            NSString *size = [XRFilePath folderSizeAtPath:kCachePath];
            cell.sizeLabel.text = size;
        }
        if ([cell.titleLabel.text isEqualToString:@"清除离线下载内容"])
        {
            NSString *size = [XRFilePath folderSizeAtPath:kCCVideoPath];
            cell.sizeLabel.text = size;
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 20;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *sectionArray = _dataSourseArray[indexPath.section];
    NSString *title = sectionArray[indexPath.row];
    
    if ([title isEqualToString:@"解除第三方账号绑定"]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定解除", nil];
        sheet.tag = 3000;
        [sheet showInView:self.view];
    }
    else if ([title isEqualToString:@"意见反馈"])
    {
        XRFeedbackController *feedbackC = [[XRFeedbackController alloc] init];
        [self.navigationController pushViewController:feedbackC animated:YES];
    }
    else if ([title isEqualToString:@"给予星评"])
    {
        NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1087880755"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    else if ([title isEqualToString:@"关于"])
    {
        XRAbountController *aboutC = [[XRAbountController alloc] init];
        [self.navigationController pushViewController:aboutC animated:YES];
    }
    else if ([title isEqualToString:@"清除缓存"])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定清除缓存", nil];
        sheet.tag = 1000;
        [sheet showInView:self.view];
    }
    else if ([title isEqualToString:@"清除离线下载内容"])
    {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定清除离线下载内容", nil];
        sheet.tag = 2000;
        [sheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //清除缓存
    if (buttonIndex == actionSheet.firstOtherButtonIndex && actionSheet.tag == 1000)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSArray *files= [[NSFileManager defaultManager] subpathsAtPath:kCachePath];
            for (NSString *p in files) {
                NSError *error;
                NSString *path = [kCachePath stringByAppendingPathComponent:p];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"缓存清除完毕";
                [hud hide:YES afterDelay:1.2];
                
                [_mainTableView reloadData];
            });
        });
    }
    //清除离线下载内容
    if (buttonIndex == actionSheet.firstOtherButtonIndex && actionSheet.tag == 2000)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if ([[NSFileManager defaultManager] fileExistsAtPath:kCCVideoPath])
            {
                BOOL bo = [[NSFileManager defaultManager] removeItemAtPath:kCCVideoPath error:nil];
                
                if (bo)
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:kCCVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
                        hud.mode = MBProgressHUDModeText;
                        hud.labelText = @"缓存清除完毕";
                        [hud hide:YES afterDelay:1.2];
                        [_mainTableView reloadData];
                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"缓存清除完毕";
                    [hud hide:YES afterDelay:1.2];
                });
            }
        });
    }
    //解除第三方账号绑定
    if (buttonIndex == actionSheet.firstOtherButtonIndex && actionSheet.tag == 3000)
    {
        if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
        }
        if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiTimeline]) {
            [ShareSDK cancelAuthWithType:ShareTypeWeixiTimeline];
        }
        if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace]) {
            [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_contentView animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"解除成功";
        [hud hide:YES afterDelay:1.2];
        
        [[XRConfigs share] setUserDic:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ThirdLogin"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popToRoot:NO];
        });
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLogoutSuccNotification object:nil];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_personInfoView textFieldSetNoEdit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
