//
// Created by @krq_tiger on 13-7-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "OneDayInfo.h"

@class PlayerState;


typedef enum {
    SlowAndNormal,
    OneByOne,
    OnlyDetail,
    OnlySlow,
    OnlyNormal,
} EpisodeMode;

typedef enum {
    ThisWeek,
    LastWeek,
    LastTwoWeeks,
    LastThreeWeeks,
    ThisMonth,
    LastMonth,
    Favorite,
    YourChoice

} EpisodePeriod;

typedef enum {
    NO_Loop = 0,
    Sequence_Loop = 1,
    Single_Loop = 2
} LoopMode;


@protocol AudioPlayerDelegate <NSObject>

- (void)playerStarted:(AudioType)audioType episode:(OneDayInfo *)episode;

- (void)playerPaused:(AudioType)audioType episode:(OneDayInfo *)episode;

- (void)playerStopped;

@end

@protocol AudioPlayer <NSObject>

@property(nonatomic, weak) id <AudioPlayerDelegate> delegate;

@property(nonatomic, readonly) BOOL isPlaying;

- (void)play;

- (void)pause;

- (void)next;

- (void)previous;

- (void)cancel;

- (void)settingLoopMode:(LoopMode)loopMode;

- (void)settingEpisodeMode:(EpisodeMode)episodeMode;

- (PlayerState *)playerState;


- (void)tuningPlayProgress:(NSTimeInterval)progress;

- (void)stopTunePlayProgress:(NSTimeInterval)progress;


- (NSString *)getCurrentFileName;

- (NSString *)getCurrentAudioUrl;

- (OneDayInfo *)getCurrentEpisode;

- (void)resetAndPlay;

- (BOOL)resetPlayer;

- (void)notifyDelegate:(BOOL)isPlaying;

- (void)removeCurrentPlayer;

@end