//
// Created by tiger on 13-5-17.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#import "PopViewController.h"


@interface PopViewController ()

#pragma mark - private method -
- (PopView *)getNormalPopView;

- (PopView *)getSlidePopView;

- (PopView *)createInstanceByClassName;

@end

@implementation PopViewController {
    BOOL _popViewShouldShow;
    BOOL _popViewHasShow;
    BOOL _popViewShouldHidden;
    NSString *_popViewClass;
    UIView *__weak _containerView;

}


#pragma mark - public method -
- (void)setup:(UIViewController *)mainController delegate:(id <PopViewControllerDelegate>)delegate {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    _containerView = mainController.view;
    [mainController.view addGestureRecognizer:panGestureRecognizer];
    //[[delegate getContainerView] addGestureRecognizer:panGestureRecognizer];
    self.delegate = delegate;

}

- (PopViewController *)initWithPopViewClass:(NSString *)popViewClass {
    self = [super init];
    if (self) {
        _popViewClass = popViewClass;
    }
    return self;
}

- (void)showInView:(UIView *)view animation:(BOOL)animation {
    if (_popViewHasShow) {
        return;
    }
    _popDirection = JUST_POP;
    PopView *popView = [self getNormalPopView];
    self.popView = popView;
    [popView presentInView:view animation:animation];
}

- (id)init {
    self = [super init];
    if (self) {
        _popViewClass = NSStringFromClass([PopView class]);
    }

    return self;
}

- (void)clear {
    //do nothing ,the subclass override this method to clear the controller state when the popview is hidden
}


#pragma mark - handle gesture -
- (void)handlePanGesture:(id)sender {
    UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *) sender;
    UIView *view;
    if ([self.delegate respondsToSelector:@selector(getContainerView)]) {
        view = [self.delegate getContainerView];
    } else {
        view = _containerView;
    }
    CGPoint velocityPoint = [recognizer velocityInView:view];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (velocityPoint.x > 0) {
            _popDirection = RIGHT;
        } else {
            _popDirection = LEFT;

        }
        if (_popViewHasShow) {
            return;
        }
        if ([self.delegate respondsToSelector:@selector(getViewHavingData)] && [self.delegate respondsToSelector:@selector(getDataAtPoint:)]) {
            CGPoint location = [recognizer locationInView:self.delegate.getViewHavingData];
            NSObject *object = [self.delegate getDataAtPoint:location];
            if (!object)return;
            _data = object;
        }
        PopView *popDetailView = [self getSlidePopView];
        [popDetailView presentInView:view animation:NO];
        _popView = popDetailView;
    }

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        if (!_data && [self.delegate respondsToSelector:@selector(getViewHavingData)] && [self.delegate respondsToSelector:@selector(getDataAtPoint:)]) {
            return;
        }
        CGPoint translatedPoint = [recognizer translationInView:view];
        _popView.center = CGPointMake(_popView.center.x + translatedPoint.x, _popView.center.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:view];
        if (_popViewHasShow) {
            if (_popDirection == RIGHT) {
                _popViewShouldHidden = _popView.center.x > MAIN_SCREEN_WIDTH / 2 + POP_VIEW_SLIDER_DISTANCE;
            } else {
                _popViewShouldHidden = _popView.center.x < MAIN_SCREEN_WIDTH / 2 - POP_VIEW_SLIDER_DISTANCE;
            }
            return;
        }
        if (_popDirection == RIGHT) {
            _popViewShouldShow = _popView.center.x > 0;
        } else {
            _popViewShouldShow = _popView.center.x < MAIN_SCREEN_WIDTH;
        }

    }

    if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (!_data && [self.delegate respondsToSelector:@selector(getViewHavingData)] && [self.delegate respondsToSelector:@selector(getDataAtPoint:)]) {
            return;
        }
        if (_popViewHasShow) {
            if (_popViewShouldHidden) {
                [self hiddenPopView];
            } else {
                [self showPanel];
            }
            return;
        }
        if (_popViewShouldShow) {
            [self showPanel];
        } else {
            [self resetPopView];
        }

    }

}


- (void)hiddenPopView {
    if (_popDirection == RIGHT) {
        [self movePopViewToRight];
    } else {
        [self movePopViewToLeft];
    }
    [self popViewDidHidden];

}

- (void)resetPopView {
    if (_popDirection == RIGHT) {
        [self movePopViewToLeft];
    } else {
        [self movePopViewToRight];
    }
    [self popViewDidHidden];

}

- (void)showPanel {
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _popView.center = CGPointMake(MAIN_SCREEN_WIDTH / 2, _popView.center.y);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             _popViewHasShow = YES;
                             _popViewShouldShow = YES;
                             _popViewShouldHidden = NO;
                             [self addPanGesture];
                             [self popViewDidShow];
                             //[[delegate getContainerView] addGestureRecognizer:panGestureRecognizer];
                         }
                     }];


}


- (void)movePopViewToLeft {
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _popView.center = CGPointMake(-MAIN_SCREEN_WIDTH / 2, _popView.center.y);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self clearState];
                         }

                     }];
}


- (void)movePopViewToRight {
    [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _popView.center = CGPointMake(MAIN_SCREEN_WIDTH + MAIN_SCREEN_WIDTH / 2, _popView.center.y);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self clearState];
                         }
                     }];
}

- (void)clearState {
    [_popView removeFromSuperview];
    _popView = nil;
    _popViewShouldShow = NO;
    _popViewHasShow = NO;
    _popViewShouldHidden = NO;
    [self clear];
}



#pragma mark - implement PopViewDelegate --

- (void)popViewDidHidden {
    _popViewHasShow = NO;
    [self clear];

}

- (void)popViewDidShow {
    [self addPanGesture];
    _popViewHasShow = YES;

}



#pragma mark - implement PopViewDateSource -
- (NSObject *)getData {
    return _data;
}



#pragma mark - implement UIGestureDelegate -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return [self shouldMoveWithThisTouch:touch];
}


- (BOOL)shouldMoveWithThisTouch:(UITouch *)touch {
    return YES;
}



#pragma mark - private method -
- (PopView *)getNormalPopView {
    PopView *popView = [self createInstanceByClassName];
    [popView initWithFrame:CGRectMake(0, 0, POP_VIEW_WIDTH, POP_VIEW_HEIGHT) popDirection:JUST_POP datasource:self delegate:self];
    return popView;
}


- (PopView *)getSlidePopView {
    PopView *popView = [self createInstanceByClassName];
    [popView initWithFrame:CGRectMake(0, 0, POP_VIEW_WIDTH, POP_VIEW_HEIGHT) popDirection:_popDirection datasource:self delegate:self];
    return popView;
}

- (PopView *)createInstanceByClassName {
    NSBundle *bundle = [NSBundle mainBundle];
    return [[bundle classNamed:_popViewClass] alloc];
}

- (void)addPanGesture {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    panGestureRecognizer.delegate = self;
    [self.popView addGestureRecognizer:panGestureRecognizer];
}
@end