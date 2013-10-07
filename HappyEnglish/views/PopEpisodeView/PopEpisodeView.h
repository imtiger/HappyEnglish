//
// Created by @krq_tiger on 13-5-17.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//




#define TIPS_TEXT_COLOR [UIColor blackColor]
#define TEXT_PANEL_HEIGHT 160
#define CONTENT_TEXT_WIDTH 50
#define MARGIN 5
#define DATE_WIDTH 80
#define DATE_HEIGHT 15
#define MAX_TEXT_HEIGHT 60
#define MIN_TEXT_HEIGHT 30
#define POP_VIEW_BACKGROUND_COLOR [UIColor colorWithRed:56/255. green:56/255. blue:68/255. alpha:0.9]
//#define POP_TITLE_VIEW_BACKGROUND_COLOR [UIColor colorWithRed:56/255. green:56/255. blue:68/255. alpha:0.95]

#import <Foundation/Foundation.h>
#import "PopView.h"
#import "Word.h"
#import "OneDayInfo.h"
#import "SingleEpisodePlayer.h"

@protocol PopEpisodeViewDelegate <PopViewDelegate>

- (void)downloadAudio;

- (void)play;

- (void)pause;

- (void)next;

- (void)previous;

- (void)settingLoopMode:(LoopMode)loopMode;

- (void)setMultiEpisode:(BOOL)isMultiEpisode;

- (void)sliderValueChanging:(id)sender;

- (void)sliderValueChanged:(id)sender;

- (void)startTuningPlayer;

- (void)translate:(NSString *)text;

- (void)settingMultiPlayerDone:(BOOL)settingChanged;

- (void)settingMultiPlayer;

- (void)settingToSingleEpisodePlayer;

- (void)settingToMultiEpisodePlayer;


@end

@interface PopEpisodeView : PopView <UIGestureRecognizerDelegate>

- (void)updateViewToDownloadedState;

- (void)updateSliderProgressAndTips:(float)progress leftTips:(NSString *)leftTips rightTips:(NSString *)rightTips;

- (void)showWordPanel:(Word *)word;

- (void)updateViewToAudioStoppedState;

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)episode isMultiEpisode:(BOOL)isMultiEpisode;

- (void)settingMultiPlayerDone:(BOOL)settingChanged;

- (void)updateViewToAudioPausedState;

- (void)settingToSingleEpisodePlayer;

- (void)settingToMultiEpisodePlayer;

- (void)settingMultiPlayer;


@end