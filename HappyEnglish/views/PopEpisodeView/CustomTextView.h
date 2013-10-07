//
// Created by @krq_tiger on 13-5-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol TranslateDelegate
- (void)translate;
@end

@interface CustomTextView : UITextView
@property(nonatomic, weak) id <TranslateDelegate> translateDelegate;
@end