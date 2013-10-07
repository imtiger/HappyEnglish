//
// Created by @krq_tiger on 13-6-13.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RootContainerController.h"
#import "MainViewController.h"
#import "Global.h"
#import "FavoriteViewController.h"
#import "SettingRootController.h"
#import "OneDayInfo.h"
#import "CommonWebController.h"


@implementation RootContainerController {
    MainViewController *_mainViewController;
    FavoriteViewController *_favViewController;
    UIView *_contentView;
    UIViewController *_currentViewController;
    UIButton *_navMainBtn;
    UIButton *_navFavoriteBtn;
    UIImageView *_starImg;
    NSMutableArray *_starImgs;
    UIImageView *_toolbarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _toolbarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    _toolbarView.image = [UIImage imageNamed:@"nav_bar_background_img.png"];
    float navBtnWith = 55;
    float navBtnHeight = 32;
    _navMainBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - navBtnWith, (_toolbarView.frame.size.height - navBtnHeight) / 2, navBtnWith, navBtnHeight)];
    [_navMainBtn setBackgroundImage:[UIImage imageNamed:@"nav_main_selected.png"] forState:UIControlStateNormal];
    [_navMainBtn addTarget:self action:@selector(switchController:) forControlEvents:UIControlEventTouchUpInside];
    navBtnWith = 55;
    _navFavoriteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x, (_toolbarView.frame.size.height - navBtnHeight) / 2, navBtnWith, navBtnHeight)];
    [_navFavoriteBtn setBackgroundImage:[UIImage imageNamed:@"nav_favorite.png"] forState:UIControlStateNormal];
    [_navFavoriteBtn addTarget:self action:@selector(switchController:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:_navMainBtn];
    [_toolbarView addSubview:_navFavoriteBtn];
    [_toolbarView addSubview:_starImg];
    float btnWidth = 39;
    float btnHeight = 32;
    UIButton *settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - btnWidth - 3 * MARGIN, (45 - btnHeight) / 2, btnWidth, btnHeight)];
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"popView_settingBtn.png"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingApp) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarView addSubview:settingBtn];
    _toolbarView.userInteractionEnabled = YES;
    [self.view addSubview:_toolbarView];
    CGRect tableFrame = self.view.bounds;
    tableFrame.size.height = tableFrame.size.height - 45;
    _mainViewController = [[MainViewController alloc] initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableFrame];
    _favViewController = [[FavoriteViewController alloc] initWithRefreshHeaderViewEnabled:YES andLoadMoreFooterViewEnabled:YES andTableViewFrame:tableFrame];
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    [_contentView addSubview:_mainViewController.view];
    _currentViewController = _mainViewController;
    [self addChildViewController:_mainViewController];
    [self addChildViewController:_favViewController];
    [self.view addSubview:_contentView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doFavorite:)
                                                 name:DO_FAVORITE_KEY
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doTranslate:)
                                                 name:DO_TRANSLATE_KEY
                                               object:nil];

}

- (void)doTranslate:(NSNotification *)notification {
    NSString *word = notification.object;
    CommonWebController *settingWebController = [[CommonWebController alloc] initWithRequestUrl:[DICTIONARY_PAGE stringByAppendingString:word] name:[word stringByAppendingString:@"解释"] hasToolbar:YES];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingWebController];
    settingWebController.returnCallbackBlock = ^{
        //[navigationController dismissViewControllerAnimated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:navigationController animated:YES completion:nil];
    //NSLog(@"word notification");
}

- (void)doFavorite:(NSNotification *)notification {
    UIView *senderView = [notification.userInfo objectForKey:@"senderView"];
    UIView *cell = [notification.userInfo objectForKey:@"cell"];
    OneDayInfo *episode = notification.object;
    if (episode.isFavorite) {
        CGPoint center = [self.view convertPoint:senderView.center fromView:cell];
        //NSLog(@"center=%@", NSStringFromCGPoint(center));
        _starImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_cell_favorite.png"]];
        _starImg.center = center;
        [self.view addSubview:_starImg];
        if (!_starImgs) {
            _starImgs = [[NSMutableArray alloc] init];
        }
        [_starImgs addObject:_starImg];
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:center];
        [movePath addQuadCurveToPoint:_navFavoriteBtn.center
                         controlPoint:CGPointMake(center.x, _navFavoriteBtn.center.y)];


        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = movePath.CGPath;
        moveAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        moveAnim.rotationMode = @"auto";
        moveAnim.removedOnCompletion = YES;

        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 1.0)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 1.0)];
        scaleAnim.removedOnCompletion = YES;

        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
        opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
        opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
        opacityAnim.removedOnCompletion = YES;

        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
        animGroup.duration = 0.8;
        animGroup.delegate = self;
        animGroup.removedOnCompletion = YES;
        [_starImg.layer addAnimation:animGroup forKey:nil];


        //[self performSelector:@selector(resetFavoriteBtn) withObject:nil afterDelay:0.5];
    }
}


#pragma mark - implement CAAnimationDelegate -
- (void)animationDidStart:(CAAnimation *)anim {
    for (int i = 0; i < _starImgs.count - 1; i++) {
        UIView *starImg = [_starImgs objectAtIndex:i];
        [starImg removeFromSuperview];
    }
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (flag) {
        [_starImg removeFromSuperview];
        _starImgs = nil;
    }
}


- (void)resetFavoriteBtn {
    //[_navFavoriteBtn setBackgroundImage:[UIImage imageNamed:@"nav_favorite.png"] forState:UIControlStateNormal];
    _starImg.hidden = YES;
}

- (void)settingApp {
    SettingRootController *settingController = [[SettingRootController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingController];
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:navController animated:YES completion:^() {

    }];
}

- (void)switchController:(id)sender {
    if (sender == _navMainBtn) {
        if (_currentViewController != _mainViewController) {
            [self transitionFromViewController:_currentViewController toViewController:_mainViewController duration:1 options:UIViewAnimationOptionCurveLinear animations:^{

            }                       completion:^(BOOL finished) {
                if (finished) {
                    _currentViewController = _mainViewController;
                    [_navMainBtn setBackgroundImage:[UIImage imageNamed:@"nav_main_selected.png"] forState:UIControlStateNormal];
                    [_navFavoriteBtn setBackgroundImage:[UIImage imageNamed:@"nav_favorite.png"] forState:UIControlStateNormal];
                    double delayInSeconds = 1.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^{
                        [_mainViewController reloadData:_favViewController.unfavorites];
                        _favViewController.unfavorites = nil;
                    });
                }
            }];
        }
    } else {
        if (_currentViewController != _favViewController) {
            [self transitionFromViewController:_currentViewController toViewController:_favViewController duration:1 options:UIViewAnimationOptionCurveLinear animations:^{

            }                       completion:^(BOOL finished) {
                if (finished) {
                    _currentViewController = _favViewController;
                    [_navFavoriteBtn setBackgroundImage:[UIImage imageNamed:@"nav_favorite_selected.png"] forState:UIControlStateNormal];
                    [_navMainBtn setBackgroundImage:[UIImage imageNamed:@"nav_main.png"] forState:UIControlStateNormal];
                }
            }];
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}


- (void)shouldUpdate {
    float btnWidth = 19;
    float btnHeight = 15;
    UIImageView *updateBtn = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - btnWidth - MARGIN, MARGIN, btnWidth, btnHeight)];
    updateBtn.image = [UIImage imageNamed:@"tips_new.png"];
    [_toolbarView addSubview:updateBtn];
}
@end