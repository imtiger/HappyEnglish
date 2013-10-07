//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Word;

typedef struct {
    int startNumber;
    int endNumber;

} NumberRange;

@interface HappyEnglishAPI : NSObject

+ (NumberRange)queryIssueNumberRange;


+ (Word *)queryWord:(NSString *)text;
@end