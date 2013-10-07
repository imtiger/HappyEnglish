//
// Created by @krq_tiger on 13-5-17.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "Reachability.h"

@class Downloader;

@protocol DownloaderDelegate <NSObject>

- (void)downloadStartAtIndex:(int)index totalSize:(float)totalSize downloader:(Downloader *)downloader;

- (void)receiveDataAtIndex:(int)index dataSize:(float)dataSize totalSize:(float)totalSize downloader:(Downloader *)downloader;

- (void)downloadFinishedAtIndex:(int)index downloader:(Downloader *)downloader;

- (void)downloadErrorAtIndex:(int)index error:(NSError *)error downloader:(Downloader *)downloader;

- (void)downloadCanceled:(Downloader *)downloader;

- (void)allFinished:(Downloader *)downloader;


@end

@interface Downloader : NSObject {


}

@property(nonatomic, strong) NSMutableArray *downloadUrls;
@property(nonatomic, strong) NSString *storePath;
@property(nonatomic, strong) id <DownloaderDelegate> delegate;
@property(nonatomic, copy) NSString *(^urlToFileNameAdapter)(NSString *);
@property(nonatomic) NSArray *requireNetworkStatus;

- (void)start;

- (void)cancel;


@end