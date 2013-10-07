//
//  NSDate+Helper.m
//  JZB
//
//  Created by Jin Jin on 11-4-15.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Helper.h"


@implementation NSDate (NSDate_Helper)

/*
 
 * This guy can be a little unreliable and produce unexpected results,
 
 * you’re better off using daysAgoAgainstMidnight
 
 */

//获取年月日如:19871127.

- (NSString *)getFormatYearMonthDay {

    NSString *string = [NSString stringWithFormat:@"%d%02d%02d", [self getYear], [self getMonth], [self getDay]];

    return string;

}

//返回当前月一共有几周(可能为4,5,6)

- (int)getWeekNumOfMonth {
    return [[self endOfMonth] getWeekOfYear] - [[self beginningOfMonth] getWeekOfYear] + 1;

}

//该日期是该年的第几周

- (int)getWeekOfYear {

    int i;

    int year = [self getYear];

    NSDate *date = [self endOfWeek];

    for (i = 1; [[date dateAfterDay:-7 * i] getYear] == year; i++) {

    }

    return i;

}

//返回day天后的日期(若day为负数,则为|day|天前的日期)

- (NSDate *)dateAfterDay:(int)day {

    NSCalendar *calendar = [self.class getCalendar];

    // Get the weekday component of the current date

    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];

    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];

    // to get the end of week for a particular date, add (7 – weekday) days

    [componentsToAdd setDay:day];

    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    [componentsToAdd release];

    return dateAfterDay;

}

//month个月后的日期

- (NSDate *)dateAfterMonth:(int)month {

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];

    [componentsToAdd setMonth:month];

    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    [componentsToAdd release];

    return dateAfterMonth;

}

//获取日

- (NSUInteger)getDay {

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];

    return [dayComponents day];

}

//获取月

- (NSUInteger)getMonth {

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];

    return [dayComponents month];

}

//获取年

- (NSUInteger)getYear {

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];

    return [dayComponents year];

}

//获取小时

- (int)getHour {

    NSCalendar *calendar = [self.class getCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *components = [calendar components:unitFlags fromDate:self];

    NSInteger hour = [components hour];

    return (int) hour;

}

//获取分钟

- (int)getMinute {

    NSCalendar *calendar = [self.class getCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *components = [calendar components:unitFlags fromDate:self];

    NSInteger minute = [components minute];

    return (int) minute;

}

- (int)getHour:(NSDate *)date {

    NSCalendar *calendar = [self.class getCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *components = [calendar components:unitFlags fromDate:date];

    NSInteger hour = [components hour];

    return (int) hour;

}

- (int)getMinute:(NSDate *)date {

    NSCalendar *calendar = [self.class getCalendar];

    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;

    NSDateComponents *components = [calendar components:unitFlags fromDate:date];

    NSInteger minute = [components minute];

    return (int) minute;

}

//在当前日期前几天

- (NSUInteger)daysAgo {

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)

                                               fromDate:self

                                                 toDate:[NSDate date]

                                                options:0];

    return [components day];

}

//午夜时间距今几天

- (NSUInteger)daysAgoAgainstMidnight {

    // get a midnight version of ourself:

    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];

    [mdf setDateFormat:@"yyyy-MM-dd"];

    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];

    [mdf release];

    return (int) [midnight timeIntervalSinceNow] / (60 * 60 * 24) * -1;

}

- (NSString *)stringDaysAgo {

    return [self stringDaysAgoAgainstMidnight:YES];

}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {

    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];

    NSString *text = nil;

    switch (daysAgo) {

        case 0:

            text = @"Today";

            break;

        case 1:

            text = @"Yesterday";

            break;

        default:

            text = [NSString stringWithFormat:@"%d days ago", daysAgo];

    }

    return text;

}

- (double)RFC822TimeInteral {

    NSCalendar *calendar = [self.class getCalendar];
    NSDateComponents *component = [[NSDateComponents alloc] init];
    [component setYear:-31];
    NSDate *date = [calendar dateByAddingComponents:component toDate:self options:0];
    [component release];

    return [date timeIntervalSince1970];
}

//返回一周的第几天(周末为第一天)

- (NSUInteger)weekday {

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];

    return [weekdayComponents weekday];

}

//转为NSString类型的

+ (NSDate *)dateFromString:(NSString *)string {

    return [NSDate dateFromString:string withFormat:[NSDate dbFormatString]];

}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format {

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];

    [inputFormatter setDateFormat:format];

    NSDate *date = [inputFormatter dateFromString:string];

    [inputFormatter release];

    return date;

}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {

    return [date stringWithFormat:format];

}

