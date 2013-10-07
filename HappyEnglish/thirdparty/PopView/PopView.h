//
// Created by @krq_tiger on 13-5-15.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//
#define POPLISTVIEW_SCREEN_INSET_X 0
#define POPLISTVIEW_SCREEN_INSET_Y 0
#define RADIUS 15.
#define POP_VIEW_WIDTH 310
#define POP_VIEW_HEIGHT 350
#define POP_VIEW_SLIDER_DISTANCE 50

typedef enum {
    JUST_POP,
    LEFT,
    RIGHT,
} PopDirection;

#import <Foundation/Foundation.h>

@protocol PopViewDelegate <NSObject>

- (void)popViewDidHidden;

- (void)popViewDidShow;

@end

@protocol PopViewDataSource

- (NSObject *)getData;

@end

@interface PopView : UIView <UIGestureRecognizerDelegate> {
    UIView *_contentView;
}

@property(nonatomic, weak) id <PopViewDelegate> delegate;
@property(nonatomic, weak) id <PopViewDataSource> dataSource;

- (id)initWithFrame:(CGRect)frame popDirection:(PopDirection)popDirection datasource:(id <PopViewDataSource>)dataSource delegate:(id <PopViewDelegate>)delegate;

- (void)presentInView:(UIView *)view animation:(BOOL)animation;

- (UIView *)createContentView:(CGRect)frame popDirection:(PopDirection)popDirection;

- (BOOL)shouldHidePopViewInCurrentTouch:(UITouch *)touch;
@end