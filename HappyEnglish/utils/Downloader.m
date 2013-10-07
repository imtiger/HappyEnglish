//
// Created by @krq_tiger on 13-5-17.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Downloader.h"
#import "Global.h"
#import "HappyEnglishAppDelegate.h"


@implementation Downloader {

    NSUInteger _currentIndex;
    float _currentTotalSize;
    float _currentDownloadedSize;
    NSURLConnection *_urlConnection;
    BOOL _downloadCancel;
    BOOL _isDownloading;
    NSString *_currentTempFileName;
}

- (void)start {
    _urlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.downloadUrls objectAtIndex:_currentIndex]]] delegate:self];
}

#pragma mark - urlConnection delegate-

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _isDownloading = YES;
    _currentTempFileName = self.storePath != nil ? [self.storePath stringByAppendingPathComponent:[Global uuid]] : [NSTemporaryDirectory() stringByAppendingPathComponent:[Global uuid]];
    NSString *fileName = [self getCurrentRealFileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
        [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
    }
    _currentTotalSize = [[NSNumber numberWithLongLong:response.expectedContentLength] floatValue];
    _currentDownloadedSize = 0;
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadStartAtIndex:totalSize:downloader:)]) {
        [self.delegate downloadStartAtIndex:_currentIndex totalSize:_currentTotalSize downloader:nil ];
    }


}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_downloadCancel)return;
    _currentDownloadedSize = _currentDownloadedSize + data.length;
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveDataAtIndex:dataSize:totalSize:downloader:)])
        [self.delegate receiveDataAtIndex:_currentIndex dataSize:_currentDownloadedSize totalSize:_currentTotalSize downloader:nil ];
    [self writeToFile:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _isDownloading = NO;
    [[NSFileManager defaultManager] moveItemAtPath:_currentTempFileName toPath:[self getCurrentRealFileName] error:nil];
    if (_downloadCancel)return;
    _currentIndex++;
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadFinishedAtIndex:downloader:)]) {
        [self.delegate downloadFinishedAtIndex:_currentIndex downloader:nil ];

    }
    [self downloadIfNotExist];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"error=%@", error);
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadErrorAtIndex:error:downloader:)]) {
        [self.delegate downloadErrorAtIndex:_currentIndex error:error downloader:nil ];
    }
    [[NSFileManager defaultManager] removeItemAtPath:_currentTempFileName error:&error];
    _currentIndex++;
    [self downloadIfNotExist];
}

- (void)cancel {
    if (_urlConnection) {
        [_urlConnection cancel];
        _downloadCancel = YES;
        if (_currentIndex == _downloadUrls.count)return;
        NSError *error;
        if (_isDownloading) {
            [[NSFileManager defaultManager] removeItemAtPath:_currentTempFileName error:&error];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(downloadCanceled:)]) {
            [self.delegate downloadCanceled:self];
        }
    }
}


- (void)writeToFile:(NSData *)data {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = _currentTempFileName;
    if (![fileManager fileExistsAtPath:fileName]) {
        BOOL success = [fileManager createFileAtPath:fileName contents:nil attributes:nil];
        //TODO
    }
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:data];
    [fileHandle closeFile];

}


- (NSString *)getCurrentRealFileName {
    return self.urlToFileNameAdapter([_downloadUrls objectAtIndex:_currentIndex]);
}

- (void)download {
    _urlConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.downloadUrls objectAtIndex:_currentIndex]]] delegate:self];
}

- (void)downloadIfNotExist {
    NetworkStatus networkStatus = [HappyEnglishAppDelegate sharedAppDelegate].networkStatus;
    if (![self canGoOn:networkStatus]) {
        [self cancel];
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"网络环境发生变化" duration:3];
        return;
    }
    for (; _currentIndex <= self.downloadUrls.count - 1; _currentIndex++) {
        NSString *fileName = [self getCurrentRealFileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileName]) {
            continue;
        } else {
            [self performSelector:@selector(download) withObject:nil afterDelay:1];
            break;
        }
    }
    if (_currentIndex == self.downloadUrls.count) {
        double delayInSeconds = 1.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            if (_downloadCancel)return;
            if (self.delegate && [self.delegate respondsToSelector:@selector(allFinished:)]) {
                [self.delegate allFinished:self];
            }
        });
    }
}

- (BOOL)canGoOn:(NetworkStatus)networkstat {
    for (NSNumber *status in self.requireNetworkStatus) {
        if (networkstat == status.intValue) {
            return true;
        }
    }
    return false;
}

- (void)dealloc {
    self.downloadUrls = nil;
    self.storePath = nil;
    self.urlToFileNameAdapter = nil;
    self.delegate = nil;
    self.requireNetworkStatus = nil;
    _urlConnection = nil;
}


@end