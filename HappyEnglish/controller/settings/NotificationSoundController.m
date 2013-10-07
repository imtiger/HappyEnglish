//
// Created by @krq_tiger on 13-7-25.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NotificationSoundController.h"
#import "Global.h"


@implementation NotificationSoundController {
@private
    NSArray *_sounds;
    NSIndexPath *_currentIndexPath;
}

- (id)init {
    self = [super init];
    if (self) {
        _sounds = [NSArray arrayWithObjects:DEFAULT_NOTIFI_MUSIC, @"alarm_clock_ringing", nil];
    }

    return self;
}


- (void)loadView {
    [super loadView];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
}


#pragma mark - UITableView DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sounds.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *soundName = [_sounds objectAtIndex:indexPath.row];
    cell.textLabel.text = [soundName isEqualToString:DEFAULT_NOTIFI_MUSIC] ? @"系统默认提示音" : soundName;
    cell.textLabel.font = CHINESE_TEXT_FONT;
    NSString *musicName = [[GlobalAppConfig sharedInstance] valueForKey:knotificationMusic];
    if ([musicName isEqualToString:soundName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _currentIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


#pragma mark  - UITableView delegate - 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:_currentIndexPath animated:YES];
    UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:_currentIndexPath];
    currentCell.accessoryType = UITableViewCellAccessoryNone;
    NSString *musicName = [_sounds objectAtIndex:indexPath.row];
    [[GlobalAppConfig sharedInstance] setValue:musicName forKey:knotificationMusic];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _currentIndexPath = indexPath;
}


@end