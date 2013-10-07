//
// Created by @krq_tiger on 13-8-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "OneDayInfo+SNSShareCategory.h"

#define SHARE_INFO @"\"美剧英语每日一句\"第%d期.%@ %@详解:%@ 慢速领读:%@ 正常语速领读:%@"


@implementation OneDayInfo (SNSShareCategory)

- (NSString *)shareInfo {
    NSString *detailUrl = [self.detailAudioUrl stringByReplacingOccurrencesOfString:@"audiofile.oss.aliyuncs.com" withString:@"happyenglish.webfing.com/audiofile"];
    NSString *slowUrl = [self.slowAudioUrl stringByReplacingOccurrencesOfString:@"audiofile.oss.aliyuncs.com" withString:@"happyenglish.webfing.com/audiofile"];
    NSString *normalUrl = [self.normalAudioUrl stringByReplacingOccurrencesOfString:@"audiofile.oss.aliyuncs.com" withString:@"happyenglish.webfing.com/audiofile"];
    return [NSString stringWithFormat:SHARE_INFO, self.issueNumber, self.chineseText, self.englishText, detailUrl, slowUrl, normalUrl];
}

@end