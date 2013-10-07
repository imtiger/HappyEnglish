//
// Created by @krq_tiger on 13-5-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "HttpClient.h"

@class Word;


@interface WordAudioPronounceController : NSObject <HttpClientDelegate, AVAudioPlayerDelegate>

- (void)doPronounce:(Word *)word;

- (void)cancel;
@end