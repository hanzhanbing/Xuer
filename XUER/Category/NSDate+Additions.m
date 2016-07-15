//
//  NSDate+Additions.m
//  maidoumi
//
//  Created by Chens on 14-8-4.
//  Copyright (c) 2014年 maidoumi. All rights reserved.
//

#import "NSDate+Additions.h"

#define kOneDayTime (24*60*60)

@implementation NSDate (Additions)

-(int)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];//日历
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    int year = (int)[components year];
    return year;
}

-(NSString *)birthdayDateToAge
{
    int age = [[NSDate date] getYear] - [self getYear];
    return [NSString stringWithFormat:@"%d",age];
}

-(NSString *)getStarSign
{
    //计算星座
    NSString *retStr=@"";
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM"];
    int i_month=0;
    NSString *theMonth = [dateFormat stringFromDate:self];
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]){
        i_month = [[theMonth substringFromIndex:1] intValue];
    }else{
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    int i_day=0;
    NSString *theDay = [dateFormat stringFromDate:self];
    if([[theDay substringToIndex:0] isEqualToString:@"0"]){
        i_day = [[theDay substringFromIndex:1] intValue];
    }else{
        i_day = [theDay intValue];
    }
    /*
     摩羯座 12月22日------1月19日
     水瓶座 1月20日-------2月18日
     双鱼座 2月19日-------3月20日
     白羊座 3月21日-------4月19日
     金牛座 4月20日-------5月20日
     双子座 5月21日-------6月21日
     巨蟹座 6月22日-------7月22日
     狮子座 7月23日-------8月22日
     处女座 8月23日-------9月22日
     天秤座 9月23日------10月23日
     天蝎座 10月24日-----11月21日
     射手座 11月22日-----12月21日
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}

+ (NSString *)stringForRecentDate:(NSDate *)recentDate
{   // 规则：
    // 0当天则只显示时间: NSDateFormatterShortStyle    下午4:52
    // 1昨天
    // 2星期 （只显示最近四天的）
    // 3超过的则显示 NSDateFormatterShortStyle 11-9-17
    
    //[d timeIntervalSinceNow];
    NSString *result = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // NSDateFormatterShortStyle    下午4:52
    // kCFDateFormatterMediumStyle  下午4:53:23
    // kCFDateFormatterLongStyle    格林尼治标准时间+0800下午4时55分03秒
    // kCFDateFormatterFullStyle    中国标准时间下午4时55分43秒
    //[dateFormatter setTimeStyle:kCFDateFormatterFullStyle];
    // NSDateFormatterShortStyle 11-9-17
    // NSDateFormatterMediumStyle 2012-06-17
    // NSDateFormatterLongStyle 2011年9月17日
    // NSDateFormatterFullStyle 2011年9月17日星期六
    //[dateFormatter setDateStyle:NSDateFormatterFullStyle];
    
    // 注意与语言不是一码事，指的是区域设置
    NSLocale *curLocale = [NSLocale currentLocale];
    [dateFormatter setLocale:curLocale];// 设置为当前区域
    
//    NSInteger days = [NSDate daysBetweenDate:recentDate andDate:[NSDate date]];
//    if (days >= 0 && days < 7) {
//        if (days == 0) {
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *comps  = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:recentDate];
//            NSInteger hour = [comps hour];
//            NSInteger min = [comps minute];
//            result = [NSString stringWithFormat:@"%02d:%02d",(int)hour,(int)min];
//        }
//        else if (days == 1) {
//            result = NSLocalizedString(@"昨天", nil);
//        }
//        else {
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *comps  = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:recentDate];
//            NSInteger week = [comps weekday];
//            NSInteger day = [comps day];
//            switch (week)
//            {
//                case 2:
//                {
//                    result = @"周一";
//                }
//                    break;
//                case 3:
//                {
//                    result = @"周二";
//                }
//                    break;
//                case 4:
//                {
//                    result = @"周三";
//                }
//                    break;
//                case 5:
//                {
//                    result = @"周四";
//                }
//                    break;
//                case 6:
//                {
//                    result = @"周五";
//                }
//                    break;
//                case 7:
//                {
//                    result = @"周六";
//                }
//                    break;
//                case 1:
//                {
//                    result = @"周日";
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
//            comps  = [calendar components:NSCalendarUnitWeekday|NSCalendarUnitDay fromDate:[NSDate date]];
//            NSInteger todayWeek = [comps weekday];
//            NSInteger today = [comps day];
//            if (todayWeek == 1)
//            {
//                todayWeek = 7;
//            }
//            else
//            {
//                todayWeek --;
//            }
//            
//            //距离上周日的天数
//            NSInteger beforeSundayDayCount = today - todayWeek;
//            
//            //如果是上周日时间戳之前的时间则添加前缀“上”
//            if ([recentDate timeIntervalSince1970] <= [[NSDate date] timeIntervalSince1970]-beforeSundayDayCount*kOneDayTime)
//            {
//                result = [NSString stringWithFormat:@"上%@",result];
//            }
//        }
//    } else
    {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        result = [dateFormatter stringFromDate:recentDate];
//        result = [NSDateFormatter localizedStringFromDate:recentDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    }
    return result;
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    if (fromDateTime == nil || toDateTime == nil)
    {
        return 0;
    }
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

@end
