//
//  XRDirectoryCell.m
//  XUER
//
//  Created by 韩占禀 on 15/9/8.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRDirectoryCell.h"
#import "XRCourseInfoController.h"
#import "XRLoginController.h"

@implementation XRDirectoryCell

- (void)awakeFromNib {
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downloadViewClick:)];
    [_downloadView addGestureRecognizer:tap];
    _downloadGreenView.clipsToBounds = YES;
    
    _downloadView.x = kScreenWidth - _downloadView.width;
    _videoSizeLabel.x = _downloadView.x - _videoSizeLabel.width + 5;
}

-(void)videoDownloadFinishNoti:(NSNotification *)noti
{
    NSError *error = noti.userInfo[kError];
    [self downloadFinishWithError:error];
}

-(void)progressUpdateNoti:(NSNotification *)noti
{
    float progress = [noti.userInfo[kProgress] floatValue];
    NSLog(@"%f",progress);
    _directoryInfo.progress = progress;
    [self updateProgress];
}

-(void)setDirectoryInfo:(XRDirectoryInfo *)directoryInfo
{
    if (_directoryInfo != directoryInfo)
    {
        _directoryInfo = directoryInfo;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc removeObserver:self];
        [nc addObserver:self selector:@selector(videoDownloadFinishNoti:) name:kVideoDownloadFinishNotification object:directoryInfo.videoId];
        [nc addObserver:self selector:@selector(progressUpdateNoti:) name:kProgressUpdateNotification object:directoryInfo.videoId];
        _titleLabel.text = [_directoryInfo.title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    [self updateProgress];
    if (_directoryInfo.mv_url.length>0) {
        _coursePlay.hidden = NO;
    } else {
        _coursePlay.hidden = YES;
        _titleLabel.frame = CGRectMake(15, CGRectGetHeight(self.frame)/2-10.5, kScreenWidth-50, 21);
        _titleLabel.textColor = [UIColor colorWithRed:0.2118 green:0.5569 blue:0.5137 alpha:1.0];
    }
    _videoSizeLabel.hidden = NO;
    _videoSizeLabel.frame = CGRectMake(kScreenWidth-120, (CGRectGetHeight(self.frame)-21)/2, 100, 21);
    _videoSizeLabel.text = self.directoryInfo.kc_hours;
}

-(void)updateProgress
{
    if ([[FSVideoDownloadCenter share] isVideoHasDownloadedWithVideoId:_directoryInfo.videoId])
    {
        _downloadGreenView.hidden = YES;
        _downloadGrayImageView.image = [UIImage imageNamed:@"trashGray.png"];
        _videoSizeLabel.hidden = NO;
        _progressLabel.hidden = YES;
        
        NSString *videoPath = [XRFilePath filePathWithType:XRFilePathType_CCVideo withFileName:_directoryInfo.videoId];
        long long size = [XRFilePath fileSizeAtPath:videoPath];
        _videoSizeLabel.text = [NSString stringWithFormat:@"%.0fMB",size/1024.0/1024.0];
    }
    else
    {
        _downloadGreenView.hidden = NO;
        _videoSizeLabel.hidden = YES;
        _downloadGrayImageView.image = [UIImage imageNamed:@"download_gray.png"];
        _downloadGreenView.height = _downloadGrayImageView.height * _directoryInfo.progress;
        if (_directoryInfo.progress != 0)
        {
            _progressLabel.text = [NSString stringWithFormat:@"%.1f%%",_directoryInfo.progress*100];
            _progressLabel.hidden = NO;
        }
        else
        {
            _progressLabel.hidden = YES;
        }
        
    }
}

-(void)downloadViewClick:(id)sender
{
//    if (![XRConfigs share].username) //判断用户是否登录
//    {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，您还没有登录哦！快快去登录吧！" delegate:self cancelButtonTitle:@"下一次吧" otherButtonTitles:@"去登录", nil];
//        [alert show];
//    } else {
        if ([[FSVideoDownloadCenter share] isVideoHasDownloadedWithVideoId:_directoryInfo.videoId])
        {
            //已经下载，点击删除
            [_superVC deleteVideoWithVideoId:_directoryInfo.videoId];
        }
        else
        {
            NSString *setting = [[NSUserDefaults standardUserDefaults] objectForKey:kDownloadingByMobileNetwork];
            NSInteger status = setting.length>0?[setting integerValue]:0; //0:关闭 1:打开
            if (status == 0 && [XRConfigs getNetWorkStatus:NO]==NO) {
                [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请在wifi环境下下载视频" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil , nil] show];
            } else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_superVC.view animated:YES];
                hud.labelText = @"下载开始";
                hud.mode = MBProgressHUDModeText;
                [hud hide:NO afterDelay:1];
                
                //未下载，点击下载
                [[FSVideoDownloadCenter share] startDownloadWithVideoId:_directoryInfo.videoId withProgressBlock:^(float progress) {
                    NSLog(@"%f",progress);
                    _directoryInfo.progress = progress;
                    [self updateProgress];
                } withCompletionBlock:^(NSError *error) {
                    [self downloadFinishWithError:error];
                }];
            }
        }
//    }
}

#pragma mark - UIAlertViewDelegate协议
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        XRLoginController *loginC = [[XRLoginController alloc] init];
        UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginC];
        navC.navigationBarHidden = YES;
        [self.superVC presentViewController:navC animated:NO completion:nil];
    }
}

-(void)downloadFinishWithError:(NSError *)error
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:_superVC.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    [hud hide:NO afterDelay:1];
    if (!error)
    {
        _directoryInfo.progress = 1;
        [self updateProgress];
        hud.labelText = @"下载完成";
    }
    else
    {
        _directoryInfo.progress = 0;
        [self updateProgress];
        hud.labelText = @"下载失败,请重试";
    }
    [hud hide:NO afterDelay:1];
}

@end
