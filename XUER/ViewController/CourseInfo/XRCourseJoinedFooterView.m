//
//  XRCourseJoinedFooterView.m
//  XUER
//
//  Created by 韩占禀 on 15/10/2.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRCourseJoinedFooterView.h"
#import "DWCustomPlayerViewController.h"
#import "XRCourseInfoController.h"

@implementation XRCourseJoinedFooterView

-(void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playCurrentCourseVideo)];
    [self addGestureRecognizer:tap];
}

-(void)playCurrentCourseVideo
{
    NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kWatchingByMobileNetwork];
    NSInteger status = setting.length>0?[setting integerValue]:0; //0:关闭 1:打开
    if (status == 0 && [XRConfigs isMobileNetwork]==YES) {
        [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在wifi环境下观看视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil] show];
    } else {
        DWCustomPlayerViewController *player = [[DWCustomPlayerViewController alloc] init];
        player.videoId = _directoryInfo.videoId;
        player.videoTitle = _directoryInfo.title;
        player.courseInfo = _superVC.courseInfo;
        player.dirInfo = _directoryInfo;
        player.hidesBottomBarWhenPushed = YES;
        [_superVC.navigationController pushViewController:player animated:NO];
    }
}

-(void)setDirectoryInfo:(XRDirectoryInfo *)directoryInfo
{
    if (_directoryInfo != directoryInfo)
    {
        _directoryInfo = directoryInfo;
        
        _courseTitleLabel.text = directoryInfo.title;
        
    }
}

@end
