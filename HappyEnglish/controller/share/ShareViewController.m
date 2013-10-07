//
// Created by @krq_tiger on 13-8-6.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ShareViewController.h"
#import "Global.h"
#import "OneDayInfo.h"
#import "OneDayInfo+SNSShareCategory.h"


@implementation ShareViewController {

}

- (void)loadView {
    [super loadView];
    float btnWidth = 39;
    float btnHeight = 32;
    UIImageView *navBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navBarView.image = [UIImage imageNamed:@"nav_bar_background_img.png"];
    navBarView.userInteractionEnabled = YES;
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(MARGIN, (44 - btnHeight) / 2, 51, btnHeight)];
    [backBtn setImage:[UIImage imageNamed:@"nav-bar-back-button.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - btnWidth - MARGIN, (44 - btnHeight) / 2, btnWidth, btnHeight)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"popView_doneBtn@2x.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.text = self.title;
    titleView.textAlignment = UITextAlignmentCenter;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.center = navBarView.center;
    [navBarView addSubview:shareBtn];
    [navBarView addSubview:backBtn];
    [navBarView addSubview:titleView];
    [self.view addSubview:navBarView];
    _shareInfoView = [[UITextView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 150)];
    _shareInfoView.text = [self.episode shareInfo];
    _shareInfoView.font = CHINESE_TEXT_FONT;
    [self.view addSubview:_shareInfoView];
    _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, _shareInfoView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - _shareInfoView.frame.size.height)];
    _toolbarView.backgroundColor = [UIColor grayColor];
    _tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100 - MARGIN, 0, 100, 40)];
    _tipsLabel.backgroundColor = [UIColor clearColor];
    _tipsLabel.font = CHINESE_TEXT_FONT;
    [_toolbarView addSubview:_tipsLabel];
    [self.view addSubview:_toolbarView];
    [_shareInfoView becomeFirstResponder];
    _shareInfoView.delegate = self;
    [self textViewDidChange:_shareInfoView];
}

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUrl:) name:NOTIFICATION_FOR_HANDLE_URL object:nil];
    [self registerKeyboardNotification];
}


- (void)share {
}

- (void)handleUrl:(NSNotification *)notification {

}


- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate -
- (void)textViewDidChange:(UITextView *)textView {
    int availableLength = 140 - textView.text.length;
    //NSLog(@"%d", textView.text.length);
    if (availableLength <= 0) {
        availableLength = 0;
        //_shareInfoView.text = [_shareInfoView.text substringToIndex:140];
    }
    _tipsLabel.text = [NSString stringWithFormat:@"剩余%d个字", availableLength];
}


#pragma mark - keyboard notification -
- (void)registerKeyboardNotification {
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif

}

- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];

    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    float shareInfoViewHeight = self.view.frame.size.height - NAV_BAR_HEIGHT - keyboardRect.size.height - TOOL_BAR_HEIGHT;
    [UIView animateWithDuration:animationDuration animations:^{
        _shareInfoView.frame = CGRectMake(_shareInfoView.frame.origin.x,
                _shareInfoView.frame.origin.y,
                _shareInfoView.frame.size.width,
                shareInfoViewHeight);

        _toolbarView.frame = CGRectMake(_toolbarView.frame.origin.x,
                shareInfoViewHeight + NAV_BAR_HEIGHT, _toolbarView.frame.size.width,
                TOOL_BAR_HEIGHT);

    }];


}

@end