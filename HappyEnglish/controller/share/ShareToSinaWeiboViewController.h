//
// Created by @krq_tiger on 13-8-8.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ShareViewController.h"
#import "SinaWeibo.h"

@class MTStatusBarOverlay;
#define API_statuses_update                 @"statuses/update.json"
#define HTTP_METHOD_POST @"POST"


@interface ShareToSinaWeiboViewController : ShareViewController <SinaWeiboDelegate>


- (id)initWithEpisode:(OneDayInfo *)episode  title:(NSString *)title;
@end