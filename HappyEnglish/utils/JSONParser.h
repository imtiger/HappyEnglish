//
// Created by @krq_tiger on 13-5-23.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface JSONParser : NSObject

+ (NSArray *)parseOneDayInfos:(NSData *)jsonData;


+ (NSDictionary *)parseVersionInfo:(NSData *)versionData;
@end