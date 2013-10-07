//
// Created by @krq_tiger on 13-7-25.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SettingBaseChildController.h"


@interface NotificationRepeatController : SettingBaseChildController <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *repeatDays;
@end