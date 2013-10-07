//
// Created by @krq_tiger on 13-6-7.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MultiEpisodePlayer.h"
#import "Global.h"
#import "StringUtils.h"


@interface MultiEpisodePlayer ()

@end

@implementation MultiEpisodePlayer {
    NSInteger _currentEpisode;
    EpisodeMode _currentEpisodeMode;
    NSMutableArray *_episodes;
}

- (id)initWithEpisodes:(NSMutableArray *)episodes {
    self = [super init];
    if (self) {
        _episodes = episodes;
    }
    return self;
}


- (void)play {
    if (!_episodes || _episodes.count == 0)return;
    switch (_currentEpisodeMode) {
        case OneByOne:
        case OnlyDetail: {
            _currentAudioType = Detail;
        }
            break;
        case OnlySlow:
        case SlowAndNormal: {
            _currentAudioType = Slow;
        }
            break;
        case OnlyNormal: {
            _currentAudioType = Normal;
        }
            break;

    }
    BOOL success = YES;
    if (!_player) {
        success = [self resetPlayer];
    }
    if (success) {
        [_player play];
        _shouldGoToNext = YES;
        [self notifyDelegate:YES];
    }
}


- (void)pause {
    if (!_episodes || _episodes.count == 0)return;
    if (_player) {
        [_player pause];
    }
    _shouldGoToNext = NO;
    [self notifyDelegate:NO];
}

- (void)next {
    if (!_episodes || _episodes.count == 0)return;
    switch (_currentEpisodeMode) {
        case OneByOne:
        case OnlyDetail: {
            _currentEpisode++;
            if (_currentEpisode > _episodes.count - 1)
                _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
            _currentAudioType = Detail;
        }
            break;
        case OnlySlow:
        case SlowAndNormal: {
            _currentEpisode++;
            if (_currentEpisode > _episodes.count - 1)
                _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
            _currentAudioType = Slow;
        }
            break;
        case OnlyNormal: {
            _currentEpisode++;
            if (_currentEpisode > _episodes.count - 1)
                _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
            _currentAudioType = Normal;
        }
            break;

    }
    [self resetAndPlay];
}


- (void)previous {
    if (!_episodes || _episodes.count == 0)return;
    switch (_currentEpisodeMode) {
        case OneByOne:
        case OnlyDetail: {
            _currentEpisode--;
            if (_currentEpisode < 0)
                _currentEpisode = _episodes.count - 1;//播放列表第一个的上一个是最后一个
            _currentAudioType = Detail;
        }
            break;
        case OnlySlow:
        case SlowAndNormal: {
            _currentEpisode--;
            if (_currentEpisode < 0)
                _currentEpisode = _episodes.count - 1;//播放列表第一个的上一个是最后一个
            _currentAudioType = Slow;
        }
            break;
        case OnlyNormal: {
            _currentEpisode--;
            if (_currentEpisode < 0)
                _currentEpisode = _episodes.count - 1;//播放列表第一个的上一个是最后一个
            _currentAudioType = Normal;
        }
            break;

    }
    [self resetAndPlay];
}


- (void)cancel {
    [super cancel];
    _episodes = nil;
}

- (void)settingEpisodeMode:(EpisodeMode)episodeMode {
    _currentEpisodeMode = episodeMode;
}

#pragma mark - Override super class method -
- (void)audioPlayerDidFinishPlaying {
    switch (_currentEpisodeMode) {
        case OneByOne: {
            switch (_currentAudioType) {
                case Detail: {
                    _currentAudioType = Slow;
                }
                    break;
                case Slow: {
                    _currentAudioType = Normal;
                }
                    break;
                case Normal: {
                    _currentEpisode++;
                    if (_currentEpisode > _episodes.count - 1)
                        _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
                    _currentAudioType = Detail;
                }
                    break;
                default: {
                };
            };
        }
            break;
        case SlowAndNormal: {
            switch (_currentAudioType) {
                case Slow: {
                    _currentAudioType = Normal;
                }
                    break;
                case Normal: {
                    _currentEpisode++;
                    if (_currentEpisode > _episodes.count - 1)
                        _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
                    _currentAudioType = Slow;
                }
                    break;
                default: {
                }
            }
        }
            break;

        case OnlyDetail: {
            _currentEpisode++;
            if (_currentEpisode > _episodes.count - 1)
                _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
            _currentAudioType = Detail;
        }
            break;
        case OnlySlow: {
            _currentEpisode++;
            if (_currentEpisode > _episodes.count - 1)
                _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
            _currentAudioType = Slow;
        }
            break;
        case OnlyNormal: {
            _currentEpisode++;
            if (_currentEpisode > _episodes.count - 1)
                _currentEpisode = 0;//如果播放列表到末尾了，则从都开始
            _currentAudioType = Normal;
        }
            break;
    }
    [self resetAndPlay];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"%@", error);
}




#pragma mark - private method -

- (NSString *)getCurrentFileName {
    OneDayInfo *episode = [_episodes objectAtIndex:_currentEpisode];
    switch (_currentAudioType) {
        case Detail: {
            return [[StringUtils md5:episode.detailAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
        }

        case Slow: {
            return [[StringUtils md5:episode.slowAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
        }

        case Normal: {
            return [[StringUtils md5:episode.normalAudioUrl] stringByAppendingString:AUDIO_SUFFIX];
        }
        default:
            return @"";
    }
}


- (NSString *)getCurrentAudioUrl {
    OneDayInfo *episode = [_episodes objectAtIndex:_currentEpisode];
    switch (_currentAudioType) {
        case Detail: {
            return episode.detailAudioUrl;
        }

        case Slow: {
            return episode.slowAudioUrl;
        }

        case Normal: {
            return episode.normalAudioUrl;
        }
        default:
            return @"";
    }
}


- (OneDayInfo *)getCurrentEpisode {
    return [_episodes objectAtIndex:_currentEpisode];
}


@end