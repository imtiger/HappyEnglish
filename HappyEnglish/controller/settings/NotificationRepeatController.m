//
// Created by @krq_tiger on 13-7-25.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NotificationRepeatController.h"
#import "Global.h"


@implementation NotificationRepeatController {

}


- (id)init {
    self = [super init];
    if (self) {
        NSString *repeatDays = [[GlobalAppConfig sharedInstance] valueForKey:knotificationRepeat];
        repeatDays = [repeatDays stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.repeatDays = repeatDays.length == 0 ? [NSMutableArray array] : [[repeatDays componentsSeparatedByString:@"|"] mutableCopy];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.backgroundView = nil;
    [self.view addSubview:tableView];
}



#pragma mark - TableView DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentify = @"repeateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.showsReorderControl = NO;
        cell.textLabel.font = CHINESE_TEXT_FONT;
    }
    cell.accessoryType = [self.repeatDays containsObject:[NSString stringWithFormat:@"%d", indexPath.row + 1]] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    switch (indexPath.row) {
        case 0: {
            cell.textLabel.text = @"星期一";
        }
            break;

        case 1: {
            cell.textLabel.text = @"星期二";
        }
            break;
        case 2: {
            cell.textLabel.text = @"星期三";
        }
            break;
        case 3: {
            cell.textLabel.text = @"星期四";
        }
            break;
        case 4: {
            cell.textLabel.text = @"星期五";
        }
            break;
        case 5: {
            cell.textLabel.text = @"星期六";
        }
            break;
        case 6: {
            cell.textLabel.text = @"星期日";
        }
            break;

    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark  - UITableView delegate - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *index = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    if ([self.repeatDays containsObject:index]) {
        [self.repeatDays removeObject:index];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        [self.repeatDays addObject:index];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }

}

- (void)returnCallback {
    [super returnCallback];
    [[GlobalAppConfig sharedInstance] setValue:[self.repeatDays componentsJoinedByString:@"|"] forKey:knotificationRepeat];
}

- (void)dealloc {
    self.repeatDays = nil;
}

@end