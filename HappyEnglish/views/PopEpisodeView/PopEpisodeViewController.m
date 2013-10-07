//
// Created by tiger on 13-5-17.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PopEpisodeViewController.h"
#import "StringUtils.h"
#import "Global.h"
#import "HappyEnglishAppDelegate.h"
#import "MTStatusBarOverlay.h"
#import "XMLParser.h"
#import "WordAudioPronounceController.h"
#import "MultiEpisodePlayer.h"
#import "OneDayInfoRepository.h"
#import "NSDate+Helper.h"
#import "JSONParser.h"
#import "HappyEnglishAPI.h"
#import "AudiosDownloader.h"
#import "PlayerState.h"

@implementation PopEpisodeViewController {
    NSMutableArray *_downloaders;
    Word *_currentWord;
    NSTimer *_timer;
    NSMutableArray *_httpClients;
    WordAudioPronounceController *_pronounceController;
    id <AudioPlayer> _episodePlayer;
    BOOL _isMultiEpisode;
    BOOL _shouldUpdateView;
}

- (void)clear {
    [super clear];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (_httpClients) {
        for (HttpClient *httpClient in _httpClients) {
            [httpClient cancel];
        }
    }
    _httpClients = nil;
    if (_currentWord) {
        _currentWord = nil;
    }
    if (_pronounceController) {
        [_pronounceController cancel];
        _pronounceController = nil;
    }
    if (_episodePlayer) {
        [_episodePlayer cancel];
        _episodePlayer = nil;
    }
    _isMultiEpisode = NO;
}


- (void)dealloc {
    [self clear];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (id)initWithPopViewClass:(NSString *)popViewClass {
    self = [super initWithPopViewClass:popViewClass];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEnteredBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleEnteredForeground:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
    _shouldUpdateView = YES;
    return self;
}

- (void)handleEnteredForeground:(NSNotification *)notification {
    if (_episodePlayer && _episodePlayer.isPlaying) {
        [self scheduleTimerToUpdateProgress];
    }
}

- (void)handleEnteredBackground:(NSNotification *)notification {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - implement PopViewDelegate --


- (void)popViewDidShow {
    [super popViewDidShow];
    _shouldUpdateView = YES;
    [Global playTipAudio:[[NSBundle mainBundle] URLForResource:@"happy_english_pop_show" withExtension:@"wav"]];
    BOOL singleTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:ksingleTipsDone] boolValue];
    BOOL multiTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:kmultiTipsDone] boolValue];
    if (!singleTipsDone || !multiTipsDone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:POP_VIEW_DID_SHOW object:nil];
    }
}

- (void)popViewDidHidden {
    [super popViewDidHidden];
    _shouldUpdateView = NO;
    BOOL singleTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:ksingleTipsDone] boolValue];
    BOOL multiTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:kmultiTipsDone] boolValue];
    if (!singleTipsDone || !multiTipsDone) {
        [[NSNotificationCenter defaultCenter] postNotificationName:POP_VIEW_DID_HIDDEN object:nil];
    }
}


#pragma mark - override super class method -
- (BOOL)shouldMoveWithThisTouch:(UITouch *)touch {
    PopEpisodeView *view = (PopEpisodeView *) self.popView;
    if (view) {
        if ([touch.view isKindOfClass:[UISlider class]]) {
            return NO;
        }
    }
    return YES;
}


- (NSObject *)getData {
    if (self.popDirection == JUST_POP)
        return [super getData];
    else {
        return [self getEpisodesWithEpisodePeriod];
    }
}




#pragma mark - implement PopEpisodeViewDelegate -

- (void)downloadAudio {
    [Global createAudioDirIfNotExist];
    Downloader *downloader = [[Downloader alloc] init];
    OneDayInfo *oneDayInfo = (OneDayInfo *) [self getData];
    NSMutableArray *downloadUrls = [[NSMutableArray alloc] initWithObjects:oneDayInfo.detailAudioUrl, oneDayInfo.normalAudioUrl, oneDayInfo.slowAudioUrl, nil];
    if (!_downloaders) {
        _downloaders = [[NSMutableArray alloc] init];
    }
    downloader.downloadUrls = downloadUrls;
    downloader.requireNetworkStatus = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:ReachableViaWWAN], [NSNumber numberWithInt:ReachableViaWiFi], nil];
    downloader.delegate = self;
    downloader.storePath = AUDIO_CACHE_FOLDER;
    downloader.urlToFileNameAdapter = ^NSString *(NSString *downloadUrl) {
        NSString *fileName = [[StringUtils md5:downloadUrl] stringByAppendingString:AUDIO_SUFFIX];
        return [AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName];
    };
    [downloader start];
    [_downloaders addObject:downloader];
}


