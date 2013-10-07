//
// Created by @krq_tiger on 13-6-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import "HelpViewController.h"


@implementation HelpViewController {
    MPMoviePlayerViewController *_playerViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = [[NSBundle mainBundle] pathForResource:@"Movie" ofType:@"m4v"];
    _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieFinishedCallback:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:[_playerViewController moviePlayer]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:[_playerViewController moviePlayer]];

    _playerViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    _playerViewController.view.frame = self.view.bounds;
    MPMoviePlayerController *player = [_playerViewController moviePlayer];
    [player prepareToPlay];
    [self.view addSubview:_playerViewController.view];
    [player play];

}

- (void)moviePlaybackStateDidChange:(id)moviePlaybackStateDidChange {
    //NSLog(@"moviePlaybackStateDidChange");
}


- (void)movieFinishedCallback:(NSNotification *)aNotification {
    //NSLog(@"movieFinishedCallback");

    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
    [self.view removeFromSuperview];
}

- (void)returnCallback {
    if (_playerViewController) {
        [_playerViewController.moviePlayer stop];
    }
}


@end