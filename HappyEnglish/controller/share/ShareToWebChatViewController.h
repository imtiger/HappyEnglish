//
// Created by @krq_tiger on 13-8-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ShareViewController.h"
#import "WXApi.h"

@class OneDayInfo;


@interface ShareToWebChatViewController : ShareViewController <WXApiDelegate>

@property(nonatomic, assign) enum WXScene scene;

- (id)initWithEpisode:(OneDayInfo *)episode scene:(enum WXScene)scene title:(NSString *)title;
@end