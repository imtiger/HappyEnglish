//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface Word : NSObject

@property(nonatomic, strong) NSString *source;
@property(nonatomic, strong) NSString *phoneticSymbol;
@property(nonatomic, strong) NSString *pronunciationUrl;
@property(nonatomic, strong) NSMutableArray *wordMeanings;

- (NSString *)meaning;

- (void)addMeaning:(NSMutableDictionary *)dictionary;

-(BOOL)pronounceAudioOffline;

- (NSString *)pronounceAudioPath;

@end