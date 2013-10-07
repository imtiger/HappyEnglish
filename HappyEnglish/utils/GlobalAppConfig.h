//
// Created by @krq_tiger on 13-6-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define kwifiAutoDownload @"wifiAutoDownload"
#define kstartNumber @"startNumber"
#define kendNumber @"endNumber"
#define ksingleTipsDone @"singleTipsDone"
#define kmultiTipsDone @"multiTipsDone"
#define kskipIntroduction @"skipIntroduction"
#define kepisodeMode @"episodeMode"
#define kepisodePeriod @"episodePeriod"
#define ktextFontSize @"textFontSize"
#define knotificationOn @"notificationOn"
#define knotificationTime @"notificationTime"
#define knotificationRepeat @"notificationRepeat"
#define knotificationMusic @"notificationMusic"


@interface GlobalAppConfig : NSObject

+ (GlobalAppConfig *)sharedInstance;

- (id)valueForKey:(NSString *)key;

- (void)setValue:(id)value forKey:(NSString *)key;

- (UIFont *)getSourceLanguageFont:(CGFloat)fontSize;

- (UIFont *)getDestinationLanguageFont:(CGFloat)fontSize;
@end