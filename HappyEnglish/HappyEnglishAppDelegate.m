//
//  HappyEnglishAppDelegate.m
//  HappyEnglish
//
//  Created by tiger on 05/07/13.
//  Copyright (c) 2013 kariqu. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HappyEnglishAppDelegate.h"
#import "Global.h"
#import "MTStatusBarOverlay.h"
#import "RootContainerController.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "JSONParser.h"
#import "Crashlytics/Crashlytics.h"
#import "MobClick.h"
#import "NSDate+Helper.h"
#import "WXApi.h"
#import "ShareViewController.h"

@implementation UINavigationController (
private)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end

@implementation HappyEnglishAppDelegate {
    Reachability *_reachability;
    MBProgressHUD *HUD;
    HttpClient *_httpClient;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        [self handleNotification:localNotif];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [MobClick startWithAppkey:@"51f1074456240b308e019e06"];//reportPolicy:SEND_ON_EXIT channelId:nil];
    CGRect frame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:frame];
    RootContainerController *rootController = [[RootContainerController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:rootController selector:@selector(shouldUpdate) name:@"appVersionUpdateKey" object:nil];
    self.window.rootViewController = rootController;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    [self setupAudioPlayBackground];
    [self initMTStatusBarOverlay];
    [self.window makeKeyAndVisible];
    NSLog(@"%@", AUDIO_CACHE_FOLDER);
    _latestVersion = ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]);
    NSDictionary *queryDict = [[NSDictionary alloc] initWithObjectsAndKeys:_latestVersion, @"v", nil];
    _httpClient = [[HttpClient alloc] initWithRequestUrl:VERSION_CHECK andQueryStringDictionary:queryDict useCache:NO delegate:self];
    [_httpClient doRequestAsynchronous];
    [self setNetworkReachability];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_background_img.png"] forBarMetrics:UIBarMetricsDefault];
    //instrumentObjcMessageSends(YES);
    //[self printFontAndFamilyName];
    [Crashlytics startWithAPIKey:@"a424bb43061a08c5a583bcd71144d3acc5318370"];
    [WXApi registerApp:WX_AppID];
    return YES;
}

- (void)printFontAndFamilyName {
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];

    NSArray *fontNames;

    NSInteger indFamily, indFont;

    for (indFamily = 0; indFamily < [familyNames count]; ++indFamily) {

        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);

        fontNames = [[NSArray alloc] initWithArray:

                [UIFont fontNamesForFamilyName:

                        [familyNames objectAtIndex:indFamily]]];

        for (indFont = 0; indFont < [fontNames count]; ++indFont) {

            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);

        }


    }

}


- (void)setupAudioPlayBackground {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];//实现后台循环播放
}

- (void)initMTStatusBarOverlay {
    _overlay = [MTStatusBarOverlay sharedInstance];
    _overlay.animation = MTStatusBarOverlayAnimationNone;  // MTStatusBarOverlayAnimationShrink
    _overlay.detailViewMode = MTDetailViewModeDetailText;         // enable automatic history-tracking and show in detail-view

}

+ (HappyEnglishAppDelegate *)sharedAppDelegate {
    return (HappyEnglishAppDelegate *) [UIApplication sharedApplication].delegate;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.


}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FOR_HANDLE_URL object:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FOR_HANDLE_URL object:url];
    return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //NSLog(@"applicationWillTerminate");

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"receive local notification active state");
        [self handleNotification:notification];
    } else {
        NSLog(@"receive local notification inactive state");
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)handleNotification:(UILocalNotification *)notification {
    UILocalNotification *nextNotification = notification;
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    if (nextNotification.repeatInterval == NSWeekCalendarUnit) {
        NSDate *date = notification.fireDate;
        NSDate *nextDate = [date dateAfterDay:7];
        nextNotification.fireDate = nextDate;
        [[UIApplication sharedApplication] scheduleLocalNotification:nextNotification];
    }
}


