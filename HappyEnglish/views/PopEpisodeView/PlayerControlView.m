//
// Created by @krq_tiger on 13-6-21.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "PlayerControlView.h"
#import "Global.h"
#import "PopEpisodeView.h"
#import "HappyEnglishAppDelegate.h"


@implementation PlayerControlView {
    __weak OneDayInfo *_episode;
}

- (id)initWithFrame:(CGRect)frame andEpisode:(OneDayInfo *)episode andDelegate:(id <PopEpisodeViewDelegate>)delegate isMulti:(BOOL)isMulti {
    self = [super initWithFrame:frame];
    if (self) {
        _episode = episode;
        _delegate = delegate;
        float centerTipsWidth = 200;
        float centerTipHeight = 25;
        UIColor *tipsColor = TIPS_TEXT_COLOR;
        float y = 0;
        _centerTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - centerTipsWidth) / 2, y, centerTipsWidth, centerTipHeight)];
        _centerTipsLabel.backgroundColor = [UIColor clearColor];
        _centerTipsLabel.textAlignment = UITextAlignmentCenter;
        _centerTipsLabel.textColor = tipsColor;
        _centerTipsLabel.font = TIPS_TEXT_FONT;
        _centerTipsLabel.textColor = [UIColor whiteColor];
        _centerTipsLabel.text = isMulti && !episode ? @"播放列表为空" : @"";
        y = y + _centerTipsLabel.frame.size.height + 2 * MARGIN;

        _sliderContainer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popView_slider_bg.png"]];
        _sliderContainer.userInteractionEnabled = YES;
        _sliderContainer.frame = CGRectMake(0, y, frame.size.width, _sliderContainer.frame.size.height);
        y = y + _sliderContainer.frame.size.height;
        float sliderWidth = 220;
        float sliderHeight = 24;
        _slider = [[UISlider alloc] initWithFrame:CGRectMake((_sliderContainer.frame.size.width - sliderWidth) / 2, (_sliderContainer.frame.size.height - sliderHeight) / 2, sliderWidth, sliderHeight)];
        _slider.userInteractionEnabled = NO;
        [_slider setMinimumTrackImage:[UIImage imageNamed:@"popView_slider_minimumtrack_img.png"] forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:[UIImage imageNamed:@"popView_slider_maxmumtrack_img.png"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"popView_slider_thumb_img.png"] forState:UIControlStateNormal];
        [_slider addTarget:self.delegate action:@selector(sliderValueChanging:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self.delegate action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchCancel];
        [_slider addTarget:self.delegate action:@selector(sliderValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        float tipWidth = 38;
        float tipHeight = 30;
        CGFloat tipsY = (_sliderContainer.frame.size.height - tipHeight) / 2;
        _leftTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, tipsY, tipWidth, tipHeight)];
        _leftTipsLabel.backgroundColor = [UIColor clearColor];
        _leftTipsLabel.text = @"00:00";
        _leftTipsLabel.font = TIPS_TEXT_FONT;
        _leftTipsLabel.textAlignment = UITextAlignmentRight;
        _leftTipsLabel.textColor = [UIColor whiteColor];

        _rightTipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_sliderContainer.frame.size.width - tipWidth - MARGIN, tipsY, tipWidth, tipHeight)];
        _rightTipsLabel.text = @"00:00";
        _rightTipsLabel.backgroundColor = [UIColor clearColor];
        _rightTipsLabel.font = TIPS_TEXT_FONT;
        _rightTipsLabel.textAlignment = UITextAlignmentLeft;
        _rightTipsLabel.textColor = [UIColor whiteColor];

        [_sliderContainer addSubview:_leftTipsLabel];
        [_sliderContainer addSubview:_rightTipsLabel];
        [_sliderContainer addSubview:_slider];

        //UIImageView *controlPanelBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popView_controlPanel_bg.png"]];
        //controlPanelBg.frame = self.bounds;
        //[self addSubview:controlPanelBg];
        //[self sendSubviewToBack:controlPanelBg];
        self.backgroundColor = POP_VIEW_BACKGROUND_COLOR;

        float btnWidth = 39;
        float btnHeight = 32;
        float btnPanelHeight = self.frame.size.height - y;


        if (isMulti) {
            float btnWidth = 39;
            float btnHeight = 32;
            _settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - btnWidth - 2 * MARGIN, y + (btnPanelHeight - btnHeight) / 2, btnWidth, btnHeight)];
            [_settingBtn setBackgroundImage:[UIImage imageNamed:@"popView_settingBtn.png"] forState:UIControlStateNormal];
            [_settingBtn addTarget:self.delegate action:@selector(settingMultiPlayer) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_settingBtn];
        } else {
            _noLoopBtn = [[UIButton alloc] initWithFrame:CGRectMake(3 * MARGIN, y + (btnPanelHeight - btnHeight) / 2, btnWidth, btnHeight)];
            [_noLoopBtn setBackgroundImage:[UIImage imageNamed:@"popView_noLoopBtn.png"] forState:UIControlStateNormal];
            [_noLoopBtn addTarget:self action:@selector(settingLoopMode:) forControlEvents:UIControlEventTouchUpInside];

            _singleLoopBtn = [[UIButton alloc] initWithFrame:CGRectMake(3 * MARGIN, y + (btnPanelHeight - btnHeight) / 2, btnWidth, btnHeight)];
            [_singleLoopBtn setBackgroundImage:[UIImage imageNamed:@"popView_singleLoopBtn.png"] forState:UIControlStateNormal];
            [_singleLoopBtn addTarget:self action:@selector(settingLoopMode:) forControlEvents:UIControlEventTouchUpInside];

            _sequenceLoopBtn = [[UIButton alloc] initWithFrame:CGRectMake(3 * MARGIN, y + (btnPanelHeight - btnHeight) / 2, btnWidth, btnHeight)];
            [_sequenceLoopBtn setBackgroundImage:[UIImage imageNamed:@"popView_sequenceLoopBtn.png"] forState:UIControlStateNormal];
            [_sequenceLoopBtn addTarget:self action:@selector(settingLoopMode:) forControlEvents:UIControlEventTouchUpInside];
            _sequenceLoopBtn.hidden = YES;
            _singleLoopBtn.hidden = YES;
            [self addSubview:_noLoopBtn];
            [self addSubview:_singleLoopBtn];
            [self addSubview:_sequenceLoopBtn];
        }


        int playBtnWidth = 50;
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - playBtnWidth) / 2, y + (btnPanelHeight - playBtnWidth) / 2, playBtnWidth, playBtnWidth)];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"popView_playBtn.png"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        _playBtn.tag = 100;

        _pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - playBtnWidth) / 2, y + (btnPanelHeight - playBtnWidth) / 2, playBtnWidth, playBtnWidth)];
        [_pauseBtn setBackgroundImage:[UIImage imageNamed:@"popView_pauseBtn.png"] forState:UIControlStateNormal];
        [_pauseBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        _pauseBtn.tag = 101;
        _pauseBtn.hidden = YES;

        float previousBtnWidth = 40;
        _previousBtn = [[UIButton alloc] initWithFrame:CGRectMake(_playBtn.frame.origin.x - previousBtnWidth - MARGIN, y + (btnPanelHeight - previousBtnWidth) / 2, previousBtnWidth, previousBtnWidth)];
        [_previousBtn setBackgroundImage:[UIImage imageNamed:@"popView_previouseBtn.png"] forState:UIControlStateNormal];
        [_previousBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        _previousBtn.tag = 102;

        _nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(_playBtn.frame.origin.x + _playBtn.frame.size.width + MARGIN, y + (btnPanelHeight - previousBtnWidth) / 2, previousBtnWidth, previousBtnWidth)];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"popView_nextBtn.png"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.tag = 103;




        /* _singleEpisodePlayerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 3 * MARGIN- btnWidth, y + (btnPanelHeight - btnHeight) / 2, btnWidth, btnHeight)];
         [_singleEpisodePlayerBtn setBackgroundImage:[UIImage imageNamed:@"popView_singlePlayerBtn.png"] forState:UIControlStateNormal];
         [_singleEpisodePlayerBtn addTarget:self.delegate action:@selector(settingToSingleEpisodePlayer) forControlEvents:UIControlEventTouchUpInside];
         _multiEpisodePlayerBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 3 * MARGIN- btnWidth, y + (btnPanelHeight - btnHeight) / 2, btnWidth, btnHeight)];
         [_multiEpisodePlayerBtn setBackgroundImage:[UIImage imageNamed:@"popView_multiPlayerBtn.png"] forState:UIControlStateNormal];
         [_multiEpisodePlayerBtn addTarget:self.delegate action:@selector(settingToMultiEpisodePlayer) forControlEvents:UIControlEventTouchUpInside];
         _multiEpisodePlayerBtn.hidden = YES;
         _singleEpisodePlayerBtn.hidden = YES;*/


        [self addSubview:_centerTipsLabel];
        [self addSubview:_sliderContainer];
        [self addSubview:_playBtn];
        [self addSubview:_pauseBtn];
        [self addSubview:_previousBtn];
        [self addSubview:_nextBtn];
        [self addSubview:_singleEpisodePlayerBtn];
        [self addSubview:_multiEpisodePlayerBtn];
        UIBezierPath *maskPath;
        maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;

    }

    return self;
}