- (void)play {
    [self initEpisodePlayerIfNotExist];
    [_episodePlayer play];
}

- (void)pause {
    [self initEpisodePlayerIfNotExist];
    [_episodePlayer pause];
}


- (void)next {
    [self initEpisodePlayerIfNotExist];
    [_episodePlayer next];
}

- (void)previous {
    [self initEpisodePlayerIfNotExist];
    [_episodePlayer previous];
}

- (void)settingLoopMode:(LoopMode)loopMode {
    [self initEpisodePlayerIfNotExist];
    [_episodePlayer settingLoopMode:loopMode];
}

- (void)setMultiEpisode:(BOOL)isMultiEpisode {
    _isMultiEpisode = isMultiEpisode;
    if (_episodePlayer) {
        [_episodePlayer cancel];
        _episodePlayer = nil;
    }
    if (_timer) {
        [_timer invalidate];
    }
}


- (void)sliderValueChanging:(UISlider *)sender {
    if (_episodePlayer) {
        PlayerState *playerState = _episodePlayer.playerState;
        NSTimeInterval progress = sender.value * playerState.duration;
        [_episodePlayer tuningPlayProgress:progress];
        [self cancelTimer];
        [self updatePlayProgress:[[PlayerState alloc] initWithCurrentTime:progress andDuration:playerState.duration]];
    }
}

- (void)updatePlayProgress:(PlayerState *)playerState {
    if (!_episodePlayer)return;
    //playerState = _episodePlayer.playerState;
    float progress = (float) (playerState.currentTime / playerState.duration);
    //NSLog(@"current=%f,duration=%f,progress=%f", playerState.currentTime, playerState.duration, progress);
    PopEpisodeView *popView = (PopEpisodeView *) self.popView;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setPositiveFormat:@"0"];
    [popView updateSliderProgressAndTips:progress leftTips:[self formatSecond:playerState.currentTime] rightTips:[self formatSecond:playerState.duration]];
}

- (void)sliderValueChanged:(UISlider *)sender {
    if (_episodePlayer) {
        PlayerState *playerState = _episodePlayer.playerState;
        NSTimeInterval progress = sender.value * playerState.duration;
        [_episodePlayer stopTunePlayProgress:progress];
    }
}


- (void)translate:(NSString *)text {
    if (!text || text.length == 0)return;
    if (_currentWord && [_currentWord.source isEqualToString:text]) {
        [self fetchWordFinished:_currentWord];
        return;
    }
    if (!_httpClients) {
        _httpClients = [[NSMutableArray alloc] init];
    }
    for (HttpClient *httpClient in _httpClients) {
        [httpClient cancel];
    }
    NSString *url = [NSString stringWithFormat:@"http://dict-co.iciba.com/api/dictionary.php?w=%@", text];
    HttpClient *client = [[HttpClient alloc] initWithRequestUrl:url andQueryStringDictionary:nil useCache:YES delegate:self];
    [client doRequestAsynchronous];
    [_httpClients addObject:client];
    [[HappyEnglishAppDelegate sharedAppDelegate].overlay postImmediateMessage:@"正在取词！" duration:1 animated:YES];
}

- (void)settingMultiPlayerDone:(BOOL)settingChanged {
    _shouldUpdateView = YES;
    if (_episodePlayer && _episodePlayer.isPlaying) {
        [self scheduleTimerToUpdateProgress];
    }
}

- (void)settingMultiPlayer {
    [(PopEpisodeView *) self.popView settingMultiPlayer];
    _shouldUpdateView = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)settingToMultiEpisodePlayer {
    [self setMultiEpisode:YES];
    [self play];
    [(PopEpisodeView *) self.popView settingToMultiEpisodePlayer];
}



#pragma mark - implement EpisodePlayerDelegate -
- (void)playerStopped {
    [self cancelTimer];
    [(PopEpisodeView *) self.popView updateViewToAudioStoppedState];
}


- (void)playerStarted:(AudioType)audioType episode:(OneDayInfo *)episode {
    [self scheduleTimerToUpdateProgress];
    PopEpisodeView *popView = (PopEpisodeView *) self.popView;
    if ([_episodePlayer isKindOfClass:[SingleEpisodePlayer class]]) {
        [popView updateViewToAudioStartedState:audioType episode:episode isMultiEpisode:NO];
    } else {
        [popView updateViewToAudioStartedState:audioType episode:episode isMultiEpisode:YES];
    }
}

