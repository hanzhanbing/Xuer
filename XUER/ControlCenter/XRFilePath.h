//
//  XRFilePath.h
//  XUER
//
//  Created by 韩占禀 on 15/8/31.
//  Copyright (c) 2015年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTempPath NSTemporaryDirectory()
#define kDocmentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

#define kIconPath [kTempPath stringByAppendingPathComponent:@"Image"]
#define kJsonPath [kDocmentPath stringByAppendingPathComponent:@"Json"]
#define kCCVideoPath [kDocmentPath stringByAppendingPathComponent:@"Video"]

enum XRFilePathType
{
    XRFilePathType_IconPath,
    XRFilePathType_TypeListJson,
    XRFilePathType_CCVideo,
    XRFilePathType_CCVideoLengthString,
};

@interface XRFilePath : NSObject

+(void)createDirPath;

+(NSString *)filePathWithType:(enum XRFilePathType)type withFileName:(NSString *)fileName;

+(long long)fileSizeAtPath:(NSString *)filePath;

+(NSString *)folderSizeAtPath:(NSString *)folderPath;

@end
