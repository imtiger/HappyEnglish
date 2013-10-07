//
// Created by @krq_tiger on 13-6-8.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#define NUMBER_PICKER_VIEW_HEIGHT 192
#define SETTING_VIEW_BORDER 8
#import <Foundation/Foundation.h>


@class MultiPlayerSettingViewController;

@protocol MultiPlayerSettingViewDelegate <NSObject, UITableViewDelegate, UITableViewDataSource>
- (BOOL)settingChanged;
@end

@interface MultiPlayerSettingView : UIView

@property(nonatomic, weak, readonly) id <MultiPlayerSettingViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id <MultiPlayerSettingViewDelegate>)delegate;

- (void)showOrHiddenNumberPicker;

- (void)hiddenNumberPicker;
@end