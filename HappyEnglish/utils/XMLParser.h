//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Word;


@interface XMLParser : NSObject

+ (Word *)parseWord:(NSData *)data;
@end