//
// Created by @krq_tiger on 13-6-27.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LocalNSURLCache.h"
#import "StringUtils.h"
#import "Global.h"


@implementation LocalNSURLCache {

}

+ (NSString *)pathForURL:(NSString *)url {
    NSString *localFilePath = [LocalNSURLCache getFileSuffix:url];
    localFilePath = [NSString stringWithFormat:@"%@%@", [StringUtils md5:url], localFilePath];
    localFilePath = [REMOTE_FILE_CACHE_FOLDER stringByAppendingPathComponent:localFilePath];
    return localFilePath;
}

- (NSString *)localFilePath:(NSString *)path {
    NSString *localFilePath = [LocalNSURLCache getFileSuffix:path];
    localFilePath = [NSString stringWithFormat:@"%@%@", [StringUtils md5:path], localFilePath];
    localFilePath = [REMOTE_FILE_CACHE_FOLDER stringByAppendingPathComponent:localFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFilePath])
        return localFilePath;
    return nil;
}

- (NSString *)mimeTypeForPath:(NSString *)originalPath {
    return @"image/jpg";
}

- (void)writeToFile:(NSData *)data filePath:(NSString *)filePath {
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        return;

    if (![[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil]) {
        NSLog(@"Error was code: %d - message: %s", errno, strerror(errno));
    }

}

- (BOOL)willCacheFile:(NSString *)filePath {
    if ([[filePath lowercaseString] hasSuffix:@".png"] ||
            [[filePath lowercaseString] hasSuffix:@".jpg"] ||
            [[filePath lowercaseString] hasSuffix:@".gif"] ||
            [[filePath lowercaseString] hasSuffix:@".jpeg"])
        return YES;

    return NO;
}

+ (NSString *)getFileSuffix:(NSString *)filePath {
    if ([[filePath lowercaseString] hasSuffix:@".jpg"])
        return @".jpg";

    if ([[filePath lowercaseString] hasSuffix:@".png"])
        return @".png";

    if ([[filePath lowercaseString] hasSuffix:@".gif"])
        return @".gif";

    if ([[filePath lowercaseString] hasSuffix:@".jpeg"])
        return @".jpeg";

    return @"";
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse forRequest:(NSURLRequest *)request {
    if ([cachedResponse.data length] == 0)
        return;

    if (![self willCacheFile:request.URL.absoluteString])
        return;
    NSString *localFilePath = [LocalNSURLCache pathForURL:request.URL.absoluteString];
    [self writeToFile:cachedResponse.data filePath:localFilePath];
}

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSString *pathString = [[request URL] absoluteString];

    NSString *localFilePath = [self localFilePath:pathString];
    if (!localFilePath) {
        return [super cachedResponseForRequest:request];
    }
    NSCachedURLResponse *cachedResponse = [cachedResponses objectForKey:pathString];
    if (cachedResponse) {
        return cachedResponse;
    }
    NSData *data = [NSData dataWithContentsOfFile:localFilePath];

    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL]
                                                        MIMEType:[self mimeTypeForPath:pathString]
                                           expectedContentLength:[data length]
                                                textEncodingName:nil];

    cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];

    if (!cachedResponses) {
        cachedResponses = [[NSMutableDictionary alloc] init];
    }
    [cachedResponses setObject:cachedResponse forKey:pathString];

    return cachedResponse;
}

- (void)removeCachedResponseForRequest:(NSURLRequest *)request {
    NSString *pathString = [[request URL] path];
    if ([cachedResponses objectForKey:pathString]) {
        [cachedResponses removeObjectForKey:pathString];
    }
    else {
        [super removeCachedResponseForRequest:request];
    }
}

- (void)dealloc {
    cachedResponses = nil;
}
@end