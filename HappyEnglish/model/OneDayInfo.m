//
// Created by tiger on 13-5-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "StringUtils.h"
#import "OneDayInfo.h"
#import "Global.h"


@implementation OneDayInfo {

}
@synthesize chineseText, englishText, detailAudioUrl, normalAudioUrl, slowAudioUrl;


- (id)initWithDirectory:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.id = [[dictionary objectForKey:@"id"] integerValue];
        self.chineseText = [dictionary objectForKey:@"chineseText"];
        self.englishText = [dictionary objectForKey:@"englishText"];
        self.detailAudioUrl = [dictionary objectForKey:@"explain"];
        self.normalAudioUrl = [dictionary objectForKey:@"normal"];
        self.slowAudioUrl = [dictionary objectForKey:@"slow"];
        self.issueNumber = [[dictionary objectForKey:@"issueNumber"] integerValue];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = DATE_FORMAT;
        self.createDate = [dateFormatter dateFromString:[dictionary objectForKey:@"createDate"]];
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![[other class] isEqual:[self class]])
        return NO;
    OneDayInfo *info = other;
    return self.issueNumber == info.issueNumber;
}

- (BOOL)hasAllOffline {
    NSString *detailFileName = [[StringUtils md5:self.detailAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
    NSString *normalFilename = [[StringUtils md5:self.normalAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
    NSString *slowFilename = [[StringUtils md5:self.slowAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
    BOOL detailAudioExist = [Global fileExistAtAudioPath:detailFileName];
    BOOL normalAudioExist = [Global fileExistAtAudioPath:normalFilename];
    BOOL slowAudioExist = [Global fileExistAtAudioPath:slowFilename];
    BOOL hasOffline = detailAudioExist && normalAudioExist && slowAudioExist;
    return hasOffline;
}

- (BOOL)hasOffline:(AudioType)audioType {
    switch (audioType) {
        case Detail: {
            NSString *detailFileName = [[StringUtils md5:self.detailAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
            return [Global fileExistAtAudioPath:detailFileName];
        }
        case Slow: {
            NSString *slowFilename = [[StringUtils md5:self.slowAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
            return [Global fileExistAtAudioPath:slowFilename];
        }
        case Normal: {
            NSString *normalFilename = [[StringUtils md5:self.normalAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
            return [Global fileExistAtAudioPath:normalFilename];

        }
        default:
            return NO;
    }
}


@end