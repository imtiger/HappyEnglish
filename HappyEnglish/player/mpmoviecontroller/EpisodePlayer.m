//
// Created by @krq_tiger on 13-6-7.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import "Global.h"
#import "HappyEnglishAppDelegate.h"
#import "EpisodePlayer.h"
#import "PlayerState.h"


@interface EpisodePlayer ()
- (void)audioPlayerDidFinishPlaying;
@end

@implementation EpisodePlayer {
    BOOL _isTuning;
}
@synthesize delegate;

- (void)tuningPlayProgress:(NSTimeInterval)progress {
    _isTuning = YES;
    if (_player) {
        if (_player.playbackState != MPMoviePlaybackStateStopped) {
            [_player stop];
        }
        _player.currentPlaybackTime = progress;
    }
}

- (void)stopTunePlayProgress:(NSTimeInterval)progress {
    _isTuning = NO;
    if (_player) {
        _player.currentPlaybackTime = progress;
        [_player prepareToPlay];
        [_player play];
        [self notifyDelegate:YES];
    }
}


- (PlayerState *)playerState {
    PlayerState *playerState = [[PlayerState alloc] init];
    playerState.currentTime = _player.currentPlaybackTime;
    playerState.duration = 2 * _player.duration;
    return playerState;
}


- (void)settingLoopMode:(LoopMode)loopMode {
    //do nothing,sub class to override this method
}


- (void)notifyDelegate:(BOOL)isPlaying {
    if (isPlaying) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerStarted:episode:)]) {
            [self.delegate playerStarted:_currentAudioType episode:[self getCurrentEpisode]];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerPaused:episode:)]) {
            [self.delegate playerPaused:_currentAudioType episode:[self getCurrentEpisode]];
        }
    }
}

- (void)cancel {
    [self removeCurrentPlayer];
}


- (BOOL)isPlaying {
    return _player.playbackState == MPMoviePlaybackStatePlaying;
}


#pragma mark - player notification  -
- (void)playbackStateChanged:(NSNotification *)notification {
    NSLog(@"---playbackStateChanged");
    switch (_player.playbackState) {
        case  MPMoviePlaybackStateStopped: {
            NSLog(@"MPMoviePlaybackStateStopped");
        }
            break;
        case MPMoviePlaybackStatePlaying: {
            NSLog(@"MPMoviePlaybackStatePlaying");
        }
            break;
        case MPMoviePlaybackStatePaused: {
            NSLog(@"MPMoviePlaybackStatePaused");
        }
            break;
        case MPMoviePlaybackStateInterrupted: {
            NSLog(@"MPMoviePlaybackStateInterrupted");
        }
            break;
        case MPMoviePlaybackStateSeekingForward: {
            NSLog(@"MPMoviePlaybackStateSeekingForward");
        }
            break;
        case MPMoviePlaybackStateSeekingBackward: {
            NSLog(@"MPMoviePlaybackStateSeekingBackward");
        }
    };
}

- (void)playbackDidFinish:(NSNotification *)notification {
    NSLog(@"---playbackDidFinish");
    //[self removePreviousPlayer];
    switch (_player.playbackState) {
        case  MPMoviePlaybackStateStopped: {
            NSLog(@"MPMoviePlaybackStateStopped"); //quci
            [self notifyDelegate:NO];
        }
            break;
        case MPMoviePlaybackStatePlaying: {
            NSLog(@"MPMoviePlaybackStatePlaying");
        }
            break;
        case MPMoviePlaybackStatePaused: {
            NSLog(@"MPMoviePlaybackStatePaused");  //normal
            [self notifyDelegate:NO];
        }
            break;
        case MPMoviePlaybackStateInterrupted: {
            NSLog(@"MPMoviePlaybackStateInterrupted");
        }
            break;
        case MPMoviePlaybackStateSeekingForward: {
            NSLog(@"MPMoviePlaybackStateSeekingForward");
        }
            break;
        case MPMoviePlaybackStateSeekingBackward: {
            NSLog(@"MPMoviePlaybackStateSeekingBackward");
        }
    };
    if (!_isTuning && _player.playbackState == MPMoviePlaybackStatePaused) {
        [self audioPlayerDidFinishPlaying];
    }
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue]) {
        /* The end of the movie was reached. */
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"MPMovieFinishReasonPlaybackEnded");
            /*
             Add your code here to handle MPMovieFinishReasonPlaybackEnded.
             */
            break;

            /* An error was encountered during playback. */
        case MPMovieFinishReasonPlaybackError:
            NSLog(@"An error was encountered during playback");
            break;

            /* The user stopped playback. */
        case MPMovieFinishReasonUserExited:
            NSLog(@"MPMovieFinishReasonUserExited");
            break;

        default:
            break;
    }
}

