//
// Created by @krq_tiger on 13-5-17.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "PopViewController.h"
#import "Downloader.h"
#import "HttpClient.h"
#import "EpisodePlayer.h"
#import "PopEpisodeView.h"

@interface PopEpisodeViewController : PopViewController <PopEpisodeViewDelegate, DownloaderDelegate, AVAudioPlayerDelegate, HttpClientDelegate, AudioPlayerDelegate>

@end
