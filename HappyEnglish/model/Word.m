//
// Created by @krq_tiger on 13-5-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Word.h"
#import "Global.h"
#import "StringUtils.h"


@implementation Word {

}
- (NSString *)meaning {
    if (self.wordMeanings && [self.wordMeanings count] > 0) {
        NSMutableDictionary *meaning = [self.wordMeanings objectAtIndex:0];
        return [meaning valueForKey:@"acceptaion"];
    }
    return nil;
}

- (void)addMeaning:(NSMutableDictionary *)meaning {
    if (!_wordMeanings) {
        _wordMeanings = [[NSMutableArray alloc] init];
    }
    [_wordMeanings addObject:meaning];

}

- (BOOL)pronounceAudioOffline {
    NSString *fileName = [[StringUtils md5:self.pronunciationUrl] stringByAppendingString:AUDIO_SUFFIX];
    return [[NSFileManager defaultManager] fileExistsAtPath:[WORD_AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName]];
}


- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.source];
    [description appendFormat:@"phoneticSymbol=%@", self.phoneticSymbol];
    [description appendFormat:@"pronunciationUrl=%@", self.pronunciationUrl];
    for (NSMutableDictionary *meaning in  self.wordMeanings) {
        [description appendFormat:@"pos=%@", [meaning valueForKey:@"pos"]];
        [description appendFormat:@"acceptaion=%@", [meaning valueForKey:@"acceptaion"]];
    }
    [description appendString:@">"];
    return description;
}


- (NSString *)pronounceAudioPath {
    NSString *fileName = [[StringUtils md5:self.pronunciationUrl] stringByAppendingString:AUDIO_SUFFIX];
    return [WORD_AUDIO_CACHE_FOLDER stringByAppendingPathComponent:fileName];
}
@end