//
//  XRFilePath.m
//  XUER
//
//  Created by 韩占禀 on 15/8/31.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import "XRFilePath.h"

@implementation XRFilePath

+(void)createDirPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:kIconPath])
    {
        [manager createDirectoryAtPath:kIconPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![manager fileExistsAtPath:kJsonPath])
    {
        [manager createDirectoryAtPath:kJsonPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![manager fileExistsAtPath:kCCVideoPath])
    {
        [manager createDirectoryAtPath:kCCVideoPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

+(NSString *)filePathWithType:(enum XRFilePathType)type withFileName:(NSString *)fileName
{
    NSString *filePath = nil;
    switch (type)
    {
        case XRFilePathType_IconPath:
        {
            filePath = [kIconPath stringByAppendingPathComponent:@"Icon_200_200.jpg"];
        }
            break;
        case XRFilePathType_TypeListJson:
        {
            filePath = [kJsonPath stringByAppendingPathComponent:@"typeList.json"];
        }
            break;
        case XRFilePathType_CCVideo:
        {
            filePath = [kCCVideoPath stringByAppendingFormat:@"/%@.pcm",fileName];
        }
            break;
        case XRFilePathType_CCVideoLengthString:
        {
            filePath = [kCCVideoPath stringByAppendingFormat:@"/%@.string",fileName];
        }
            break;
        default:
            break;
    }
    return filePath;
}

+(long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath])
    {
        return [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

+(NSString *)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:folderPath])
    {
        return @"0MB";
    }
    else
    {
        NSArray *childFiles = [fileManager subpathsAtPath:folderPath];
        long long folderSize = 0;
        for (NSString *fileName in childFiles)
        {
            NSString *filePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:filePath];
        }
        return [NSString stringWithFormat:@"%.0fMB",folderSize/1024.0/1024.0];
    }
}

@end
