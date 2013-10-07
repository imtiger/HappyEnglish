//
// Created by @krq_tiger on 13-6-21.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "OneDayInfo.h"

@protocol PopEpisodeViewDelegate;
@class OneDayInfo;


@interface PlayerControlView : UIView {
    UIView *_sliderContainer;
    UISlider *_slider;
    UILabel *_leftTipsLabel;
    UILabel *_rightTipsLabel;
    UILabel *_centerTipsLabel;
    UIButton *_playBtn;
    UIButton *_pauseBtn;
    UIButton *_nextBtn;
    UIButton *_previousBtn;
    UIButton *_singleEpisodePlayerBtn;
    UIButton *_multiEpisodePlayerBtn;
    UIButton *_singleLoopBtn;
    UIButton *_sequenceLoopBtn;
    UIButton *_noLoopBtn;

    UIButton *_settingBtn;
}


@property(nonatomic, weak, readonly) id <PopEpisodeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andEpisode:(OneDayInfo *)episode andDelegate:(id <PopEpisodeViewDelegate>)delegate isMulti:(BOOL)isMulti;


- (void)updateSliderProgressAndTips:(float)progress leftTips:(NSString *)tips rightTips:(NSString *)tips1;

- (void)updateViewToAudioStoppedState;

- (void)updateViewToAudioPausedState;

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)oneDayInfo isMultiEpisode:(BOOL)isMultiEpisode;

- (void)settingToSingleEpisodePlayer;

- (void)settingToMultiEpisodePlayer;

@end