//
//  FSVideoDownloadCenter.h
//  XUER
//
//  Created by 韩占禀 on 15/9/27.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FSProgressBlock)(float progress);
typedef void(^FSCompletionBlock)(NSError *error);

@interface FSVideoDownloadCenter : NSObject

+(FSVideoDownloadCenter *)share;

@property (nonatomic,strong) NSMutableDictionary    *videoDownloaderDic;

-(void)startDownloadWithVideoId:(NSString *)videoId withProgressBlock:(FSProgressBlock)progressBlock withCompletionBlock:(FSCompletionBlock)completionBlock;

-(BOOL)isVideoHasDownloadedWithVideoId:(NSString *)videoId;

-(void)pauseVideoDownloadWithVideoId:(NSString *)videoId;

-(void)resumeVideoDownloadWithVideoId:(NSString *)videoId;

@end
