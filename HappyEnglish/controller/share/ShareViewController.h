//
// Created by @krq_tiger on 13-8-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define WX_AppID @"your webchat app id"
#define kSinaWeiboAppKey @"your app key"
#define kSinaWeiboAppSecret @"your app secret"
#define kSinaWeiboAppRedirectURI @"http://open.imtiger.net"
#define kSinaWeiboAuthData @"sinaWeiboAuthData"
#define SINA_WEIBO_URL_OF_SCHEMA @"wbHappyEnglish"
#define NAV_BAR_HEIGHT 44
#define TOOL_BAR_HEIGHT 40


@protocol ShareStrategy;
@class OneDayInfo;

@interface ShareViewController : UIViewController <UITextViewDelegate> {
    UITextView *_shareInfoView;
    UIView *_toolbarView;
    UILabel *_tipsLabel;
}

@property(nonatomic, strong) OneDayInfo *episode;
@property(nonatomic) UIImage *backgroundImage;

- (void)share;

- (void)handleUrl:(NSNotification *)notification;
@end