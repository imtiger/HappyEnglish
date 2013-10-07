//
// Created by @krq_tiger on 13-6-16.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "SettingRootController.h"
#import "Global.h"
#import "CommonWebController.h"
#import "FontSettingController.h"
#import "HappyEnglishAppDelegate.h"
#import "NotificationController.h"
#import "NSDate+Helper.h"


@implementation SettingRootController {


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *selectedIndex = [_tableView indexPathForSelectedRow];
    [_tableView deselectRowAtIndexPath:selectedIndex animated:YES];
    [_tableView reloadData];
};

- (void)loadView {
    [super loadView];
    float btnWidth = 39;
    float btnHeight = 32;
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - btnWidth - 3 * MARGIN, (45 - btnHeight) / 2, btnWidth, btnHeight)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"popView_doneBtn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceItem.width = 10;
    UIBarButtonItem *menuBtn = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:fixedSpaceItem, menuBtn, nil];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    titleView.text = @"设置";
    titleView.font = CHINESE_TITLE_FONT;
    titleView.textColor = [UIColor blackColor];
    titleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleView;

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    [self.view setBackgroundColor:[UIColor clearColor]];

}

- (void)settingDone {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - implement UITableViewDelegate and UITableViewDatasource -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 35)];
    titleLabel.font = SOURCE_LANGUAGE_FONT(15);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    //titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    switch (section) {
        case 0 : {
            titleLabel.text = @"设置";
        }
            break;
        case 1: {
            titleLabel.text = @"关于HappyEnglish";
        }
            break;
        case 2 : {
            titleLabel.text = @"关于我们";
        }
            break;

        default: {
        }
    }
    return titleView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: {
            return 4;
        }
        case 1: {
            return 4;
        }
        case 2: {
            return 2;
        }
        default:
            return 0;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingSwitchCell"];
                    cell.textLabel.text = @"WIFI下自动下载音频";
                    cell.detailTextLabel.text = @"开启后可以离线播放";
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    //cell.backgroundColor = [UIColor clearColor];
                    cell.detailTextLabel.font = SOURCE_LANGUAGE_FONT(12);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:12];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    UISwitch *aswitch = [[UISwitch alloc] initWithFrame:CGRectMake(215, (44 - 30) / 2, 30, 30)];
                    aswitch.onTintColor = [UIColor colorWithRed:80 / 255. green:168 / 255. blue:0 alpha:0.9];
                    [aswitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                    aswitch.tag = 100;
                    BOOL isTrue = [[[GlobalAppConfig sharedInstance] valueForKey:kwifiAutoDownload] boolValue];
                    if (isTrue)
                        aswitch.on = YES;
                    [cell.contentView addSubview:aswitch];
                    return cell;
                }

                case 1: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"settingSwitchCell"];
                    cell.textLabel.text = @"跳过开场白";
                    cell.detailTextLabel.text = @"开启后跳过节目开场白";
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    //cell.backgroundColor = [UIColor clearColor];
                    cell.detailTextLabel.font = SOURCE_LANGUAGE_FONT(12);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:12];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    UISwitch *aswitch = [[UISwitch alloc] initWithFrame:CGRectMake(215, (44 - 30) / 2, 30, 30)];
                    aswitch.onTintColor = [UIColor colorWithRed:80 / 255. green:168 / 255. blue:0 alpha:0.9];
                    [aswitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
                    aswitch.tag = 101;
                    BOOL isTrue = [[[GlobalAppConfig sharedInstance] valueForKey:kskipIntroduction] boolValue];
                    if (isTrue)
                        aswitch.on = YES;
                    [cell.contentView addSubview:aswitch];
                    return cell;
                }
                case 2: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"nil"];
                    if ([[[GlobalAppConfig sharedInstance] valueForKey:knotificationOn] boolValue]) {
                        NSDate *time = [[GlobalAppConfig sharedInstance] valueForKey:knotificationTime];
                        if (time) {
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            [dateFormatter setDateFormat:@"a hh:mm "];
                            dateFormatter.calendar = [NSDate getCalendar];
                            cell.textLabel.text = [NSString stringWithFormat:@"学习提醒(已启动:%@)", [dateFormatter stringFromDate:time]];
                        } else {
                            cell.textLabel.text = @"学习提醒(已启动)";
                        }
                        cell.detailTextLabel.text = [Global repeatDays];
                        cell.detailTextLabel.font = SOURCE_LANGUAGE_FONT(12);
                    } else {
                        cell.textLabel.text = @"学习提醒(已关闭)";
                    }
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
                case 3: {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
                    cell.textLabel.text = @"字体设置";
                    cell.textLabel.font = CHINESE_TEXT_FONT;
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    return cell;
                }
                default: {
                }
            }

        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
                cell.textLabel.font = CHINESE_TEXT_FONT;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"功能介绍";
                    if ([HappyEnglishAppDelegate sharedAppDelegate].shouldUpdate) {
                        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 30, 25)];
                        tipLabel.text = @"New";
                        tipLabel.backgroundColor = [UIColor colorWithRed:80 / 255. green:168 / 255. blue:0 alpha:0.9];
                        tipLabel.layer.cornerRadius = 5;
                        tipLabel.font = ENGLISH_TEXT_FONT;
                        tipLabel.textAlignment = UITextAlignmentCenter;
                        tipLabel.textColor = [UIColor whiteColor];
                        UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, 50, 25)];
                        versionLabel.text = [HappyEnglishAppDelegate sharedAppDelegate].latestVersion;
                        versionLabel.font = CHINESE_TEXT_FONT;
                        versionLabel.backgroundColor = [UIColor clearColor];
                        [cell.contentView addSubview:tipLabel];
                        [cell.contentView addSubview:versionLabel];
                    }
                    return cell;
                }

                case 1: {
                    cell.textLabel.text = @"你说的我都放在心上喔";
                    return cell;
                }
                case 2: {
                    cell.textLabel.text = @"能否给我一点爱?";
                    return cell;
                }
                case 3: {
                    cell.textLabel.text = @"关于HappyEnglish";
                    return cell;
                }

            }
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"settingCell"];
                cell.textLabel.font = CHINESE_TEXT_FONT;
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"关于Allen老师";
                    return cell;
                }
                case 1: {
                    cell.textLabel.text = @"关于软件作者";
                    return cell;
                }
            }

        }

    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 2: {
                    NotificationController *notificationController = [[NotificationController alloc] init];
                    [self.navigationController pushViewController:notificationController animated:YES];
                }
                    break;
                case 3: {
                    FontSettingController *fontSettingController = [[FontSettingController alloc] init];
                    [self.navigationController pushViewController:fontSettingController animated:YES];
                }
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0 : {
                    CommonWebController *aboutController = [[CommonWebController alloc] initWithRequestUrl:FEATURES_URL name:@"功能介绍"];
                    aboutController.returnCallbackBlock = ^{
                        if ([HappyEnglishAppDelegate sharedAppDelegate].shouldUpdate) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否升级" message:@"看完新功能介绍，想升级吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"升级", nil];
                            [alertView show];
                        }
                    };
                    [self.navigationController pushViewController:aboutController animated:YES];
                }
                    break;

                case 1: {
                    [self showEmail];
                }
                    break;
                case 2: {
                    NSString *url = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:url, APP_ID]]];//https://itunes.apple.com/us/app/weico-for-weibo/id527106466?mt=8
                }
                    break;
                case 3: {
                    CommonWebController *aboutController = [[CommonWebController alloc] initWithRequestUrl:HELP_URL name:@"关于HappyEnglish"];
                    [self.navigationController pushViewController:aboutController animated:YES];
                }
                    break;
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    CommonWebController *aboutController = [[CommonWebController alloc] initWithRequestUrl:ABOUT_TEACHER_URL name:@"关于Allen老师"];
                    [self.navigationController pushViewController:aboutController animated:YES];

                }
                    break;
                case 1: {
                    CommonWebController *aboutController = [[CommonWebController alloc] initWithRequestUrl:ABOUT_ME_URL name:@"关于软件作者"];
                    [self.navigationController pushViewController:aboutController animated:YES];

                }
                    break;

                default: {
                }
            }
        }


    }
}


