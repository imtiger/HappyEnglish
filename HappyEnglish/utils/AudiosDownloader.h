//
// Created by @krq_tiger on 13-6-29.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Downloader.h"


@interface AudiosDownloader : NSObject <DownloaderDelegate>

- (void)start:(NSArray *)episodes;

- (void)cancel;

+ (AudiosDownloader *)sharedInstance;
@end