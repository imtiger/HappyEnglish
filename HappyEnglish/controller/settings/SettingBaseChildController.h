//
// Created by @krq_tiger on 13-6-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SettingBaseChildController : UIViewController {
    NSString *_name;

}

@property(nonatomic, copy) void (^returnCallbackBlock)(void);

- (void)returnCallback;
@end