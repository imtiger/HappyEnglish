//
// Created by @krq_tiger on 13-6-21.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "WordPanel.h"
#import "Global.h"


@implementation WordPanel {

}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /*  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWordPanel)];
          [self addGestureRecognizer:tapGestureRecognizer];*/
        self.backgroundColor = [UIColor colorWithRed:247 / 255. green:247 / 255. blue:247 / 255. alpha:1];
        self.layer.cornerRadius = 4;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 4;
        _sourceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceLabel.font = ENGLISH_TEXT_FONT;
        _sourceLabel.backgroundColor = [UIColor clearColor];
        _sourceLabel.textColor = [UIColor whiteColor];
        _sourceLabel.numberOfLines = 0;
        _meanLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _meanLabel.font = CHINESE_TEXT_FONT;
        _meanLabel.numberOfLines = 0;
        _meanLabel.backgroundColor = [UIColor clearColor];
        _meanLabel.textColor = [UIColor whiteColor];
        _meanLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [self addSubview:_sourceLabel];
        [self addSubview:_meanLabel];
        self.backgroundColor = [UIColor colorWithRed:0. green:0. blue:0. alpha:0.9];
    }

    return self;
}


- (void)reLayout {
    _sourceLabel.text = [self.source stringByAppendingString:@":"];
    _meanLabel.text = self.meaning;
    self.hidden = NO;
    float textContentWidth = 200;
    float maxHeight = 100;
    CGSize sourceTextSize = [self.source sizeWithFont:ENGLISH_TEXT_FONT constrainedToSize:CGSizeMake(textContentWidth - 2 * MARGIN, maxHeight) lineBreakMode:UILineBreakModeTailTruncation];
    CGSize meanTextSize = [self.meaning sizeWithFont:CHINESE_TEXT_FONT constrainedToSize:CGSizeMake(textContentWidth - 2 * MARGIN, maxHeight) lineBreakMode:UILineBreakModeTailTruncation];
    textContentWidth = MAX(sourceTextSize.width, meanTextSize.width);
    _sourceLabel.frame = CGRectMake(MARGIN, MARGIN, textContentWidth, sourceTextSize.height);
    _meanLabel.frame = CGRectMake(MARGIN, _sourceLabel.frame.size.height + 2*MARGIN, textContentWidth, meanTextSize.height);
    [_meanLabel sizeToFit];
    float selectX = self.selectRect.origin.x;
    float x;
    float wordPanelWidth = textContentWidth + 2 * MARGIN;
    float halfWidth = wordPanelWidth / 2;
    if (selectX < halfWidth + MARGIN) {
        x = MARGIN;
    } else if (selectX + halfWidth + MARGIN > self.superview.frame.size.width) {
        x = self.superview.frame.size.width - wordPanelWidth - MARGIN;
    } else {
        x = selectX - halfWidth;
    }
    float y = _sourceLabel.frame.size.height + _meanLabel.frame.size.height+3*MARGIN;
    self.frame = CGRectMake(x, self.selectRect.origin.y + self.selectRect.size.height + 20, wordPanelWidth, y);
    //self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    self.alpha = 0;  //透明
    [UIView animateWithDuration:0.5 delay:0.f options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 1;
                         //self.transform = CGAffineTransformMakeScale(1.05, 1.05);
                     }
                     completion:^(BOOL finished) {
                         //self.transform = CGAffineTransformIdentity;
                     }];
    //[self performSelector:@selector(hiddenWordPanel) withObject:nil afterDelay:4];
}


- (void)hiddenWordPanel {
    self.hidden = YES;
}


- (void)drawaRect:(CGRect)rect {
    [super drawRect:rect];
    /*UIBezierPath*    aPath = [UIBezierPath bezierPath];
    [[UIColor blackColor] setStroke];

    [[UIColor redColor] setFill];

    // Set the starting point of the shape.

    [aPath moveToPoint:CGPointMake(100.0, 0.0)];

    [aPath addLineToPoint:CGPointMake(200.0, 40.0)];

    [aPath addLineToPoint:CGPointMake(160, 140)];

    [aPath addLineToPoint:CGPointMake(40.0, 140)];

    [aPath addLineToPoint:CGPointMake(0.0, 40.0)];

    [aPath closePath];
    [aPath fill];
    [aPath stroke];*/


}

@end