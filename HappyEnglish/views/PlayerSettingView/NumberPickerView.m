//
// Created by @krq_tiger on 13-6-24.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NumberPickerView.h"
#import "Global.h"
#import "OneDayInfoRepository.h"
#import "OneDayInfo.h"
#import "HappyEnglishAPI.h"


@implementation NumberPickerView {
    UIPickerView *_startNumberPicker;
    UIPickerView *_endNumberPicker;
    UILabel *_startLabel;
    UILabel *_endLabel;
    NSInteger _count;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NumberRange numberRange = [HappyEnglishAPI queryIssueNumberRange];
        int start = numberRange.startNumber;
        int end = numberRange.endNumber;
        NSMutableArray *array = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginIndex:0 andPageSize:1];
        _count = (array && array.count >= 1) ? ((OneDayInfo *) [array objectAtIndex:0]).issueNumber : 10;
        _startLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width / 2, 30)];
        _startLabel.text = [NSString stringWithFormat:@"开始:第%d期", start];
        _startLabel.textAlignment = UITextAlignmentCenter;
        _startLabel.textColor = [UIColor whiteColor];
        _startLabel.backgroundColor = [UIColor clearColor];
        _startLabel.font = SOURCE_LANGUAGE_FONT(15);// [UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:15];

        _endLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2, 0, frame.size.width / 2, 30)];
        _endLabel.text = [NSString stringWithFormat:@"结束:第%d期", end];
        _endLabel.textAlignment = UITextAlignmentCenter;
        _endLabel.backgroundColor = [UIColor clearColor];
        _endLabel.textColor = [UIColor whiteColor];
        _endLabel.font = SOURCE_LANGUAGE_FONT(15);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:15];
        float y = _endLabel.frame.size.height + MARGIN;

        _startNumberPicker = [[UIPickerView alloc] init];
        _startNumberPicker.frame = CGRectMake(0, y, frame.size.width / 2 - MARGIN, frame.size.height - y);
        _startNumberPicker.dataSource = self;
        _startNumberPicker.delegate = self;
        _startNumberPicker.tag = 100;
        _startNumberPicker.showsSelectionIndicator = YES;

        [_startNumberPicker selectRow:start - 1 inComponent:0 animated:YES];

        _endNumberPicker = [[UIPickerView alloc] init];
        _endNumberPicker.frame = CGRectMake(frame.size.width / 2 + MARGIN, y, frame.size.width / 2 - MARGIN, frame.size.height - y);
        _endNumberPicker.dataSource = self;
        _endNumberPicker.delegate = self;
        _endNumberPicker.tag = 101;
        _endNumberPicker.showsSelectionIndicator = YES;
        [_endNumberPicker selectRow:end - 1 inComponent:0 animated:YES];

        [self addSubview:_startLabel];
        [self addSubview:_endLabel];
        [self addSubview:_startNumberPicker];
        [self addSubview:_endNumberPicker];
    }

    return self;
}


#pragma mark - implement UIPickerViewDatasource and UIPickerViewDelegate -
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"第%d期", row + 1];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *viewForRow = (UILabel *) view;
    if (viewForRow == nil) {
        viewForRow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 30)];
        viewForRow.font = SOURCE_LANGUAGE_FONT(15);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:15];
        viewForRow.textAlignment = UITextAlignmentCenter;
        viewForRow.backgroundColor = [UIColor clearColor];
    }
    viewForRow.text = [NSString stringWithFormat:@"第%d期", row + 1];
    return viewForRow;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 100) {
        [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithInt:row + 1] forKey:kstartNumber];
        _startLabel.text = [NSString stringWithFormat:@"开始:第%d期", row + 1];

    } else {
        [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithInt:row + 1] forKey:kendNumber];
        _endLabel.text = [NSString stringWithFormat:@"结束:第%d期", row + 1];
    }
}
@end