+ (NSString *)stringFromDate:(NSDate *)date {

    return [date string];

}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {

    /*
     
     * if the date is in today, display 12-hour time with meridian,
     
     * if it is within the last 7 days, display weekday name (Friday)
     
     * if within the calendar year, display as Jan 23
     
     * else display as Nov 11, 2008
     
     */

    NSDate *today = [NSDate date];

    NSCalendar *calendar = [self.class getCalendar];

    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)

                                                     fromDate:today];

    NSDate *midnight = [calendar dateFromComponents:offsetComponents];

    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];

    NSString *displayString = nil;

    // comparing against midnight

    if ([date compare:midnight] == NSOrderedDescending) {

        if (prefixed) {

            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am

        } else {

            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am

        }

    } else {

        // check if date is within last 7 days

        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];

        [componentsToSubtract setDay:-7];

        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];

        [componentsToSubtract release];

        if ([date compare:lastweek] == NSOrderedDescending) {

            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday

        } else {

            // check if same calendar year

            NSInteger thisYear = [offsetComponents year];

            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)

                                                           fromDate:date];

            NSInteger thatYear = [dateComponents year];

            if (thatYear >= thisYear) {

                [displayFormatter setDateFormat:@"MMM d"];

            } else {

                [displayFormatter setDateFormat:@"MMM d, yyyy"];

            }

        }

        if (prefixed) {

            NSString *dateFormat = [displayFormatter dateFormat];

            NSString *prefix = @"‘on’ ";

            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];

        }

    }

    // use display formatter to return formatted date string

    displayString = [displayFormatter stringFromDate:date];

    [displayFormatter release];

    return displayString;

}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {

    return [self stringForDisplayFromDate:date prefixed:NO];

}

- (NSString *)stringWithFormat:(NSString *)format {

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

    [outputFormatter setDateFormat:format];

    NSString *timestamp_str = [outputFormatter stringFromDate:self];

    [outputFormatter release];

    return timestamp_str;

}

- (NSString *)string {

    return [self stringWithFormat:[NSDate dbFormatString]];

}

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {

    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];

    [outputFormatter setDateStyle:dateStyle];

    [outputFormatter setTimeStyle:timeStyle];

    NSString *outputString = [outputFormatter stringFromDate:self];

    [outputFormatter release];

    return outputString;

}

//返回周日的的开始时间

- (NSDate *)beginningOfWeek {

    // largely borrowed from "Date and Time Programming Guide for Cocoa"

    // we’ll use the default calendar and hope for the best

    NSCalendar *calendar = [self.class getCalendar];

    NSDate *beginningOfWeek = nil;

    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek

                           interval:NULL forDate:self];

    if (ok) {

        return beginningOfWeek;

    }

    // couldn’t calc via range, so try to grab Sunday, assuming gregorian style

    // Get the weekday component of the current date

    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];

    /*
     
     Create a date components to represent the number of days to subtract from the current date.
     
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today’s Sunday, subtract 0 days.)
     
     */

    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];

    [componentsToSubtract setDay:0 - ([weekdayComponents weekday] - 1)];

    beginningOfWeek = nil;

    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];

    [componentsToSubtract release];

    //normalize to midnight, extract the year, month, and day components and create a new date from those components.

    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)

                                               fromDate:beginningOfWeek];

    return [calendar dateFromComponents:components];

}

//返回当前天的年月日.

- (NSDate *)beginningOfDay {

    NSCalendar *calendar = [self.class getCalendar];

    // Get the weekday component of the current date

    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)

                                               fromDate:self];

    return [calendar dateFromComponents:components];

}

+ (NSCalendar *)getCalendar {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//星期一作为本周第一天
    return calendar;
}

//返回该月的第一天

- (NSDate *)beginningOfMonth {
    return [[self dateAfterDay:-[self getDay] + 1] beginningOfDay];

}

//该月的最后一天

- (NSDate *)endOfMonth {

    return [[[[self beginningOfMonth] dateAfterMonth:1] dateAfterDay:-1] beginningOfDay];

}

//返回当前周的周末

- (NSDate *)endOfWeek {

    NSCalendar *calendar = [self.class getCalendar];

    // Get the weekday component of the current date

    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];

    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];

    // to get the end of week for a particular date, add (7 – weekday) days

    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];

    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd toDate:self options:0];

    [componentsToAdd release];

    return endOfWeek;

}

- (BOOL)beforeDate:(NSDate *)date {
    return [self timeIntervalSince1970] < [date timeIntervalSince1970];
}


+ (NSString *)dateFormatString {

    return @"yyyy-MM-dd";

}

+ (NSString *)timeFormatString {

    return @"HH:mm:ss";

}

+ (NSString *)timestampFormatString {

    return @"yyyy-MM-dd HH:mm:ss";

}

// preserving for compatibility

+ (NSString *)dbFormatString {

    return [NSDate timestampFormatString];

}


@end
