//
// Created by @krq_tiger on 13-6-21.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface WordPanel : UIView {
    UILabel *_sourceLabel;
    UILabel *_meanLabel;
}

@property(nonatomic) NSString *source;
@property(nonatomic) NSString *meaning;
@property(nonatomic) CGRect selectRect;

- (void)reLayout;

@end