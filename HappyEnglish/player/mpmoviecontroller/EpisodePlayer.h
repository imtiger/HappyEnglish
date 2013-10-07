//
// Created by @krq_tiger on 13-6-7.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "OneDayInfo.h"
#import "AudioPlayer.h"
#import <MediaPlayer/MPMoviePlayerController.h>

#define SKIP_TIME 10
@class OneDayInfo;


@interface EpisodePlayer : NSObject <AudioPlayer> {
    AudioType _currentAudioType;
    MPMoviePlayerController *_player;
    BOOL _shouldGoToNext; //标志是否用户点击了pause按钮
}

@end