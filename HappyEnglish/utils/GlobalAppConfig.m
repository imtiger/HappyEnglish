//
// Created by @krq_tiger on 13-6-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GlobalAppConfig.h"
#import "Global.h"


@implementation GlobalAppConfig {

    NSMutableDictionary *_configDict;

}

- (id)init {
    self = [super init];
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
    if (self) {
        if (!fileExistsAtPath(AppConfigPathInSandBox)) {
            if (![[NSFileManager defaultManager] copyItemAtPath:configPath toPath:AppConfigPathInSandBox error:nil]) {
                //TODO
            }
            _configDict = [[NSMutableDictionary alloc] initWithContentsOfFile:AppConfigPathInSandBox];
        } else {
            NSMutableDictionary *appConfigInSandbox = [[NSMutableDictionary alloc] initWithContentsOfFile:AppConfigPathInSandBox];
            NSMutableDictionary *appConfigInBundle = [[NSMutableDictionary alloc] initWithContentsOfFile:configPath];
            for (NSString *key in appConfigInBundle.allKeys) {
                if (![appConfigInSandbox objectForKey:key]) {
                    [appConfigInSandbox setObject:[appConfigInBundle objectForKey:key] forKey:key];
                }
            }
            [appConfigInSandbox writeToFile:AppConfigPathInSandBox atomically:YES];
            _configDict = appConfigInSandbox;
        }
    }
    return self;
}

+ (GlobalAppConfig *)sharedInstance {
    static GlobalAppConfig *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalAppConfig alloc] init];
    });
    return sharedInstance;
}

- (id)valueForKey:(NSString *)key {
    id value = [_configDict objectForKey:key];
    if (!value) {
        //[NSException raise:NSGenericException format:@"No value found for config key: %@", key]; TODO
    }
    return value;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (!key || [key isEqualToString:@""]) {
        return;
    }
    [_configDict setValue:value forKey:key];
    [_configDict writeToFile:AppConfigPathInSandBox atomically:YES];
}


- (UIFont *)getSourceLanguageFont:(CGFloat)fontSize {
    return [UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:fontSize];
    //return [UIFont systemFontOfSize:fontSize];
}

- (UIFont *)getDestinationLanguageFont:(CGFloat)fontSize {
    return [UIFont fontWithName:DESTINATION_LANGUAGE_FONT_NAME size:fontSize];
    //return [UIFont systemFontOfSize:fontSize];

}

@end