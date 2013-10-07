//
// Created by @krq_tiger on 13-6-20.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SettingBaseChildController.h"


@interface FontSettingController : SettingBaseChildController <UITableViewDelegate, UITableViewDataSource> {
    UITableView * _tableView;
}
@end