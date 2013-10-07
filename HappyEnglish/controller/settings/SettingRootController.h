//
// Created by @krq_tiger on 13-6-16.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


@interface SettingRootController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate> {
    UITableView *_tableView;
}
@end