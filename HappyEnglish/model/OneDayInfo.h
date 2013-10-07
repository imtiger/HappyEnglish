//
// Created by @krq_tiger on 13-5-9.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef enum {
    Detail = 0,
    Normal = 1,
    Slow = 2,
    UnKnow = 3
} AudioType;

@interface OneDayInfo : NSObject

@property(nonatomic, copy) NSString *chineseText;
@property(nonatomic, copy) NSString *englishText;

@property(nonatomic, copy) NSString *detailAudioUrl;
@property(nonatomic, copy) NSString *normalAudioUrl;
@property(nonatomic, copy) NSString *slowAudioUrl;
@property(nonatomic, strong) NSDate *createDate;
@property(nonatomic) NSInteger issueNumber;
@property(nonatomic) NSInteger id;
@property(nonatomic) BOOL isFavorite;


- (id)initWithDirectory:(NSDictionary *)dictionary;

- (BOOL)hasAllOffline;

- (BOOL)hasOffline:(AudioType)audioType;
@end