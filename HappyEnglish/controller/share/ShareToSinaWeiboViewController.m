//
// Created by @krq_tiger on 13-8-8.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShareToSinaWeiboViewController.h"
#import "HappyEnglishAppDelegate.h"


@implementation ShareToSinaWeiboViewController {

    SinaWeibo *sinaWeibo;
}

- (id)initWithEpisode:(OneDayInfo *)episode  title:(NSString *)title {
    self = [super init];
    if (self) {
        self.episode = episode;
        self.title = title;
        [self initSinaweiboManager];
    }
    return self;
}


- (void)initSinaweiboManager {
    sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kSinaWeiboAppKey
                                        appSecret:kSinaWeiboAppSecret
                                   appRedirectURI:kSinaWeiboAppRedirectURI
                                      andDelegate:self];
    sinaWeibo.ssoCallbackScheme = SINA_WEIBO_URL_OF_SCHEMA;
    NSDictionary *sinaweiboInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kSinaWeiboAuthData];
    if (sinaweiboInfo[@"AccessTokenKey"] && sinaweiboInfo[@"ExpirationDateKey"]
            && sinaweiboInfo[@"UserIDKey"]) {
        sinaWeibo.accessToken = sinaweiboInfo[@"AccessTokenKey"];
        sinaWeibo.expirationDate = sinaweiboInfo[@"ExpirationDateKey"];
        sinaWeibo.userID = sinaweiboInfo[@"UserIDKey"];

    }
}


- (void)handleUrl:(NSNotification *)notification {
    NSURL *url = (NSURL *) [notification object];
    if ([url.scheme isEqualToString:SINA_WEIBO_URL_OF_SCHEMA]) {
        [sinaWeibo handleOpenURL:url];
    }
}

- (void)share {
    [super share];
    if (![sinaWeibo isAuthValid]) {
        [sinaWeibo logIn];
        return;
    }
    [self doShare];
}

- (void)doShare {
    [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayProgressInformation:@"正分享到新浪微博..." duration:-1];
    NSMutableDictionary *requestParms = [NSMutableDictionary dictionary];
    requestParms[@"status"] = _shareInfoView.text;
    requestParms[@"access_token"] = sinaWeibo.accessToken;
    NSLog(@"text=%@", _shareInfoView.text);
    [sinaWeibo requestWithURL:API_statuses_update
                       params:requestParms
                   httpMethod:HTTP_METHOD_POST
                     delegate:[HappyEnglishAppDelegate sharedAppDelegate]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SinaWeiboDelegate Delegate -
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo {
    NSDictionary *authInfo = @{
            @"AccessTokenKey" : sinaweibo.accessToken,
            @"ExpirationDateKey" : sinaweibo.expirationDate,
            @"UserIDKey" : sinaweibo.userID,
            @"refresh_token" : sinaweibo.refreshToken == nil ? @"" : sinaweibo.refreshToken
    };
    [[NSUserDefaults standardUserDefaults] setObject:authInfo forKey:kSinaWeiboAuthData];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self doShare];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSinaWeiboAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo {

}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error {
    NSLog(@"logInDidFailWithError %@", error);
    if (error) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:[error localizedDescription] duration:2];
    }
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error {
    NSLog(@"accessTokenInvalidOrExpired %@", error);
    if (error) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:[error localizedDescription] duration:2];
    }
}


@end