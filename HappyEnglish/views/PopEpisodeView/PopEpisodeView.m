//
// Created by tiger on 13-5-17.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MultiPlayerSettingView.h"
#import "PopEpisodeView.h"
#import "TitleView.h"
#import "TextView.h"
#import "PlayerControlView.h"
#import "MultiPlayerSettingViewController.h"


@implementation PopEpisodeView {
    TitleView *_titleView;
    TextView *_textView;
    PlayerControlView *_controlView;

    MultiPlayerSettingView *_settingView;
    MultiPlayerSettingViewController *_settingController;


}

- (void)drawaRect:(CGRect)rect {
    CGRect bgRect = CGRectInset(_contentView.frame, 1, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 10., [UIColor brownColor].CGColor);
    [[UIColor brownColor] setFill];

    float x = bgRect.origin.x;
    float y = bgRect.origin.y;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, y);
    CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, 0);
    CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, 0);
    CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
    CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
    CGPathCloseSubpath(path);
    CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);


}

#pragma mark - override super method -

- (UIView *)createContentView:(CGRect)frame popDirection:(PopDirection)popDirection {
    OneDayInfo *oneDayInfo;
    if (popDirection == JUST_POP) {
        oneDayInfo = (OneDayInfo *) [self.dataSource getData];
    } else {
        NSArray *episodes = (NSArray *) self.dataSource.getData;
        if (episodes.count > 0) {
            oneDayInfo = episodes[0];
        } else {
            oneDayInfo = nil;
        }
    }
    float y = 0;
    int titleHeight = 45;
    BOOL isMulti = popDirection != JUST_POP;
    [(id <PopEpisodeViewDelegate>) self.delegate setMultiEpisode:isMulti];
    _titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, titleHeight) andEpisode:oneDayInfo andDelegate:(id <PopEpisodeViewDelegate>) self.delegate isMulti:isMulti];
    y = y + _titleView.frame.size.height;

    _textView = [[TextView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, TEXT_PANEL_HEIGHT) andEpisode:oneDayInfo andDelegate:(id <PopEpisodeViewDelegate>) self.delegate isMulti:isMulti];

    y = y + _textView.frame.size.height;
    _controlView = [[PlayerControlView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 120) andEpisode:oneDayInfo andDelegate:(id <PopEpisodeViewDelegate>) self.delegate isMulti:isMulti];
    y = y + _controlView.frame.size.height;

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, y)];
    [contentView addSubview:_titleView];
    [contentView addSubview:_textView];
    [contentView addSubview:_controlView];
    [contentView bringSubviewToFront:_textView];
    return contentView;
}


- (void)updateViewToDownloadedState {
    [_textView changeToDownloadedState];
}

- (void)updateSliderProgressAndTips:(float)progress leftTips:(NSString *)leftTips rightTips:(NSString *)rightTips {
    [_controlView updateSliderProgressAndTips:progress leftTips:leftTips rightTips:rightTips];
}


- (void)showWordPanel:(Word *)word {
    [_textView showWordPanel:word];
}

- (void)updateViewToAudioStoppedState {
    [_controlView updateViewToAudioStoppedState];
}

- (void)updateViewToAudioPausedState {
    [_controlView updateViewToAudioPausedState];
}

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)oneDayInfo isMultiEpisode:(BOOL)isMultiEpisode {
    [_controlView updateViewToAudioStartedState:audioType episode:oneDayInfo isMultiEpisode:isMultiEpisode];
    [_textView updateViewToAudioStartedState:audioType episode:oneDayInfo isMultiEpisode:isMultiEpisode];
    [_titleView updateViewToAudioStartedState:audioType episode:oneDayInfo isMultiEpisode:isMultiEpisode];
}

- (void)settingToSingleEpisodePlayer {
    [_controlView settingToSingleEpisodePlayer];
    [_textView settingToSingleEpisodePlayer];
    //[_titleView settingToSingleEpisodePlayer];
}

- (void)settingToMultiEpisodePlayer {
    [_controlView settingToMultiEpisodePlayer];
    [_textView settingToMultiEpisodePlayer];
    //[_titleView settingToMultiEpisodePlayer];
}


- (void)settingMultiPlayer {
    //NSLog(@"setting btn clicked");
    _settingController = [[MultiPlayerSettingViewController alloc] init];
    _settingView = [[MultiPlayerSettingView alloc] initWithFrame:_contentView.frame andDelegate:_settingController];
    _settingController.settingView = _settingView;
    [UIView transitionFromView:_contentView
                        toView:_settingView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                    }];
}

- (void)settingMultiPlayerDone:(BOOL)settingChanged {
    //NSLog(@"setting done btn clicked");
    [UIView transitionFromView:_settingView
                        toView:_contentView
                      duration:1
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        if (finished) {
                            _settingView = nil;
                            _settingController = nil;
                            if (settingChanged) {
                                [(id <PopEpisodeViewDelegate>) self.delegate settingToMultiEpisodePlayer];
                            }
                        }
                    }];
    [((id <PopEpisodeViewDelegate>) (self.delegate)) settingMultiPlayerDone:settingChanged];
}


#pragma mark - implement UIGestureDelegate -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (BOOL)shouldHidePopViewInCurrentTouch:(UITouch *)touch {
    return ![_settingView pointInside:[touch locationInView:_settingView] withEvent:nil];
}

@end