- (void)updateSliderProgressAndTips:(float)progress leftTips:(NSString *)leftTips rightTips:(NSString *)rightTips {
    if (isnan(progress) || progress < 0)progress = 0;
    _slider.value = progress;
    _leftTipsLabel.text = leftTips;
    _rightTipsLabel.text = rightTips;
}


- (void)updateViewToAudioStoppedState {
    _playBtn.hidden = NO;
    _pauseBtn.hidden = YES;
    _slider.userInteractionEnabled = NO;
    _slider.value = 0;
    _leftTipsLabel.text = @"00:00";
    _rightTipsLabel.text = @"00:00";
}

- (void)updateViewToAudioPausedState {
    _playBtn.hidden = NO;
    _pauseBtn.hidden = YES;
    _slider.userInteractionEnabled = NO;
}

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)oneDayInfo isMultiEpisode:(BOOL)isMultiEpisode {
    switch (audioType) {
        case Detail: {
            _centerTipsLabel.text = isMultiEpisode ? [NSString stringWithFormat:@"正在播放语音讲解(第%d期)", oneDayInfo.issueNumber] : @"正在播放语音讲解";
        }
            break;
        case Slow: {
            _centerTipsLabel.text = isMultiEpisode ? [NSString stringWithFormat:@"正在播放慢速领读(第%d期)", oneDayInfo.issueNumber] : @"正在播放慢速领读";
        }
            break;
        case Normal: {
            _centerTipsLabel.text = isMultiEpisode ? [NSString stringWithFormat:@"正在播放标准语速领读(第%d期)", oneDayInfo.issueNumber] : @"正在播放标准语速领读";
        }
            break;
        default: {
        }
    }
    _playBtn.hidden = YES;
    _pauseBtn.hidden = NO;
    _slider.userInteractionEnabled = YES;
}


