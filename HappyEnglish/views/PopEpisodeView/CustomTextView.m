//
// Created by @krq_tiger on 13-5-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CustomTextView.h"


@implementation CustomTextView

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.selectedRange.length <= 0)return NO;
    if (action == @selector(translateUsingWeb)) {
        return YES;
    }
    return NO;
}

- (void)translateUsingWeb {
    [self.translateDelegate translate];
}

@end