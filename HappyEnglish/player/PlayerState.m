//
// Created by @krq_tiger on 13-7-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PlayerState.h"


@implementation PlayerState

- (id)initWithCurrentTime:(NSTimeInterval)currentTime andDuration:(NSTimeInterval)duration {
    self = [super init];
    if (self) {
        _currentTime = currentTime;
        _duration = duration;
    }
    return self;
}

@end