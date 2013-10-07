//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@class HttpClient;

@protocol HttpClientDelegate <NSObject>
- (void)httpClient:(HttpClient *)httpClient withRequestedData:(NSData *)data;

- (void)httpClient:(HttpClient *)httpClient withError:(NSError *)error;
@end

typedef enum {
    image,
    data
} HttpClientMIMEType;

@interface HttpClient : NSObject <ASIHTTPRequestDelegate>

@property(nonatomic, strong, readonly) NSString *requestUrl;
@property(nonatomic) HttpClientMIMEType mimeType;
@property(nonatomic) BOOL useCache;


- (id)initWithRequestUrl:(NSString *)requestUrl andQueryStringDictionary:(NSDictionary *)dictionary useCache:(BOOL)useCache delegate:(id <HttpClientDelegate>)delegate;

- (void)doRequestAsynchronous;

- (NSData *)doRequestSynchronous:(NSError **)error;

- (void)cancel;

- (void)removeCurrentRequestCache;
@end