//
// Created by @krq_tiger on 13-5-17.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PopView.h"

@protocol PopViewControllerDelegate <NSObject>

- (UIView *)getContainerView;

- (NSObject *)getDataAtPoint:(CGPoint)point;

//get the view which contains the data which returned by getDataAtPoint
- (UIView *)getViewHavingData;


@end

@interface PopViewController : NSObject <PopViewDataSource, PopViewDelegate, UIGestureRecognizerDelegate>

- (PopViewController *)initWithPopViewClass:(NSString *)popViewClass;

- (void)setup:(UIViewController *)mainController delegate:(id <PopViewControllerDelegate>)delegate;

- (void)showInView:(UIView *)view animation:(BOOL)animation;

- (BOOL)shouldMoveWithThisTouch:(UITouch *)touch;

- (void)clear;

@property(nonatomic, weak) id <PopViewControllerDelegate> delegate;
@property(nonatomic, strong) PopView *popView;
@property(nonatomic, strong) NSObject *data;
@property(nonatomic, readonly) PopDirection popDirection;

@end