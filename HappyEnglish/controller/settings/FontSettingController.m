//
// Created by @krq_tiger on 13-6-20.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Global.h"
#import "FontSettingController.h"


@implementation FontSettingController {
    NSMutableArray *_fontSizes;
    NSMutableDictionary *_fontSizesDict;
    NSIndexPath *_currentFontSizeIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _fontSizes = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithFloat:14], [NSNumber numberWithFloat:16], [NSNumber numberWithFloat:18], nil];
    _fontSizesDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"正常大小", [NSNumber numberWithFloat:14], @"较大", [NSNumber numberWithFloat:16], @"最大", [NSNumber numberWithFloat:18], nil];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    [self.view addSubview:_tableView];
    [self.view setBackgroundColor:[UIColor clearColor]];
}


- (void)returnCallback {
    [[NSNotificationCenter defaultCenter] postNotificationName:TEXT_FONT_SETTING_CHANGED object:nil];
}

#pragma mark - implement UITableViewDelegate and UITableViewDatasource -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
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
            titleLabel.text = @"字体设置";
        }
            break;

        default: {
        }
    }
    return titleView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fontSettingCell"];
            NSNumber *fontSizeNumber = [_fontSizes objectAtIndex:indexPath.row];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fontSettingCell"];
                cell.textLabel.font = SOURCE_LANGUAGE_FONT(fontSizeNumber.floatValue);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:fontSizeNumber.floatValue];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                UIImageView *checkedView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 5, 25, 25)];
                checkedView.image = [UIImage imageNamed:@"settingCell_selected.png"];
                checkedView.hidden = YES;
                checkedView.tag = 100;
                [cell.contentView addSubview:checkedView];
            }
            cell.textLabel.font = SOURCE_LANGUAGE_FONT(fontSizeNumber.floatValue);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:fontSizeNumber.floatValue];
            cell.textLabel.text = [_fontSizesDict objectForKey:[_fontSizes objectAtIndex:indexPath.row]];
            float fontSize = [[[GlobalAppConfig sharedInstance] valueForKey:ktextFontSize] floatValue];
            if (fontSize == [fontSizeNumber floatValue]) {
                [cell.contentView viewWithTag:100].hidden = NO;
                _currentFontSizeIndex = indexPath;
            }
            return cell;
        }

    }
    return nil;


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            [[GlobalAppConfig sharedInstance] setValue:[_fontSizes objectAtIndex:indexPath.row] forKey:ktextFontSize];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:_currentFontSizeIndex];
            [cell.contentView viewWithTag:100].hidden = YES;
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            [newCell.contentView viewWithTag:100].hidden = NO;
            _currentFontSizeIndex = indexPath;
            return;
        }
    }
}


@end