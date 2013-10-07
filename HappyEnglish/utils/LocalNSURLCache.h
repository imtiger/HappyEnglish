//
// Created by @krq_tiger on 13-6-27.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface LocalNSURLCache : NSURLCache {
    NSMutableDictionary *cachedResponses;
}
@end