- (void)playerPaused:(AudioType)audioType episode:(OneDayInfo *)episode {
    [self cancelTimer];
    [(PopEpisodeView *) self.popView updateViewToAudioPausedState];
}


- (void)scheduleTimerToUpdateProgress {
    if (!_shouldUpdateView) {
        return;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(updatePlayProgress)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)cancelTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


- (void)updatePlayProgress {
    [self updatePlayProgress:[_episodePlayer playerState]];
}

- (NSString *)formatSecond:(NSTimeInterval)totalSecond {
    if (totalSecond < 0 || isnan(totalSecond)) {
        return @"00:00";
    }
    int minute = (int) (totalSecond / 60);
    int second = (int) totalSecond % 60;
    return [NSString stringWithFormat:@"%.2d:%.2d", minute, second];
}

#pragma mark - implement DownloaderDelegate -
- (void)downloadErrorAtIndex:(int)index error:(NSError *)error downloader:(Downloader *)downloader {

}

- (void)allFinished:(Downloader *)downloader {
    PopEpisodeView *popView = (PopEpisodeView *) self.popView;
    [popView updateViewToDownloadedState];
    [_downloaders removeObject:downloader];
    [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayFinishedInformation:@"音频下载完成！" duration:2];
}

- (void)downloadCanceled:(Downloader *)downloader {
    [_downloaders removeObject:downloader];

}




#pragma mark - implement HttpClientDelegate -

- (void)httpClient:(HttpClient *)httpClient withRequestedData:(NSData *)data {
    Word *word = [XMLParser parseWord:data];
    if (word)
        _currentWord = word;
    if (!word.meaning || [word.meaning isEqualToString:@""]) {
        [httpClient removeCurrentRequestCache];
    }
    [self fetchWordFinished:word];
}

- (void)httpClient:(HttpClient *)httpClient withError:(NSError *)error {

}

#pragma mark - private method -
- (void)fetchWordFinished:(Word *)word {
    [(PopEpisodeView *) self.popView showWordPanel:word];
    if (word.pronunciationUrl) {
        if (!_pronounceController) {
            _pronounceController = [[WordAudioPronounceController alloc] init];
        }
        [_pronounceController doPronounce:word];

    }

}


- (void)initEpisodePlayerIfNotExist {
    if (!_episodePlayer) {
        if (_isMultiEpisode) {
            NSMutableArray *episodes = [self getEpisodesWithEpisodePeriod];
            if (episodes && episodes.count != 0) {
                _episodePlayer = [[MultiEpisodePlayer alloc] initWithEpisodes:episodes];
                EpisodeMode episodeMode;
                [[[GlobalAppConfig sharedInstance] valueForKey:kepisodeMode] getValue:&episodeMode];
                [_episodePlayer settingEpisodeMode:episodeMode];
                _episodePlayer.delegate = self;
                [[AudiosDownloader sharedInstance] start:episodes];
            }
        } else {
            OneDayInfo *episode = (OneDayInfo *) [self getData];
            _episodePlayer = [[SingleEpisodePlayer alloc] initWithInfo:episode];
            _episodePlayer.delegate = self;
            [[AudiosDownloader sharedInstance] start:[NSArray arrayWithObjects:episode, nil]];
        }
    }
}

- (NSMutableArray *)getEpisodesWithEpisodePeriod {
    EpisodePeriod episodePeriod;
    [[[GlobalAppConfig sharedInstance] valueForKey:kepisodePeriod] getValue:&episodePeriod];
    NSMutableArray *episodes;
    if (episodePeriod == YourChoice) {
        NumberRange numberRange = [HappyEnglishAPI queryIssueNumberRange];
        int startNumber = numberRange.startNumber;//[[[GlobalAppConfig sharedInstance] valueForKey:kstartNumber] intValue];
        int endNumber = numberRange.endNumber;//[[[GlobalAppConfig sharedInstance] valueForKey:kendNumber] intValue];
        episodes = [[OneDayInfoRepository sharedInstance] getEpisodesBetween:startNumber andEndNumber:endNumber];
        if (!episodes || episodes.count < endNumber - startNumber + 1) {
            episodes = [self requestEpisodesUsingNetwork:startNumber endNumber:endNumber];
        }
        if (!episodes || episodes.count == 0) {
            [self showTips:@"播放列表为空，点击右下角按钮设置!"];
        }
    } else if (episodePeriod == Favorite) {
        episodes = [[OneDayInfoRepository sharedInstance] getAllFavoriteEpisodes];
        if (!episodes || episodes.count == 0) {
            [self showTips:@"收藏列表为空，点击右下角按钮设置!"];
        }
    } else {
        NSDate *begin;
        NSDate *end;
        switch (episodePeriod) {
            case ThisWeek: {
                NSDate *now = [NSDate date];
                begin = [now beginningOfWeek];
                end = [now endOfWeek];
                episodes = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginDate:begin andEndDate:end];
            }
                break;
            case LastWeek: {
                NSDate *now = [NSDate date];
                NSDate *beginWeek = [now beginningOfWeek];
                begin = [beginWeek dateAfterDay:-7];
                end = [beginWeek dateAfterDay:-1];
                episodes = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginDate:begin andEndDate:end];
            }
                break;
            case LastTwoWeeks: {
                NSDate *now = [NSDate date];
                begin = [[now beginningOfWeek] dateAfterDay:-7];
                end = [now endOfWeek];
                episodes = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginDate:begin andEndDate:end];
            }
                break;
            case LastThreeWeeks: {
                NSDate *now = [NSDate date];
                begin = [[now beginningOfWeek] dateAfterDay:-14];
                end = [now endOfWeek];
                episodes = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginDate:begin andEndDate:end];
            }
                break;
            case ThisMonth: {
                NSDate *now = [NSDate date];
                begin = [now beginningOfMonth];
                end = [now endOfMonth];
                episodes = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginDate:begin andEndDate:end];
            }
                break;
            case LastMonth: {
                NSDate *now = [NSDate date];
                end = [[now beginningOfMonth] dateAfterDay:-1];
                begin = [end beginningOfMonth];
                episodes = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginDate:begin andEndDate:end];
            }
                break;
            default: {
            }
        }

        if (!episodes || episodes.count == 0) {
            episodes = [self requestEpisodesUsingNetwork:begin end:end];
        }
        if (!episodes || episodes.count == 0) {
            [self showTips:@"播放列表列表为空，点击右下角按钮设置!"];
        }
        //if (isDownload) [[AudiosDownloader sharedInstance] start:episodes];
    }
    return episodes;
}

