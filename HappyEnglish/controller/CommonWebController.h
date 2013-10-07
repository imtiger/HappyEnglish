//
// Created by @krq_tiger on 13-6-20.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "SettingBaseChildController.h"


@interface CommonWebController : SettingBaseChildController <UIWebViewDelegate, UIGestureRecognizerDelegate, HttpClientDelegate, UIActionSheetDelegate> {
    UIWebView *_webView;
    NSString *_requestUrl;

}


- (id)initWithRequestUrl:(NSString *)requestUrl name:(NSString *)name;

- (id)initWithRequestUrl:(NSString *)requestUrl name:(NSString *)name hasToolbar:(BOOL)hasToolBar;


@end