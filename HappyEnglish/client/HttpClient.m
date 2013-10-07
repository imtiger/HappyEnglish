//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "HttpClient.h"
#import "ASICacheDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"


@implementation HttpClient {
    NSDictionary *_queryStringDict;
    id <HttpClientDelegate> _delegate;
    BOOL _cancel;
    ASIHTTPRequest *_asiRequest;
}

- (id)initWithRequestUrl:(NSString *)requestUrl andQueryStringDictionary:(NSDictionary *)dictionary useCache:(BOOL)useCache delegate:(id <HttpClientDelegate>)delegate {
    self = [super init];
    if (self) {
        _requestUrl = requestUrl;
        _queryStringDict = dictionary;
        _delegate = delegate;
        _useCache = useCache;
    }
    return self;
}


- (void)doRequestAsynchronous {
    [self initAsiRequest];
    [_asiRequest startAsynchronous];

}

- (void)initAsiRequest {
    NSMutableString *requestUrl = [[NSMutableString alloc] initWithString:_requestUrl];
    ASICachePolicy policy = _useCache ? ASIOnlyLoadIfNotCachedCachePolicy
            : (ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy);
    if (_queryStringDict) {
        NSArray *keys = [_queryStringDict allKeys];

        for (int i = 0; i < [keys count]; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *value = [_queryStringDict objectForKey:key];
            if ([key length] == 0 || [value length] == 0) {
                continue;
            }
            [requestUrl appendString:i == 0 ? @"?" : @"&"];
            [requestUrl appendFormat:@"%@=%@", key, value];
        }
    }
    NSLog(@"request url=%@", requestUrl);
    _asiRequest = [ASIHTTPRequest requestWithURL:
            [NSURL URLWithString:[requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

    [_asiRequest setDownloadCache:[ASIDownloadCache sharedCache]];
    [_asiRequest setCachePolicy:policy];
    [_asiRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [_asiRequest setDelegate:self];
}

- (NSData *)doRequestSynchronous:(NSError **)error {
    [self initAsiRequest];
    [_asiRequest startSynchronous];
    NSError *requestError = [_asiRequest error];
    if (requestError) {
        *error = requestError;
        return nil;
    } else {
        return [_asiRequest responseData];
    }
}

- (void)removeCurrentRequestCache {
    if (_useCache) {
        [[ASIDownloadCache sharedCache] removeCachedDataForURL:[NSURL URLWithString:_requestUrl]];
    }
}


- (void)cancel {
    _cancel = YES;
    [_asiRequest clearDelegatesAndCancel];
    _delegate = nil;
}


- (void)requestFinished:(ASIHTTPRequest *)request {
    int code = request.responseStatusCode;
    //NSLog(@"headers=%@", request.responseHeaders);
    //NSLog(@"code=%d", code);
    NSString *stringCode = [NSString stringWithFormat:@"%d", code];
    if (![stringCode isEqualToString:@"200"]) { //response code is not equal 200
        if (!_cancel && _delegate && [_delegate respondsToSelector:@selector(httpClient:withError:)]) {
            NSError *error = [NSError errorWithDomain:@"HttpClientDomain" code:code userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"http request failure,response code=%d", code], NSLocalizedDescriptionKey, nil]];
            [_delegate httpClient:self withError:error];
        }
        return;
    }
    NSData *data = [request responseData];
    if (!_cancel && _delegate && [_delegate respondsToSelector:@selector(httpClient:withRequestedData:)])
        [_delegate httpClient:self withRequestedData:data];
    if ([request didUseCachedResponse]) {
        NSString *filePath = [[ASIDownloadCache sharedCache] pathToStoreCachedResponseDataForRequest:request];
        //NSLog(@"filePath=%@", filePath);
        //NSLog(@"asi date=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    else {
        //NSLog(@"asi date=%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }

}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = [request error];
    if (!_cancel && _delegate && [_delegate respondsToSelector:@selector(httpClient:withError:)])
        [_delegate httpClient:self withError:error];
}

@end