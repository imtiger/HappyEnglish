//
// Created by @krq_tiger on 13-5-27.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import "SingleEpisodePlayer.h"
#import "Global.h"
#import "StringUtils.h"


@interface SingleEpisodePlayer ()
@end

@implementation SingleEpisodePlayer {

    LoopMode _currentLoopMode;
    OneDayInfo *_episode;
}


- (id)initWithInfo:(OneDayInfo *)oneDayInfo {
    self = [super init];
    if (self) {
        _episode = oneDayInfo;
    }
    return self;
}

- (void)play {
    [self playAudioWithAudioType:_currentAudioType];
}

- (void)pause {
    [self playAudioWithAudioType:_currentAudioType];
}


- (void)next {
    [self playAudioWithAudioType:[self getNextAudioType]];
}


- (void)previous {
    [self playAudioWithAudioType:[self getPreviousAudioType]];
}


- (void)settingLoopMode:(LoopMode)loopMode {
    _currentLoopMode = loopMode;
    /* switch (_currentLoopMode) {
         case NO_Loop: {
             _currentLoopMode = Single_Loop;
             break;
         }
         case Single_Loop: {
             _currentLoopMode = Sequence_Loop;
             break;
         }
         case Sequence_Loop: {
             _currentLoopMode = NO_Loop;
             break;
         }
         default:
             break;
     }*/
}


- (void)cancel {
    [super cancel];
    _episode = nil;
}


#pragma mark - Override super class method -
- (void)audioPlayerDidFinishPlaying {
    switch (_currentLoopMode) {
        case NO_Loop: {
            [self removeCurrentPlayer];
            [self.delegate playerStopped];
            break;
        }
        case Single_Loop: {
            //_currentAudioType = audioType;
            //[self playAudioWithAudioType:_currentAudioType];
            [self resetAndPlay];
            break;
        }
        case Sequence_Loop: {
            [self playAudioWithAudioType:[self getNextAudioType]];
            break;
        }
    }
}

- (void)playAudioWithAudioType:(AudioType)audioType {
    if (_currentAudioType == audioType) {
        if (_player && _player.playbackState == MPMoviePlaybackStatePlaying) {
            [_player pause];
            _shouldGoToNext = NO;
            [self notifyDelegate:NO];
        } else if (!_player) {
            _currentAudioType = audioType;
            [self resetAndPlay];
        } else {
            [_player play];
            _shouldGoToNext = YES;
            [self notifyDelegate:YES];
        }
    } else {
        _currentAudioType = audioType;
        [self resetAndPlay];
    }
}


- (NSString *)getCurrentFileName {
    switch (_currentAudioType) {
        case Detail: {
            return [[StringUtils md5:_episode.detailAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
        }

        case Slow: {
            return [[StringUtils md5:_episode.slowAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
        }

        case Normal: {
            return [[StringUtils md5:_episode.normalAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
        }
        default:
            return @"";
    }
}

- (NSString *)getCurrentAudioUrl {
    switch (_currentAudioType) {
        case Detail: {
            return _episode.detailAudioUrl;
        }

        case Slow: {
            return _episode.slowAudioUrl;
        }

        case Normal: {
            return _episode.normalAudioUrl;
        }
        default:
            return @"";
    }
}

- (OneDayInfo *)getCurrentEpisode {
    return _episode;
}


- (AudioType)getNextAudioType {
    switch (_currentAudioType) {
        case Detail: {
            return Slow;
        }
        case Slow: {
            return Normal;
        }

        case Normal: {
            return Detail;
        }

        default:
            return UnKnow;
    }
}

- (AudioType)getPreviousAudioType {
    switch (_currentAudioType) {
        case Detail: {
            return Normal;
        }
        case Slow: {
            return Detail;
        }

        case Normal: {
            return Slow;
        }

        default:
            return UnKnow;
    }
}

@end