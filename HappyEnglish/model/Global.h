//
// Created by @krq_tiger on 13-5-9.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <Foundation/Foundation.h>
#import "GlobalAppConfig.h"

#define AUDIO_CACHE_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/audio"]
#define WORD_AUDIO_CACHE_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/word"]
#define REMOTE_FILE_CACHE_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/remotefile"]
#define AUDIO_SUFFIX @".mp3"
#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define REQUEST_URL @"http://open.imtiger.net/englishList"
#define DATE_FORMAT @"yyyy-MM-dd"
#define PAGE_LIMIT 10
#define LOADMORE_PAGE_LIMIT 50
#define MARGIN 5
#define SOURCE_LANGUAGE_FONT_NAME @"HelveticaNeue-Light"
#define DESTINATION_LANGUAGE_FONT_NAME @"Courier New"
#define FONT_SIZE  [[[GlobalAppConfig sharedInstance] valueForKey:ktextFontSize] floatValue]
#define ENGLISH_TEXT_FONT DESTINATION_LANGUAGE_FONT(14)//[UIFont fontWithName:@"Courier New" size:14]
#define CHINESE_TEXT_FONT SOURCE_LANGUAGE_FONT(14)//[UIFont fontWithName:FONT_NAME size:14]
#define ENGLISH_TEXT__SETTING_FONT DESTINATION_LANGUAGE_FONT(FONT_SIZE)//[UIFont fontWithName:@"Courier New" size:FONT_SIZE]
#define CHINESE_TEXT__SETTING_FONT SOURCE_LANGUAGE_FONT(FONT_SIZE)// [UIFont fontWithName:FONT_NAME size:FONT_SIZE]
#define CHINESE_TITLE_FONT SOURCE_LANGUAGE_FONT(18)//[UIFont fontWithName:FONT_NAME size:18]
#define DATE_TEXT_FONT SOURCE_LANGUAGE_FONT(10)//[UIFont fontWithName:@"Courier New" size:10]
#define TIPS_TEXT_FONT SOURCE_LANGUAGE_FONT(12)//[UIFont fontWithName:FONT_NAME size:12]
#define ABOUT_ME_URL @"http://happyenglish.oss.aliyuncs.com/aboutme.html"
#define VERSION_CHECK @"http://open.imtiger.net/version"
#define ABOUT_TEACHER_URL @"http://happyenglish.oss.aliyuncs.com/aboutteacher.html"
#define FEATURES_URL @"http://happyenglish.oss.aliyuncs.com/features.html"
#define HELP_URL @"http://happyenglish.oss.aliyuncs.com/help.html"
#define DICTIONARY_PAGE  @"http://3g.dict.cn/s.php?q="
#define TEXT_FONT_SETTING_CHANGED @"textFontSettingChanged"
#define POP_VIEW_DID_SHOW @"popViewDidShow"
#define POP_VIEW_DID_HIDDEN @"popViewDidHidden"
#define DO_FAVORITE_KEY @"DO_FAVORITE"
#define DO_SHARE_KEY @"DO_SHARE"
#define DO_TRANSLATE_KEY @"DO_TRANSLATE"
#define NOTIFICATION_FOR_HANDLE_URL @"notification_for_handle_url"
#define SOURCE_LANGUAGE_FONT(fontSize) [[GlobalAppConfig sharedInstance] getSourceLanguageFont:fontSize]
#define DESTINATION_LANGUAGE_FONT(fontSize) [[GlobalAppConfig sharedInstance] getDestinationLanguageFont:fontSize]
#define APP_ID 669934718
#define knotificationInfo @"notificationId"


@interface Global : NSObject

+ (NSString *)formatDate:(NSDate *)date;

+ (NSDate *)convertToDate:(NSString *)date;

+ (BOOL)fileExistAtAudioPath:(NSString *)fileName;

+ (NSString *)fileFullPathOfAudioFile:(NSString *)fileName;

+ (void)createAudioDirIfNotExist;

+ (NSString *)uuid;

+ (void)playTipAudio:(NSURL *)audioFileUrl;

+ (NSString *)repeatDays;

@end