//
// Created by @krq_tiger on 13-5-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <AVFoundation/AVFoundation.h>
#import "WordAudioPronounceController.h"
#import "Word.h"
#import "Global.h"
#import "StringUtils.h"

@implementation WordAudioPronounceController {
    AVAudioPlayer *_wordAudioPlayer;
    Word *_currentWord;
    NSMutableArray *_httpClients;
}

- (void)doPronounce:(Word *)word {
    if ([word.pronunciationUrl isEqualToString:_currentWord.pronunciationUrl])return;
    _currentWord = word;
    if ([word pronounceAudioOffline]) {
        NSData *data = [NSData dataWithContentsOfFile:[word pronounceAudioPath]];
        [self playPronounceAudio:data];
        return;
    }
    if (!_httpClients) {
        _httpClients = [[NSMutableArray alloc] init];
    }
    for (HttpClient *httpClient in _httpClients) {
        [httpClient cancel];
    }
    HttpClient *httpClient = [[HttpClient alloc] initWithRequestUrl:word.pronunciationUrl andQueryStringDictionary:nil useCache:YES delegate:self];
    if (httpClient) {
        [httpClient doRequestAsynchronous];
        [_httpClients addObject:httpClient];
    }

}

- (void)cancel {
    if (_httpClients) {
        for (HttpClient *httpClient in _httpClients) {
            [httpClient cancel];
        }
        _httpClients = nil;
    }
    if (_wordAudioPlayer) {
        [_wordAudioPlayer stop];
        _wordAudioPlayer = nil;
    }
    if (_currentWord) {
        _currentWord = nil;
    }
}


- (void)httpClient:(HttpClient *)httpClient withRequestedData:(NSData *)data {
    if (!data) {
        return;
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:WORD_AUDIO_CACHE_FOLDER]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:WORD_AUDIO_CACHE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [[StringUtils md5:httpClient.requestUrl] stringByAppendingString:AUDIO_SUFFIX];
    [data writeToFile:[WORD_AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName] atomically:YES];
    [self playPronounceAudio:data];
}


- (void)httpClient:(HttpClient *)httpClient withError:(NSError *)error {
    NSLog(@"wordAudioError=%@", error);
}


- (void)playPronounceAudio:(NSData *)data {
    if (_wordAudioPlayer) {
        [_wordAudioPlayer stop];
    }
    NSError *error;
    _wordAudioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    _wordAudioPlayer.delegate = self;
    [_wordAudioPlayer prepareToPlay];
    [_wordAudioPlayer play];
}

- (void)dealloc {
    if (_wordAudioPlayer) {
        [_wordAudioPlayer stop];
        _wordAudioPlayer = nil;
    }
    if (_currentWord) {
        _currentWord = nil;
    }

    if (_httpClients) {
        for (HttpClient *httpClient in _httpClients) {
            [httpClient cancel];
        }
        _httpClients = nil;
    }
}

#pragma mark - implement AVAudioPlayerDelegate -
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    _currentWord = nil;
}


@end