- (void)loadStateChanged:(NSNotification *)aNotification {
    NSLog(@"---loadStateChanged");
    MPMovieLoadState loadState = _player.loadState;
    /* The load state is not known at this time. */
    if (loadState & MPMovieLoadStateUnknown) {
        NSLog(@"MPMovieLoadStateUnknown");
    }

    /* The buffer has enough data that playback can begin, but it
     may run out of data before playback finishes. */
    if (loadState & MPMovieLoadStatePlayable) {
        NSLog(@"MPMovieLoadStatePlayable");
        if (_player.playbackState == MPMoviePlaybackStatePlaying) {
            /* if (_currentAudioType == Detail && [[[GlobalAppConfig sharedInstance] valueForKey:kskipIntroduction] boolValue]) {
                 _player.currentPlaybackTime = SKIP_TIME;
             }*/
            [_player play];
            [self notifyDelegate:YES];
        }
    }

    /* Enough data has been buffered for playback to continue uninterrupted. */
    if (loadState & MPMovieLoadStatePlaythroughOK) {
        NSLog(@"MPMovieLoadStatePlaythroughOK");

    }

    /* The buffering of data has stalled. */
    if (loadState & MPMovieLoadStateStalled) {
        NSLog(@"MPMovieLoadStateStalled------------------------");
    }
}

- (NSString *)getCurrentFileName {
    return nil;
}

- (NSString *)getCurrentAudioUrl {
    return nil;
}

- (OneDayInfo *)getCurrentEpisode {
    return nil;
}

- (void)resetAndPlay {
    BOOL resetSuccess = [self resetPlayer];
    if (resetSuccess) {
        [_player play];
        _shouldGoToNext = YES;
        [self notifyDelegate:YES];
    }
}

- (BOOL)resetPlayer {
    [self removeCurrentPlayer];
    NetworkStatus networkStatus = [HappyEnglishAppDelegate sharedAppDelegate].networkStatus;
    BOOL currentAudioOffline = [[self getCurrentEpisode] hasOffline:_currentAudioType];
    if (networkStatus == NotReachable && !currentAudioOffline) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"音频未下载，请开启网络播放！" duration:3];
        return NO;
    }
    /* if (_player) {
         _shouldGoToNext = NO;
         [_player stop];
         if (currentAudioOffline) {
             //_player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[Global fileFullPathOfAudioFile:[self getCurrentFileName]]]];
             [_player setContentURL:[NSURL fileURLWithPath:[Global fileFullPathOfAudioFile:[self getCurrentFileName]]]];
         } else {
             //_player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[self getCurrentAudioUrl]]];
             [_player setContentURL:[NSURL URLWithString:[self getCurrentAudioUrl]]];
         }
     } else {
         //
     }*/
    if (currentAudioOffline) {
        _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:[Global fileFullPathOfAudioFile:[self getCurrentFileName]]]];
    } else {
        _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:[self getCurrentAudioUrl]]];
    }
    _player.shouldAutoplay = NO;
    // _player.useApplicationAudioSession=YES;
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(playbackStateChanged:)
                   name:MPMoviePlayerPlaybackStateDidChangeNotification
                 object:_player];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(playbackDidFinish:)
                   name:MPMoviePlayerPlaybackDidFinishNotification
                 object:_player];

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(loadStateChanged:)
                   name:MPMoviePlayerLoadStateDidChangeNotification
                 object:_player];
    if (_currentAudioType == Detail && [[[GlobalAppConfig sharedInstance] valueForKey:kskipIntroduction] boolValue]) {
        _player.initialPlaybackTime = SKIP_TIME;
    } else {
        _player.initialPlaybackTime = 0;
    }
    /*[[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(playerDurationAvailable:)
                   name:MPMovieDurationAvailableNotification
                 object:_player];*/
    return YES;
}

- (void)playerDurationAvailable:(NSNotification *)aNotification {

    //NSLog(@"%f", ((MPMoviePlayerController *) aNotification.object).duration);

}


- (void)audioPlayerDidFinishPlaying {

}

- (void)removeCurrentPlayer {
    if (_player) {
        [[NSNotificationCenter defaultCenter]
                removeObserver:self
                          name:MPMoviePlayerPlaybackStateDidChangeNotification
                        object:_player];

        [[NSNotificationCenter defaultCenter]
                removeObserver:self
                          name:MPMoviePlayerPlaybackDidFinishNotification
                        object:_player];

        [[NSNotificationCenter defaultCenter]
                removeObserver:self
                          name:MPMoviePlayerLoadStateDidChangeNotification
                        object:_player];
        [_player stop]; //这里调用stop会导致 audioPlayerDidFinishPlaying 被调用
        _player = nil;
    }
}

- (void)dealloc {
    [self removeCurrentPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end