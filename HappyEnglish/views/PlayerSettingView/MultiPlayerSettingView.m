//
// Created by @krq_tiger on 13-6-8.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "MultiPlayerSettingView.h"
#import "Global.h"
#import "NumberPickerView.h"
#import "HappyEnglishAppDelegate.h"
#import "PopEpisodeView.h"


@implementation MultiPlayerSettingView {
    NumberPickerView *_numberPickerView;
    UITableView *_tableView;
    BOOL _pickerHasShow;
    UIView *_backgroundView;
}


- (id)initWithFrame:(CGRect)frame andDelegate:(id <MultiPlayerSettingViewDelegate>)delegate {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;

        float y = 0;
        UIImageView *toolbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 45)];
        toolbar.image = [UIImage imageNamed:@"popView_toolbar_bg.png"];
        toolbar.userInteractionEnabled = YES;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"多期播放设置";
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = CHINESE_TEXT_FONT;
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        CGSize titleSize = [titleLabel.text sizeWithFont:CHINESE_TITLE_FONT constrainedToSize:CGSizeMake(frame.size.width, 44) lineBreakMode:UILineBreakModeCharacterWrap];
        titleLabel.frame = CGRectMake((frame.size.width - titleSize.width) / 2, (44 - titleSize.height) / 2, titleSize.width, titleSize.height);
        [toolbar addSubview:titleLabel];
        float btnWidth = 39;
        float btnHeight = 32;
        UIButton *_doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - btnWidth - 2 * MARGIN, (45 - btnHeight) / 2, btnWidth, btnHeight)];
        [_doneBtn setBackgroundImage:[UIImage imageNamed:@"popView_doneBtn.png"] forState:UIControlStateNormal];
        [_doneBtn addTarget:self action:@selector(settingDone) forControlEvents:UIControlEventTouchUpInside];
        [toolbar addSubview:_doneBtn];
        y = y + toolbar.frame.size.height;
        [self addSubview:toolbar];

        _backgroundView = [[UIView alloc] init];//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popView_textPanel_bg.png"]];
        _backgroundView.backgroundColor = POP_VIEW_BACKGROUND_COLOR;
        _backgroundView.frame = CGRectMake(0, y, frame.size.width, frame.size.height - y);
        _backgroundView.userInteractionEnabled = YES;
        [self addSubview:_backgroundView];
        [self sendSubviewToBack:_backgroundView];
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - y - SETTING_VIEW_BORDER) style:UITableViewStyleGrouped];
        _tableView.delegate = _delegate;
        _tableView.dataSource = _delegate;
        UIView *_tableBgView = [[UIView alloc] init];
        _tableBgView.backgroundColor = POP_VIEW_BACKGROUND_COLOR;
        _tableView.backgroundView = _tableBgView;//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popView_textPanel_bg.png"]];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_backgroundView addSubview:_tableView];


        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
    }
    return self;
}


- (void)settingDone {
    [(PopEpisodeView *) self.superview settingMultiPlayerDone:[_delegate settingChanged]];
}


- (void)showOrHiddenNumberPicker {
    if (!_numberPickerView) {
        _numberPickerView = [[NumberPickerView alloc] initWithFrame:CGRectMake(2 * MARGIN, _backgroundView.frame.size.height - NUMBER_PICKER_VIEW_HEIGHT- SETTING_VIEW_BORDER, _backgroundView.frame.size.width - 4 * MARGIN, NUMBER_PICKER_VIEW_HEIGHT)];
        _numberPickerView.hidden = YES;
        [_backgroundView addSubview:_numberPickerView];
    }
    if (_pickerHasShow) {
        int start = [[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue];
        int end = [[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
        if (end < start) {
            [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"结束期小于开始期，请重新选择！" duration:2];
        } else {
            [self hiddenNumberPicker];
        }
        return;
    }
    _pickerHasShow = YES;
    [UIView transitionWithView:_tableView duration:1 options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                        CGRect oldFrame = _tableView.frame;
                        oldFrame.origin.y = oldFrame.origin.y - NUMBER_PICKER_VIEW_HEIGHT- SETTING_VIEW_BORDER;
                        _tableView.frame = oldFrame;
                    }
                    completion:^(BOOL finished) {
                        _numberPickerView.hidden = NO;
                    }];

}

- (void)hiddenNumberPicker {
    if (!_pickerHasShow)return;
    _pickerHasShow = NO;
    _numberPickerView.hidden = YES;
    [UIView transitionWithView:_tableView duration:1 options:UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                        CGRect oldFrame = _tableView.frame;
                        oldFrame.origin.y = oldFrame.origin.y + NUMBER_PICKER_VIEW_HEIGHT+ SETTING_VIEW_BORDER;
                        _tableView.frame = oldFrame;
                    }
                    completion:^(BOOL finished) {
                        [_numberPickerView removeFromSuperview];
                        _numberPickerView = nil;
                    }];

    [_tableView reloadData];
}
@end