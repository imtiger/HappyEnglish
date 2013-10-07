//
// Created by @krq_tiger on 13-6-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "OneDayInfo.h"

@class OneDayInfo;
@protocol PopEpisodeViewDelegate;


@interface TitleView : UIView {
    UIImageView *_titleView;
    UILabel *_titleLabel;
    UIButton *_sharedBtn;
}

@property(nonatomic) OneDayInfo *episode;
@property(nonatomic, weak, readonly) id <PopEpisodeViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andEpisode:(OneDayInfo *)episode andDelegate:(id <PopEpisodeViewDelegate>)delegate isMulti:(BOOL)isMulti;

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)oneDayInfo isMultiEpisode:(BOOL)isMultiEpisode;

@end