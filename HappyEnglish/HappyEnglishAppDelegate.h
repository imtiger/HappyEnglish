//
//  HappyEnglishAppDelegate.h
//  HappyEnglish
//
//  Created by @krq_tiger on 05/07/13.
//  Copyright (c) 2013 @krq_tiger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "HttpClient.h"
#import "SinaWeiboRequest.h"

@class MTStatusBarOverlay;

@interface HappyEnglishAppDelegate : UIResponder <UIApplicationDelegate, HttpClientDelegate, SinaWeiboRequestDelegate> {
}

@property(strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) MTStatusBarOverlay *overlay;
@property(nonatomic) NetworkStatus networkStatus;
@property(nonatomic, readonly) BOOL shouldUpdate;
@property(nonatomic, readonly) NSString *latestVersion;


+ (HappyEnglishAppDelegate *)sharedAppDelegate;


- (void)showOverlayProgressInformation:(NSString *)info duration:(NSTimeInterval)duration;

- (void)showOverlayErrorInformation:(NSString *)info duration:(NSTimeInterval)duration;

- (void)showOverlayFinishedInformation:(NSString *)info duration:(NSTimeInterval)duration;

- (void)showHUDTextOnlyInfo:(NSString *)info duration:(NSTimeInterval)duration;

- (void)showHUDImageViewInfo:(UIImage *)tipsImage tipsText:(NSString *)tipsText duration:(NSTimeInterval)duration;

@end