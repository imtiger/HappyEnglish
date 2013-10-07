//
// Created by @krq_tiger on 13-7-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PlayerState : NSObject

@property(nonatomic) NSTimeInterval currentTime;

@property(nonatomic) NSTimeInterval duration;

- (id)initWithCurrentTime:(NSTimeInterval)currentTime andDuration:(NSTimeInterval)duration;

@end