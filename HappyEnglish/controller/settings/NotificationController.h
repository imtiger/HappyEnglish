//
// Created by @krq_tiger on 13-7-24.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SettingBaseChildController.h"


@interface NotificationController : SettingBaseChildController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, weak) UIDatePicker *datePicker;
@end