- (void)showEmail {
    // This sample can run on devices running iPhone OS 2.0 or later
    // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
    // So, we must verify the existence of the above class and provide a workaround for devices running
    // earlier versions of the iPhone OS.
    // We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
    // We launch the Mail application on the device, otherwise.

    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass canSendMail]) {
            [self presentMailController];
        }
        else {
            [self launchMailAppOnDevice];
        }
    }
    else {
        [self launchMailAppOnDevice];
    }
}

// Displays an email composition interface inside the application. Populates all the Mail fields.
- (void)presentMailController {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    mailController.navigationItem.titleView.backgroundColor = [UIColor redColor];
    NSArray *toRecipients = [NSArray arrayWithObject:@"xmuzyq@gmail.com"];
    [mailController setToRecipients:toRecipients];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    titleView.text = @"意见反馈";
    titleView.font = CHINESE_TITLE_FONT;
    titleView.textColor = [UIColor blackColor];
    titleView.backgroundColor = [UIColor clearColor];
    //[[[mailController viewControllers] lastObject] navigationItem].titleView = titleView;
    //[[mailController navigationBar] sendSubviewToBack:titleView];
    //[[mailController navigationBar] setTintColor:[UIColor colorWithRed:232 / 255. green:233 / 255. blue:233 / 255. alpha:1]];
    //mailController.navigationItem.titleView = titleView;
    [mailController setSubject:@"意见反馈"];
    //[[mailController navigationBar] setTintColor:[UIColor colorWithRed:243/255. green:243/255. blue:243/255. alpha:1]];
    [mailController setMessageBody:nil isHTML:YES];
    [self presentModalViewController:mailController animated:YES];
    //[self.navigationController pushViewController:mailController animated:YES];

}


