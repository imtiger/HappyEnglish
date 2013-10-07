//
// Created by @krq_tiger on 13-6-8.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MultiPlayerSettingViewController.h"
#import "EpisodePlayer.h"
#import "MultiPlayerSettingViewCell.h"
#import "GlobalAppConfig.h"
#import "Global.h"
#import "HappyEnglishAPI.h"

@interface NSValue (valueForEnum)
+ (NSValue *)episodeModeValue:(EpisodeMode)episodeMode;

+ (NSValue *)episodePeriodValue:(EpisodePeriod)episodeMode;
@end

@implementation NSValue (valueForEnum)
+ (NSValue *)episodeModeValue:(EpisodeMode)episodeMode {
    return [NSValue value:&episodeMode withObjCType:@encode(EpisodeMode)];
}

+ (NSValue *)episodePeriodValue:(EpisodePeriod)episodePeriod {
    return [NSValue value:&episodePeriod withObjCType:@encode(EpisodePeriod)];
}

@end

@implementation MultiPlayerSettingViewController {

    NSMutableArray *_dataSource;
    NSIndexPath *_currentEpisodeMode;
    NSIndexPath *_currentEpisodePeriod;
    EpisodeMode _settingBeforeEpisodeMode;
    EpisodePeriod _settingBeforeEpisodePeriod;
    int _settingBeforeStartNumber;
    int _settingBeforeEndNumber;
}


- (id)init {
    self = [super init];
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
        NSMutableArray *episodeModes = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:SlowAndNormal], [NSNumber numberWithInt:OneByOne],
                                                                               [NSNumber numberWithInt:OnlyDetail], [NSNumber numberWithInt:OnlySlow], [NSNumber numberWithInt:OnlyNormal], nil];
        NSMutableArray *period = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:ThisWeek], [NSNumber numberWithInt:LastWeek],
                                                                         [NSNumber numberWithInt:LastTwoWeeks], [NSNumber numberWithInt:LastThreeWeeks], [NSNumber numberWithInt:ThisMonth], [NSNumber numberWithInt:LastMonth], [NSNumber numberWithInt:Favorite], [NSNumber numberWithInt:YourChoice], nil];
        [_dataSource addObject:episodeModes];
        [_dataSource addObject:period];
        [[[GlobalAppConfig sharedInstance] valueForKey:kepisodePeriod] getValue:&_settingBeforeEpisodePeriod];
        [[[GlobalAppConfig sharedInstance] valueForKey:kepisodeMode] getValue:&_settingBeforeEpisodeMode];
        NumberRange numberRange = [HappyEnglishAPI queryIssueNumberRange];
        _settingBeforeStartNumber = numberRange.startNumber;//[[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue];
        _settingBeforeEndNumber = numberRange.endNumber;// [[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
    }
    return self;
}