- (void)setNetworkReachability {
    //起动网络状态监视
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [_reachability startNotifier];

}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *curReach = [notification object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    _networkStatus = status;
}


- (void)showOverlayProgressInformation:(NSString *)info duration:(NSTimeInterval)duration {
    if (duration == -1) {
        [_overlay postImmediateMessage:info animated:YES];

    } else {
        [_overlay postMessage:info duration:duration animated:YES];
        _overlay.progress = 0.5;
    }
}

- (void)showOverlayErrorInformation:(NSString *)info duration:(NSTimeInterval)duration {
    [_overlay postImmediateErrorMessage:info duration:duration animated:YES];
}

- (void)showOverlayFinishedInformation:(NSString *)info duration:(NSTimeInterval)duration {
    [_overlay postImmediateFinishMessage:info duration:duration animated:YES];
}

- (void)showHUDTextOnlyInfo:(NSString *)info duration:(NSTimeInterval)duration {
    if (HUD) {
        [HUD removeFromSuperview];
    }
    UIView *view = [[HappyEnglishAppDelegate sharedAppDelegate] window];
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:view];
    }
    HUD.labelText = info;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelFont = TIPS_TEXT_FONT;
    HUD.margin = 15;
    HUD.yOffset = 0;
    [view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:duration];
}


- (void)showHUDImageViewInfo:(UIImage *)tipsImage tipsText:(NSString *)tipsText duration:(NSTimeInterval)duration {
    if (HUD) {
        [HUD removeFromSuperview];
        HUD = nil;
    }

    UIView *view = self.window;
    HUD = [[MBProgressHUD alloc] initWithView:view];
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *tipsImageView;
    tipsImageView = [[UIImageView alloc] initWithImage:tipsImage];
    tipsImageView.center = tipsView.center;
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(-15, 30, 70, 20)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.font = [UIFont systemFontOfSize:11];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.text = tipsText;
    HUD.labelText = tipsText;
    HUD.labelFont = TIPS_TEXT_FONT;
    HUD.customView = tipsImageView;;
    HUD.mode = MBProgressHUDModeCustomView;
    [view addSubview:HUD];
    [HUD show:YES];
    [HUD hide:YES afterDelay:duration];
}

#pragma mark - SinaWeiboRequest Delegate -
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    if (error) {
        NSLog(@"didFailWithError %@", error);
    }
    [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayProgressInformation:@"发表新浪微博失败!" duration:2];

}


- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"didFinishLoadingWithResult");
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *directory = result;
        NSString *errorCode = [[directory objectForKey:@"error_code"] stringValue];
        if (errorCode) {
            NSLog(@"errorcode=%@", errorCode);
            NSLog(@"error=%@", [directory objectForKey:@"error"]);
            if ([errorCode isEqualToString:@"21332"]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSinaWeiboAuthData];
                [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayProgressInformation:@"新浪微博会话过期，请重新绑定!" duration:2];
                return;
            }
            [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayProgressInformation:@"新浪微博发表失败!" duration:2];
            return;
        }
    }
    [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayProgressInformation:@"新浪微博发表成功!" duration:2];
}

#pragma mark  - HttpClientDelegate -
- (void)httpClient:(HttpClient *)httpClient withRequestedData:(NSData *)data {
    NSDictionary *versionInfo = [JSONParser parseVersionInfo:data];
    if (!versionInfo) {
        [self httpClient:nil withError:nil];
        return;
    }
    _latestVersion = [versionInfo objectForKey:@"version"];
    _shouldUpdate = [[versionInfo objectForKey:@"isUpdate"] boolValue];
    if (_shouldUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"appVersionUpdateKey" object:nil];
    }
    _httpClient = nil;
}

- (void)httpClient:(HttpClient *)httpClient withError:(NSError *)error {
    _shouldUpdate = NO;
    _httpClient = nil;
}

- (void)dealloc {
    [_httpClient cancel];
    _httpClient = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end