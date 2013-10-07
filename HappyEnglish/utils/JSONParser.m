//
// Created by @krq_tiger on 13-5-23.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "JSONParser.h"
#import "OneDayInfo.h"


@implementation JSONParser

+ (NSArray *)parseOneDayInfos:(NSData *)jsonData {
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        return nil;
    }
    NSMutableArray *data = [jsonObject objectForKey:@"data"];
    NSMutableArray *infos = [[NSMutableArray alloc] init];
    for (NSDictionary *info in data) {
        OneDayInfo *oneDayInfo = [[OneDayInfo alloc] initWithDirectory:info];
        [infos addObject:oneDayInfo];
    }
    return infos;

    /*NSMutableArray *infoOfWeek = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    OneDayInfo *info = [[OneDayInfo alloc] init];
    info.englishText = @"Okay, listen, Why don’t you try to relax, okay? Maybe have a  drink?";
    info.chineseText = @"试着放松点儿，要不咱们喝一杯怎么样？";
    info.mainImage = [UIImage imageNamed:@"main_img_icon.png"];
    NSString *REQUEST_DOMAIN = @"localhost";
    info.detailAudioUrl = [NSString stringWithFormat:@"http://%@/~tiger/audio/followmeapp020-explain.mp3", REQUEST_DOMAIN];
    info.normalAudioUrl = [NSString stringWithFormat:@"http://%@/~tiger/audio/followmeapp020-normal.mp3", REQUEST_DOMAIN];
    info.slowAudioUrl = [NSString stringWithFormat:@"http://%@/~tiger/audio/followmeapp020-slow.mp3", REQUEST_DOMAIN];
    info.createDate = [NSDate date];

    OneDayInfo *info1 = [[OneDayInfo alloc] init];
    info1.englishText = @"Max,do you take this man to be your husband!";
    info1.chineseText = @"Max,你愿意嫁给他吗？";
    info1.mainImage = [UIImage imageNamed:@"main_img_icon.png"];
    info1.detailAudioUrl = [NSString stringWithFormat:@"http://%@/~tiger/audio/1.mp3", REQUEST_DOMAIN];
    info1.normalAudioUrl = [NSString stringWithFormat:@"http://%@/~tiger/audio/2.mp3", REQUEST_DOMAIN];
    info1.slowAudioUrl = [NSString stringWithFormat:@"http://%@/~tiger/audio/3.mp3", REQUEST_DOMAIN];
    info1.createDate = [dateFormatter dateFromString:@"2013-05-20"];


    OneDayInfo *info2 = [[OneDayInfo alloc] init];
    info2.englishText = @"Well,look,It's hardly raining anymore!";
    info2.chineseText = @"瞧，外边的雪快停了。";
    info2.mainImage = [UIImage imageNamed:@"main_img_icon.png"];
    info2.detailAudioUrl = @"http://d.pcs.baidu.com/file/71d10e36f8d84fa7b0c1c63eb977c438?fid=1127580947-250528-949352179&time=1368523939&sign=FDTAR-DCb740ccc5511e5e8fedcff06b081203-PUNsP1IeWtkOizY2nvBX%2B3RLoJ8%3D&rt=sh&expires=8h&r=534159555&sh=1&response-cache-control=private";
    info2.normalAudioUrl = @"http://d.pcs.baidu.com/file/71d10e36f8d84fa7b0c1c63eb977c438?fid=1127580947-250528-949352179&time=1368523939&sign=FDTAR-DCb740ccc5511e5e8fedcff06b081203-PUNsP1IeWtkOizY2nvBX%2B3RLoJ8%3D&rt=sh&expires=8h&r=534159555&sh=1&response-cache-control=private";
    info2.slowAudioUrl = @"http://www.youku.com";
    info2.createDate = [dateFormatter dateFromString:@"2013-05-18"];

    OneDayInfo *info3 = [[OneDayInfo alloc] init];
    info3.englishText = @"Since when do you watch the news?";
    info3.chineseText = @"你什么时候开始看新闻了。";
    info3.mainImage = [UIImage imageNamed:@"main_img_icon.png"];
    info3.detailAudioUrl = @"http://d.pcs.baidu.com/file/71d10e36f8d84fa7b0c1c63eb977c438?fid=1127580947-250528-949352179&time=1368523939&sign=FDTAR-DCb740ccc5511e5e8fedcff06b081203-PUNsP1IeWtkOizY2nvBX%2B3RLoJ8%3D&rt=sh&expires=8h&r=534159555&sh=1&response-cache-control=private";
    info3.normalAudioUrl = @"http://d.pcs.baidu.com/file/71d10e36f8d84fa7b0c1c63eb977c438?fid=1127580947-250528-949352179&time=1368523939&sign=FDTAR-DCb740ccc5511e5e8fedcff06b081203-PUNsP1IeWtkOizY2nvBX%2B3RLoJ8%3D&rt=sh&expires=8h&r=534159555&sh=1&response-cache-control=private";
    info3.slowAudioUrl = @"http://www.youku.com";
    info3.createDate = [dateFormatter dateFromString:@"2013-05-11"];


    OneDayInfo *info4 = [[OneDayInfo alloc] init];
    info4.englishText = @"Well,the school lost it's power";
    info4.chineseText = @"学校停电了.";
    info4.mainImage = [UIImage imageNamed:@"main_img_icon.png"];
    info4.detailAudioUrl = @"http://d.pcs.baidu.com/file/71d10e36f8d84fa7b0c1c63eb977c438?fid=1127580947-250528-949352179&time=1368523939&sign=FDTAR-DCb740ccc5511e5e8fedcff06b081203-PUNsP1IeWtkOizY2nvBX%2B3RLoJ8%3D&rt=sh&expires=8h&r=534159555&sh=1&response-cache-control=private";
    info4.normalAudioUrl = @"http://d.pcs.baidu.com/file/71d10e36f8d84fa7b0c1c63eb977c438?fid=1127580947-250528-949352179&time=1368523939&sign=FDTAR-DCb740ccc5511e5e8fedcff06b081203-PUNsP1IeWtkOizY2nvBX%2B3RLoJ8%3D&rt=sh&expires=8h&r=534159555&sh=1&response-cache-control=private";
    info4.slowAudioUrl = @"http://www.youku.com";
    info4.createDate = [dateFormatter dateFromString:@"2013-04-28"];
    [infoOfWeek addObject:info];
    [infoOfWeek addObject:info1];
    [infoOfWeek addObject:info2];
    [infoOfWeek addObject:info3];
    [infoOfWeek addObject:info4];
    return infoOfWeek; */
}

+ (NSDictionary *)parseVersionInfo:(NSData *)versionData {
    NSError *error;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:versionData options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        return nil;
    }
    return jsonObject;
}

@end