#pragma mark - implement UITableViewDelegate -
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            MultiPlayerSettingViewCell *oldCell = (MultiPlayerSettingViewCell *) [tableView cellForRowAtIndexPath:_currentEpisodeMode];
            [oldCell setChecked:NO];
            _currentEpisodeMode = indexPath;
            [[GlobalAppConfig sharedInstance] setValue:[(NSMutableArray *) [_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] forKey:kepisodeMode];
        }
            break;
        case 1: {
            MultiPlayerSettingViewCell *oldCell = (MultiPlayerSettingViewCell *) [tableView cellForRowAtIndexPath:_currentEpisodePeriod];
            [oldCell setChecked:NO];
            _currentEpisodePeriod = indexPath;
            NSNumber *value = [(NSMutableArray *) [_dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [[GlobalAppConfig sharedInstance] setValue:value forKey:kepisodePeriod];
            if (value.intValue == YourChoice) {
                [_settingView showOrHiddenNumberPicker];
            } else {  //如果选择了其它的设置，则把选择日期播放的设置还原为老的
                int start = [[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue];
                int end = [[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
                if (start != _settingBeforeStartNumber) {
                    [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithInt:_settingBeforeStartNumber] forKey:kstartNumber];
                }
                if (end != _settingBeforeEndNumber) {
                    [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithInt:_settingBeforeEndNumber] forKey:kendNumber];
                }
                [_settingView hiddenNumberPicker];
            }
        }
        default: {
        }
    }
    MultiPlayerSettingViewCell *newCell = (MultiPlayerSettingViewCell *) [tableView cellForRowAtIndexPath:indexPath];
    [newCell setChecked:YES];
}




#pragma mark - implement UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSMutableArray *) [_dataSource objectAtIndex:section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"settingViewCell";
    MultiPlayerSettingViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!tableViewCell) {
        tableViewCell = [[MultiPlayerSettingViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        tableViewCell.textLabel.font = SOURCE_LANGUAGE_FONT(14);
    }
    tableViewCell.backgroundColor = [UIColor colorWithRed:227 / 255. green:227 / 255. blue:227 / 255. alpha:1];
    switch (indexPath.section) {
        case 0: {
            NSNumber *episodeMode = [(NSMutableArray *) [_dataSource objectAtIndex:0] objectAtIndex:indexPath.row];
            NSInteger episodeModeConfigValue = [[[GlobalAppConfig sharedInstance] valueForKey:kepisodeMode] intValue];
            BOOL checked = episodeMode.intValue == episodeModeConfigValue;
            if (checked) {
                _currentEpisodeMode = indexPath;
            }
            [tableViewCell setChecked:checked];
            switch (episodeMode.intValue) {
                case SlowAndNormal: {
                    tableViewCell.textLabel.text = @"慢速和标准语速";
                }
                    break;
                case OneByOne: {
                    tableViewCell.textLabel.text = @"所有语音";
                }
                    break;
                case OnlyDetail: {
                    tableViewCell.textLabel.text = @"仅语音讲解";
                }
                    break;
                case OnlySlow: {
                    tableViewCell.textLabel.text = @"仅慢速语音";
                }
                    break;
                case OnlyNormal: {
                    tableViewCell.textLabel.text = @"仅标准语速语音";
                }
                    break;
                default: {
                }
            }
            return tableViewCell;
        }
        case 1: {
            NSNumber *episodePeriod = [(NSMutableArray *) [_dataSource objectAtIndex:1] objectAtIndex:indexPath.row];
            NSInteger episodePeriodConfigValue = [[[GlobalAppConfig sharedInstance] valueForKey:kepisodePeriod] intValue];
            BOOL checked = episodePeriod.intValue == episodePeriodConfigValue;
            if (checked) {
                _currentEpisodePeriod = indexPath;
            }
            [tableViewCell setChecked:checked];
            switch (episodePeriod.intValue) {
                case ThisWeek: {
                    tableViewCell.textLabel.text = @"本周";
                }
                    break;
                case LastWeek: {
                    tableViewCell.textLabel.text = @"上周";
                }
                    break;
                case LastTwoWeeks: {
                    tableViewCell.textLabel.text = @"前两周";
                }
                    break;
                case LastThreeWeeks: {
                    tableViewCell.textLabel.text = @"前三周";
                }
                    break;
                case ThisMonth: {
                    tableViewCell.textLabel.text = @"本月";
                }
                    break;
                case LastMonth: {
                    tableViewCell.textLabel.text = @"上个月";
                }
                    break;
                case Favorite: {
                    tableViewCell.textLabel.text = @"收藏列表";
                }
                    break;
                case YourChoice: {
                    NumberRange numberRange = [HappyEnglishAPI queryIssueNumberRange];
                    int startNumber = numberRange.startNumber;//[[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue];
                    int endNumber = numberRange.endNumber;//[[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
                    tableViewCell.textLabel.text = [NSString stringWithFormat:@"按期播放(第%d期-第%d期)", startNumber, endNumber];
                }
                    break;
                default: {
                }
            }
            return tableViewCell;
        }
        default:
            return nil;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 35)];
    titleLabel.font = SOURCE_LANGUAGE_FONT(15);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:15];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    switch (section) {
        case 0 : {
            titleLabel.text = @"音频类型设置";
        }
            break;
        case 1 : {
            titleLabel.text = @"日期设置";
        }
            break;
        default: {
        }
    }
    return titleView;
}



#pragma mark - implement settingViewDelegate -
- (BOOL)settingChanged {
    EpisodePeriod episodePeriod;
    EpisodeMode episodeMode;
    [[[GlobalAppConfig sharedInstance] valueForKey:kepisodePeriod] getValue:&episodePeriod];
    [[[GlobalAppConfig sharedInstance] valueForKey:kepisodeMode] getValue:&episodeMode];
    BOOL changed = NO;
    if (episodePeriod == YourChoice) {
        changed = _settingBeforeStartNumber != [[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue] || _settingBeforeEndNumber != [[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
    }
    return changed || _settingBeforeEpisodePeriod != episodePeriod || _settingBeforeEpisodeMode != episodeMode; //TODO
}


@end