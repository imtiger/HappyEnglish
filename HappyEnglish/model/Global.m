//
// Created by tiger on 13-5-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AudioToolbox/AudioToolbox.h>
#import "Global.h"


@implementation Global

+ (NSString *)formatDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)convertToDate:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATE_FORMAT];
    return [dateFormatter dateFromString:date];
}


+ (BOOL)fileExistAtAudioPath:(NSString *)fileName {
    return [[NSFileManager defaultManager] fileExistsAtPath:[AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName]];
}

+ (NSString *)fileFullPathOfAudioFile:(NSString *)fileName {
    return [AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName];
}

+ (NSString *)uuid {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString *) CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return uuidStr;
}

+ (void)createAudioDirIfNotExist {
    if (![[NSFileManager defaultManager] fileExistsAtPath:AUDIO_CACHE_FOLDER isDirectory:nil]) {
        BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:AUDIO_CACHE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
        if (!success) {
            //NSLog(@"download dir %@ create failure!", AUDIO_CACHE_FOLDER);
            return;
        }
    }
}

/*
 *播放提示音
 */
+ (void)playTipAudio:(NSURL *)audioFileUrl {
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) audioFileUrl, &soundId);
    AudioServicesPlaySystemSound(soundId);
}


+ (NSString *)repeatDays {
    NSString *repeatString = [[[GlobalAppConfig sharedInstance] valueForKey:knotificationRepeat] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (repeatString.length == 0) {
        return @"从不";
    }
    NSArray *repeatDays = [repeatString componentsSeparatedByString:@"|"];
    if (repeatDays.count == 7) {
        return @"每天";
    } else {
        NSMutableString *text = [NSMutableString string];
        for (int i = 1; i <= 7; i++) {
            if ([repeatDays containsObject:[NSString stringWithFormat:@"%d", i]]) {
                [text appendString:[self convert:i]];
                [text appendString:@" "];
            }
        }
        return text;
    }
}

+ (NSString *)convert:(int)weekdayNumber {
    switch (weekdayNumber) {
        case 1: {
            return @"星期一";
        }
        case 2: {
            return @"星期二";
        }
        case 3: {
            return @"星期三";
        }
        case 4: {
            return @"星期四";
        }
        case 5: {
            return @"星期五";
        }
        case 6: {
            return @"星期六";
        }
        case 7: {
            return @"星期日";
        }
        default:
            return @"";
    }
}

@end