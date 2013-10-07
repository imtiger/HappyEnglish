//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HappyEnglishAPI.h"
#import "Word.h"
#import "GlobalAppConfig.h"


@implementation HappyEnglishAPI


+ (NumberRange)queryIssueNumberRange {
    int startNumber = [[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue];
    int endNumber = [[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
    if (startNumber > endNumber) {
        startNumber = endNumber;
        [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithInt:startNumber] forKey:kstartNumber];
    }
    return (NumberRange) {startNumber, endNumber};
}

+ (Word *)queryWord:(NSString *)text {
    return nil;
}

@end