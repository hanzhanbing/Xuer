//
//  XRDirectoryInfo.h
//  XUER
//
//  Created by 韩占禀 on 15/9/9.
//  Copyright (c) 2015年 a. All rights reserved.
//


@interface XRDirectoryInfo : XRInfo

@property (nonatomic,strong) NSString   *sectionID;
@property (nonatomic,strong) NSString   *title;
@property (nonatomic,strong) NSString   *updatetime;
@property (nonatomic,strong) NSString   *mv_url;
@property (nonatomic,strong) NSString   *videoId;
@property (nonatomic,strong) NSString   *kc_hours;
@property (nonatomic,strong) NSString   *isstudied;
@property (nonatomic,assign) float      progress;

@end