#pragma mark - implement  MFMailComposeViewControllerDelegate -

// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSString *message = nil;
    // Notifies users about errors associated with the interface
    switch (result) {
        case MFMailComposeResultCancelled:
            //message = @"邮件取消";
            break;
        case MFMailComposeResultSaved:
            //message = @"邮件保存";
            break;
        case MFMailComposeResultSent:
            message = NSLocalizedString(@"邮件已经发送", @"");
            break;
        case MFMailComposeResultFailed:
            message = NSLocalizedString(@"邮件发送失败", @"");
            break;
        default:
            message = NSLocalizedString(@"邮件发送失败", @"");
            break;
    }

    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [self dismissModalViewControllerAnimated:YES];
}

// Launches the Mail application on the device.
- (void)launchMailAppOnDevice {
    NSString *email = @"mailto:xmuzyq@gmail.com?subject=意见反馈&body=反馈内容";
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}


- (void)switchChanged:(UISwitch *)sender {
    //NSLog(sender.on ? @"YES" : @"NO");
    if (sender.tag == 100) {
        if (sender.on) {
            [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:YES ] forKey:kwifiAutoDownload];
        } else {
            [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:NO] forKey:kwifiAutoDownload];
        }
    } else if (sender.tag == 101) {
        if (sender.on) {
            [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:YES ] forKey:kskipIntroduction];
        } else {
            [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:NO] forKey:kskipIntroduction];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - implement UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *url = @"itms-apps://itunes.apple.com/app/id%d";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:url, APP_ID]]];//https://itunes.apple.com/us/app/weico-for-weibo/id527106466?mt=8
    }
}

@end