- (void)showTips:(NSString *)textTips {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:textTips duration:3];
    });
}

- (NSMutableArray *)requestEpisodesUsingNetwork:(NSDate *)begin end:(NSDate *)end {
    NetworkStatus networkStatus = [HappyEnglishAppDelegate sharedAppDelegate].networkStatus;
    if (networkStatus == NotReachable) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"无网络连接，开启网络重试！" duration:3];
        return nil;
    } else {
        static NSString *requestUrl = @"http://open.imtiger.net/englishListByTime";
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[Global formatDate:begin] forKey:@"startTime"];
        [dict setObject:[Global formatDate:end] forKey:@"endTime"];
        HttpClient *client = [[HttpClient alloc] initWithRequestUrl:requestUrl andQueryStringDictionary:dict useCache:YES delegate:nil];
        NSError *error;
        NSData *data = [client doRequestSynchronous:&error];
        NSMutableArray *episodes = [[JSONParser parseOneDayInfos:data] mutableCopy];
        if (error) {
            [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"数据请求出错，请稍后再试！" duration:3];
        }
        if (episodes && episodes.count > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (OneDayInfo *episode in episodes) {
                    [[OneDayInfoRepository sharedInstance] createOneDayInfo:episode];
                }
            });
            //[[AudiosDownloader sharedInstance] start:episodes];
        }

        return episodes;
    }
}

- (NSMutableArray *)requestEpisodesUsingNetwork:(int)startNumber endNumber:(int)endNumber {
    NetworkStatus networkStatus = [HappyEnglishAppDelegate sharedAppDelegate].networkStatus;
    if (networkStatus == NotReachable) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"无网络连接，开启网络重试！" duration:3];
        return nil;
    } else {
        static NSString *requestUrl = @"http://open.imtiger.net/englishListByNum";
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSString stringWithFormat:@"%d", startNumber] forKey:@"start"];
        [dict setObject:[NSString stringWithFormat:@"%d", endNumber] forKey:@"end"];
        HttpClient *client = [[HttpClient alloc] initWithRequestUrl:requestUrl andQueryStringDictionary:dict useCache:YES delegate:nil];
        NSError *error;
        NSData *data = [client doRequestSynchronous:&error];
        NSMutableArray *episodes = [[JSONParser parseOneDayInfos:data] mutableCopy];
        if (error) {
            [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"数据请求出错，请稍后再试！" duration:3];
        }
        if (episodes && episodes.count > 0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (OneDayInfo *episode in episodes) {
                    [[OneDayInfoRepository sharedInstance] createOneDayInfo:episode];
                }
            });
            //[[AudiosDownloader sharedInstance] start:episodes];
        }
        return episodes;
    }
}

@end