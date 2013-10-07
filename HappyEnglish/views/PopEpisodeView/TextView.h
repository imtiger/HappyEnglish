//
// Created by @krq_tiger on 13-6-21.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "OneDayInfo.h"
#import "CustomTextView.h"

@class OneDayInfo;
@class WordPanel;
@protocol PopEpisodeViewDelegate;
@class Word;
@class CustomTextView;


@interface TextView : UIView <UIGestureRecognizerDelegate, TranslateDelegate> {
    CustomTextView *_englishTextView;
    CustomTextView *_chineseTextView;
    UILabel *_downLoadTagLabel;
    UILabel *_createDateLabel;
    UIButton *_downloadBtn;
    WordPanel *_wordPanel;
    CGRect _selectRect;
}

@property(nonatomic) OneDayInfo *episode;
@property(nonatomic, weak, readonly) id <PopEpisodeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andEpisode:(OneDayInfo *)episode andDelegate:(id <PopEpisodeViewDelegate>)delegate isMulti:(BOOL)isMulti;


- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)oneDayInfo isMultiEpisode:(BOOL)isMultiEpisode;

- (void)settingToSingleEpisodePlayer;

- (void)settingToMultiEpisodePlayer;

- (void)changeToDownloadedState;

- (void)showWordPanel:(Word *)word;

@end