- (void)settingLoopMode:(id)sender {
    id <PopEpisodeViewDelegate> delegate = (id <PopEpisodeViewDelegate>) self.delegate;
    if (sender == _noLoopBtn) {
        _noLoopBtn.hidden = YES;
        _singleLoopBtn.hidden = NO;
        _sequenceLoopBtn.hidden = YES;
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDImageViewInfo:[UIImage imageNamed:@"popView_singleLoopBtn.png"] tipsText:@"单音频循环" duration:2];
        [delegate settingLoopMode:Single_Loop];
    } else if (sender == _singleLoopBtn) {
        _noLoopBtn.hidden = YES;
        _singleLoopBtn.hidden = YES;
        _sequenceLoopBtn.hidden = NO;
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDImageViewInfo:[UIImage imageNamed:@"popView_sequenceLoopBtn.png"] tipsText:@"多音频循环" duration:2];
        [delegate settingLoopMode:Sequence_Loop];
    } else if (sender == _sequenceLoopBtn) {
        _noLoopBtn.hidden = NO;
        _singleLoopBtn.hidden = YES;
        _sequenceLoopBtn.hidden = YES;
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDImageViewInfo:[UIImage imageNamed:@"popView_noLoopBtn.png"] tipsText:@"顺序播放" duration:2];
        [delegate settingLoopMode:NO_Loop];
    }
}

- (void)settingToSingleEpisodePlayer {
    _singleEpisodePlayerBtn.hidden = YES;
    _multiEpisodePlayerBtn.hidden = NO;
    _noLoopBtn.hidden = NO;
    _sequenceLoopBtn.hidden = YES;
    _singleLoopBtn.hidden = YES;
    [[HappyEnglishAppDelegate sharedAppDelegate] showHUDImageViewInfo:[UIImage imageNamed:@"popView_singlePlayerBtn.png"] tipsText:@"单期播放模式" duration:1.5];

}

- (void)settingToMultiEpisodePlayer {
    //_singleEpisodePlayerBtn.hidden = NO;
    //_multiEpisodePlayerBtn.hidden = YES;
    _singleLoopBtn.hidden = YES;
    _noLoopBtn.hidden = YES;
    _sequenceLoopBtn.hidden = YES;
    [[HappyEnglishAppDelegate sharedAppDelegate] showHUDImageViewInfo:[UIImage imageNamed:@"popView_multiPlayerBtn.png"] tipsText:@"多期播放模式" duration:1.5];
}


- (void)playAudio:(id)sender {
    UIButton *clickedBtn = (UIButton *) sender;
    NSInteger tag = clickedBtn.tag;
    switch (tag) {
        case 100 : {
            //NSLog(@"play btn clicked,tag=%d", tag);
            [(id <PopEpisodeViewDelegate>) self.delegate play];
            break;
        }
        case 101: {
            //NSLog(@"pause btn clicked,tag=%d", tag);
            [(id <PopEpisodeViewDelegate>) self.delegate pause];
            break;
        }
        case 102: {
            //NSLog(@"previous  btn clicked,tag=%d", tag);
            [(id <PopEpisodeViewDelegate>) self.delegate previous];
            break;
        }
        case 103: {
            //NSLog(@"next  btn clicked,tag=%d", tag);
            [(id <PopEpisodeViewDelegate>) self.delegate next];
            break;
        }
        default:
            break;

    }
}


@end