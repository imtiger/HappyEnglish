//
// Created by tiger on 13-5-10.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "PopView.h"


@interface PopView ()

#pragma  mark - private methods  -
- (void)fadeIn;

- (void)fadeOut;

@end

@implementation PopView

#pragma mark - override super class method -

- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}

- (id)initWithFrame:(CGRect)frame popDirection:(PopDirection)popDirection datasource:(id <PopViewDataSource>)dataSource delegate:(id <PopViewDelegate>)delegate {
    CGRect containerFrame = [[UIScreen mainScreen] bounds];
    switch (popDirection) {
        case RIGHT: {
            containerFrame.origin.x = -containerFrame.size.width;
            break;
        }
        case LEFT: {
            containerFrame.origin.x = containerFrame.size.width;
            break;
        }
        default:

            break;

    }
    frame.origin.x = (containerFrame.size.width - frame.size.width) / 2 + frame.origin.x;
    self = [super initWithFrame:containerFrame];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fadeOut)];
        [self addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.delegate = self;
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = dataSource;
        self.delegate = delegate;
        UIView *contentView = [self createContentView:frame popDirection:popDirection];
        _contentView = contentView;
        [self addSubview:_contentView];
    }
    return self;
}


#pragma mark - subClass to override this method to init the subViews of PopView -
- (UIView *)createContentView:(CGRect)frame popDirection:(PopDirection)popDirection {
    return nil;
}

- (void)presentInView:(UIView *)view  animation:(BOOL)animation {
    [view addSubview:self];
    [view bringSubviewToFront:self];
    if (animation) {
        [self fadeIn];
    }


}

/*- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSEnumerator *enumerator = [touches objectEnumerator];
    for (id element in enumerator) {
        UITouch *touch = element;
        if ([_contentView pointInside:[touch locationInView:_contentView] withEvent:event]) {
            return;
        }
    }
    [self fadeOut];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}*/

/*- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSEnumerator *reverseE = [self.subviews reverseObjectEnumerator];
    UIView *iSubView;

    while ((iSubView = [reverseE nextObject])) {

        UIView *viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if (viewWasHit) {
            return viewWasHit;
        }

    }
    return [super hitTest:point withEvent:event];
}*/


- (void)fadeIn {
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;  //透明
    [UIView animateWithDuration:0.3 delay:0.f options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.alpha = 1;
                         self.transform = CGAffineTransformMakeScale(1.2, 1);
                     }
                     completion:^(BOOL finished) {
                         self.transform = CGAffineTransformIdentity;
                         if (_delegate) {
                             [_delegate popViewDidShow];
                         }
                     }];
}

- (void)fadeOut {
    self.transform = CGAffineTransformMakeScale(1.1, 1);
    [UIView animateWithDuration:.3
                     animations:^{
                         self.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [self removeFromSuperview];
                             if (_delegate) {
                                 [_delegate popViewDidHidden];
                             }
                         }
                     }];
}




#pragma mark - implement  GestureDelegate -
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return ![_contentView pointInside:[touch locationInView:_contentView] withEvent:nil] && [self shouldHidePopViewInCurrentTouch:touch];
}


- (BOOL)shouldHidePopViewInCurrentTouch:(UITouch *)touch {
    return NO;
}

@end