//
// Created by @krq_tiger on 13-6-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class OneDayInfo;

@interface OneDayInfoRepository : NSObject

+ (OneDayInfoRepository *)sharedInstance;

- (NSInteger)createOneDayInfo:(OneDayInfo *)oneDayInfo;

- (OneDayInfo *)getOneDayInfoById:(NSInteger)id;

- (NSMutableArray *)getEpisodesWithBeginDate:(NSDate *)beginDate andEndDate:(NSDate *)endDate;

- (NSMutableArray *)getEpisodesWithStartAndEndNumber:(int)startNumber endNumber:(int)endNumber;

- (NSMutableArray *)getEpisodesWithBeginIndex:(int)beginIndex andPageSize:(int)pageSize;

- (NSMutableArray *)getFavoriteEpisodesWithBeginIndex:(int)beginIndex andPageSize:(int)pageSize;

- (NSMutableArray *)getAllFavoriteEpisodes;

- (void)updateOneDayInfo:(OneDayInfo *)oneDayInfo;

- (BOOL)isFavorite:(OneDayInfo *)oneDayInfo;

- (NSMutableArray *)getEpisodesBetween:(int)startNumber andEndNumber:(int)endNumber;
@end