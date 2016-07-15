//
//  NSDate+Additions.h
//  maidoumi
//
//  Created by Chens on 14-8-4.
//  Copyright (c) 2014年 maidoumi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSDate (Additions)

-(int)getYear;

//根据出生日期得到年龄
-(NSString *)birthdayDateToAge;

//得到星座
-(NSString *)getStarSign;

//根据日期得到string展示
+ (NSString *)stringForRecentDate:(NSDate *)recentDate;

@end
