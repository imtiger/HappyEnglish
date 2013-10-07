//
// Created by @krq_tiger on 13-7-24.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NotificationController.h"
#import "GlobalAppConfig.h"
#import "Global.h"
#import "NotificationRepeatController.h"
#import "NSDate+Helper.h"
#import "NotificationSoundController.h"

@implementation NotificationController {
@private
    BOOL _shouldReSchedule;
}


- (void)loadView {
    [super loadView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200) style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.backgroundView = nil;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.view.backgroundColor = [UIColor whiteColor];

    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 216 - 44, self.view.frame.size.width, 216)];
    datePicker.datePickerMode = UIDatePickerModeTime;
    NSCalendar *calendar = [NSDate getCalendar];
    //datePicker.calendar = calendar;
    NSDate *now = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                   fromDate:now];
    NSDate *notificationTime = [[GlobalAppConfig sharedInstance] valueForKey:knotificationTime];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:notificationTime ? notificationTime : now];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    // Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    datePicker.date = ([calendar dateFromComponents:dateComps]);
    self.datePicker = datePicker;
    [self.view addSubview:datePicker];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _shouldReSchedule = NO;
    NSIndexPath *selectedIndex = [_tableView indexPathForSelectedRow];
    [_tableView deselectRowAtIndexPath:selectedIndex animated:YES];
    [_tableView reloadData];
}


- (IBAction)switchValueChanged:(id)sender {
    UISwitch *switcher = sender;
    [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:switcher.on] forKey:knotificationOn];
    if (!switcher.on) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)returnCallback {
    [super returnCallback];
    if (![[[GlobalAppConfig sharedInstance] valueForKey:knotificationOn] boolValue] && !_shouldReSchedule) {
        return;
    }

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    // Get the current date

/*    // Break the date up into components
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                   fromDate:pickerDate];
    NSDateComponents *timeComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit)
                                                   fromDate:pickerDate];
    // Set up the fire time
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setDay:[dateComponents day]];
    [dateComps setMonth:[dateComponents month]];
    [dateComps setYear:[dateComponents year]];
    [dateComps setHour:[timeComponents hour]];
    // Notification will fire in one minute
    [dateComps setMinute:[timeComponents minute]];
    [dateComps setSecond:[timeComponents second]];
    NSDate *itemDate = [calendar dateFromComponents:dateComps];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:pickerDate];*/
    NSDate *pickerDate = [self.datePicker date];
    [[GlobalAppConfig sharedInstance] setValue:pickerDate forKey:knotificationTime];
    NSUInteger weekday = [pickerDate weekday];
    weekday = weekday == 1 ? 7 : weekday - 1;
    NSDate *now = [NSDate date];
    NSString *repeatTime = [[[GlobalAppConfig sharedInstance] valueForKey:knotificationRepeat] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *repeatDays = (repeatTime && ![repeatTime isEqualToString:@""]) ? [repeatTime componentsSeparatedByString:@"|"] : nil;
    NSString *musicName = UILocalNotificationDefaultSoundName;//[[GlobalAppConfig sharedInstance] valueForKey:knotificationMusic];
    //musicName = [musicName isEqualToString:DEFAULT_NOTIFI_MUSIC] ? UILocalNotificationDefaultSoundName : [musicName stringByAppendingString:@".wav"];
    if (repeatDays == nil || repeatDays.count == 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSLog(@"=======not repeat%@", [dateFormatter stringFromDate:pickerDate]);
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = pickerDate;
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        // Notification details
        localNotif.alertBody = @"学英语其实不难，每天坚持一句就够啦!";
        // Set the action button
        localNotif.alertAction = @"查看";
        localNotif.soundName = musicName;
        localNotif.applicationIconBadgeNumber = 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    } else {
        for (NSString *day in repeatDays) {
            NSDate *fireDate;
            NSInteger repeatWeekday = [day integerValue];
            if (weekday == repeatWeekday) {
                if ([now beforeDate:pickerDate]) {
                    fireDate = pickerDate;
                } else {
                    fireDate = [pickerDate dateAfterDay:7];//当天时间已经过去，设置下周的同一时间
                }
            }
            if (weekday < repeatWeekday) {
                fireDate = [pickerDate dateAfterDay:repeatWeekday - weekday];
            }
            if (weekday > repeatWeekday) {
                fireDate = [pickerDate dateAfterDay:7 - (weekday - repeatWeekday)];
            }
            if (fireDate) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSLog(@"=======%@", [dateFormatter stringFromDate:fireDate]);
                UILocalNotification *localNotif = [[UILocalNotification alloc] init];
                localNotif.fireDate = fireDate;
                localNotif.timeZone = [NSTimeZone defaultTimeZone];
                // Notification details
                localNotif.alertBody = @"学英语其实不难，每天坚持一句就够啦!";
                // Set the action button
                localNotif.alertAction = @"查看";
                localNotif.soundName = musicName;
                localNotif.applicationIconBadgeNumber = 1;
                localNotif.repeatInterval = NSWeekCalendarUnit;
                [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
            }
        }
    }


}

#pragma mark - UITableView Datasource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 1;
        }
        case 1: {
            return 1;
        }
        default:
            return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"notificationSwitchCell"];
                    cell.textLabel.text = @"是否开启提醒";
                    cell.detailTextLabel.text = @"提醒您学习，每天坚持一句哦";
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.detailTextLabel.font = SOURCE_LANGUAGE_FONT(12);
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    UISwitch *aswitch = [[UISwitch alloc] initWithFrame:CGRectMake(215, (44 - 30) / 2, 30, 30)];
                    aswitch.onTintColor = [UIColor colorWithRed:80 / 255. green:168 / 255. blue:0 alpha:0.9];
                    [aswitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
                    aswitch.tag = 101;
                    BOOL isTrue = [[[GlobalAppConfig sharedInstance] valueForKey:knotificationOn] boolValue];
                    if (isTrue)
                        aswitch.on = YES;
                    [cell.contentView addSubview:aswitch];
                    return cell;
                }
            }
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"notificationRepeatCell"];
                    cell.textLabel.text = @"重复频率";
                    cell.detailTextLabel.text = [Global repeatDays];
                    cell.detailTextLabel.font = SOURCE_LANGUAGE_FONT(12);
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
                case 1: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"notificationRepeatCell"];
                    NSString *musicName = [[GlobalAppConfig sharedInstance] valueForKey:knotificationMusic];
                    if ([musicName isEqualToString:DEFAULT_NOTIFI_MUSIC]) {
                        cell.textLabel.text = @"提醒音(系统默认提示音)";
                    } else {
                        cell.textLabel.text = [NSString stringWithFormat:@"提醒音(%@)", musicName];
                    }
                    //cell.detailTextLabel.text = [Global repeatDays];
                    cell.detailTextLabel.font = SOURCE_LANGUAGE_FONT(12);
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
            }
        }
    }
    return nil;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return @"需要在\"设置->通知\"中开启才会生效喔!";
    }
    return @"";
}


#pragma mark  -  UITableView delegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _shouldReSchedule = YES;
    switch (indexPath.section) {
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    NotificationRepeatController *controller = [[NotificationRepeatController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;

                case 1: {
                    NotificationSoundController *controller = [[NotificationSoundController alloc] init];
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
            }
        }
    }
}


@end