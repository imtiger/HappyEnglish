//
// Created by @krq_tiger on 13-6-29.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AudiosDownloader.h"
#import "Global.h"
#import "StringUtils.h"
#import "HappyEnglishAppDelegate.h"
#import "OneDayInfo.h"

#define QUEUE_SIZE 3

@implementation AudiosDownloader {
    NSMutableArray *_downloaders;
}
- (void)start:(NSArray *)episodes {
    if (!episodes || episodes.count == 0)return;
    if ([[[GlobalAppConfig sharedInstance] valueForKey:kwifiAutoDownload] boolValue]) {
        if ([HappyEnglishAppDelegate sharedAppDelegate].networkStatus == ReachableViaWiFi) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableArray *downloadUrls = [[NSMutableArray alloc] init];
                for (OneDayInfo *episode in episodes) {
                    if (![episode hasOffline:Detail]) {
                        [downloadUrls addObject:episode.detailAudioUrl];
                    }
                    if (![episode hasOffline:Slow]) {
                        [downloadUrls addObject:episode.slowAudioUrl];
                    }
                    if (![episode hasOffline:Normal]) {
                        [downloadUrls addObject:episode.normalAudioUrl];
                    }
                }
                if (downloadUrls && downloadUrls.count > 0) {
                    if (_downloaders && _downloaders.count > QUEUE_SIZE) {
                        Downloader *downloader = [_downloaders objectAtIndex:0];
                        [downloader cancel];
                        [_downloaders removeObjectAtIndex:0];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Global createAudioDirIfNotExist];
                        Downloader *downloader = [[Downloader alloc] init];
                        downloader.requireNetworkStatus = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:ReachableViaWiFi], nil];
                        downloader.downloadUrls = downloadUrls;
                        downloader.delegate = self;
                        downloader.storePath = AUDIO_CACHE_FOLDER;
                        downloader.urlToFileNameAdapter = ^NSString *(NSString *downloadUrl) {
                            NSString *fileName = [[StringUtils md5:downloadUrl] stringByAppendingString:AUDIO_SUFFIX];
                            return [AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName];
                        };
                        [downloader start];
                        if (!_downloaders)_downloaders = [[NSMutableArray alloc] init];
                        [_downloaders addObject:downloader];
                    });
                };
            });

        }
    }
}

- (void)cancel {
    for (Downloader *downloader in _downloaders) {
        [downloader cancel];
    }
}

+ (AudiosDownloader *)sharedInstance {
    static AudiosDownloader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudiosDownloader alloc] init];
    });
    return sharedInstance;
}


- (void)allFinished:(Downloader *)downloader {
    [_downloaders removeObject:downloader];
}

- (void)downloadCanceled:(Downloader *)downloader {
    [_downloaders removeObject:downloader];
}

- (void)dealloc {
    _downloaders = nil;
}


@end