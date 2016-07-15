//
//  FSVideoDownloadCenter.m
//  XUER
//
//  Created by 韩占禀 on 15/9/27.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "FSVideoDownloadCenter.h"

static FSVideoDownloadCenter    *_center = nil;

@implementation FSVideoDownloadCenter

+(FSVideoDownloadCenter *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _center = [[FSVideoDownloadCenter alloc] init];
    });
    return _center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _videoDownloaderDic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)startDownloadWithVideoId:(NSString *)videoId withProgressBlock:(FSProgressBlock)progressBlock withCompletionBlock:(FSCompletionBlock)completionBlock
{
    if (videoId)
    {
        NSString *videoPath = [XRFilePath filePathWithType:XRFilePathType_CCVideo withFileName:videoId];
        DWDownloader *downloader = [[DWDownloader alloc] initWithUserId:DWACCOUNT_USERID andVideoId:videoId key:DWACCOUNT_APIKEY destinationPath:videoPath];
        downloader.timeoutSeconds = 20;
        _videoDownloaderDic[videoId] = downloader;
        
        __weak DWDownloader *weakDownloader = downloader;
        downloader.progressBlock = ^(float progress, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite)
        {
            NSLog(@"视频下载进度%f",progress);
            NSString *videoLengthPath = [XRFilePath filePathWithType:XRFilePathType_CCVideoLengthString withFileName:videoId];
            NSString *videoLength = [NSString stringWithFormat:@"%ld",weakDownloader.remoteFileSize];
            [videoLength writeToFile:videoLengthPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            progressBlock(progress);
            [[NSNotificationCenter defaultCenter] postNotificationName:kProgressUpdateNotification object:videoId userInfo:@{kProgress:@(progress)}];
        };
        
        downloader.finishBlock = ^()
        {
            NSLog(@"下载完成");
            completionBlock(nil);
            _videoDownloaderDic[videoId] = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kVideoDownloadFinishNotification object:videoId];
        };
        
        downloader.failBlock = ^(NSError *error)
        {
            NSLog(@"下载失败,%@",error);
            completionBlock(error);
            [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
            _videoDownloaderDic[videoId] = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:kVideoDownloadFinishNotification object:videoId userInfo:@{kError:error}];
        };
        [downloader start];
    }
}

-(BOOL)isVideoHasDownloadedWithVideoId:(NSString *)videoId
{
    //视频文件长度
    NSString *videoLengthPath = [XRFilePath filePathWithType:XRFilePathType_CCVideoLengthString withFileName:videoId];
    NSString *videoLength = [NSString stringWithContentsOfFile:videoLengthPath encoding:NSUTF8StringEncoding error:nil];
    
    //视频文件存在并且长度跟上边的一样则返回YES
    NSString *videoPath = [XRFilePath filePathWithType:XRFilePathType_CCVideo withFileName:videoId];
    long long fileSize = [XRFilePath fileSizeAtPath:videoPath];
    if (fileSize == videoLength.longLongValue && [[NSFileManager defaultManager] fileExistsAtPath:videoPath])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)pauseVideoDownloadWithVideoId:(NSString *)videoId
{
    DWDownloader *downloader = _videoDownloaderDic[videoId];
    [downloader pause];
}

-(void)resumeVideoDownloadWithVideoId:(NSString *)videoId
{
    DWDownloader *downloader = _videoDownloaderDic[videoId];
    [downloader resume];
}

@end
