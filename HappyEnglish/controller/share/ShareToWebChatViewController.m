//
// Created by @krq_tiger on 13-8-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShareToWebChatViewController.h"
#import "HappyEnglishAppDelegate.h"
#import "OneDayInfo.h"
#import "OneDayInfo+SNSShareCategory.h"


@implementation ShareToWebChatViewController {

}


- (id)initWithEpisode:(OneDayInfo *)episode scene:(enum WXScene)scene title:(NSString *)title {
    self = [super init];
    if (self) {
        self.episode = episode;
        self.scene = scene;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)handleUrl:(NSNotification *)notification {
    NSURL *url = (NSURL *) [notification object];
    if ([url.scheme isEqualToString:WX_AppID]) {
        [WXApi handleOpenURL:url delegate:self];
    }
}


#pragma mark - WXApiDelegate -
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (resp.errCode == 0) {
            NSLog(@"分享微信成功");
            [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"分享微信成功!" duration:2];
        } else {
            NSLog(@"分享微信失败");
            [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"分享微信失败!" duration:2];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)share {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = _shareInfoView.text;
    req.scene = self.scene;
    [WXApi sendReq:req];
}

@end