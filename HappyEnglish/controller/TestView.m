//
// Created by @krq_tiger on 13-6-5.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TestView.h"


void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor);

@implementation TestView

- (void)drawRect:(CGRect)rect {
    /* UIBezierPath* p = [UIBezierPath bezierPath];
     [p moveToPoint:CGPointMake(100,100)];
     [p addLineToPoint:CGPointMake(100, 19)];
     [p setLineWidth:20];
     [p stroke];
     [[UIColor redColor] set];
     [p removeAllPoints];
     [p moveToPoint:CGPointMake(80,25)];
     [p addLineToPoint:CGPointMake(100, 0)];
     [p addLineToPoint:CGPointMake(120, 25)];
     [p fill];
     [p removeAllPoints];
     [p moveToPoint:CGPointMake(90,101)];
     [p addLineToPoint:CGPointMake(100, 90)];
     [p addLineToPoint:CGPointMake(110, 101)];
     [p fillWithBlendMode:kCGBlendModeClear alpha:1.0];*/
    /* CGContextRef context = UIGraphicsGetCurrentContext();

     UIColor * whiteColor = [UIColor blueColor];//[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
     UIColor * lightGrayColor = [UIColor blackColor];//[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];

     CGRect paperRect = self.bounds;

     drawLinearGradient(context, paperRect, whiteColor.CGColor, lightGrayColor.CGColor);
     UIColor * redColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]; // NEW
     CGRect strokeRect = CGRectInset(paperRect, 5.0, 5.0);
     CGContextSetStrokeColorWithColor(context, redColor.CGColor);
     CGContextSetLineWidth(context, 1.0);
     CGContextStrokeRect(context, strokeRect);*/

    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 110, 50, 30, 0, 2 * M_PI, 1);
    //CGPathMoveToPoint(myPath, NULL, 240, 50);
    CGPathAddArc(myPath, NULL, 210, 50, 30, 0, 2 * M_PI, 1);
    CGPathAddArc(myPath, NULL, 160, 110, 15, 0, 2 * M_PI, 1);
    CGPathAddArc(myPath, NULL, 160, 210, 25, 0, 2 * M_PI, 1);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextBeginPath(ctx);
    CGContextAddArc(ctx, 160, 240, 50, 0, 2 * M_PI, 1);
    CGContextClip(ctx);


    CGContextBeginPath(ctx);
    CGContextSaveGState(ctx);
//	CGContextRotateCTM(ctx, .25*M_PI);
//	CGContextTranslateCTM(ctx, 100, 100);

    CGAffineTransform myAffine = CGAffineTransformMakeRotation(.25 * M_PI);
    CGAffineTransformTranslate(myAffine, 100, 100);
    //CGContextConcatCTM(ctx, myAffine);

    CGContextAddPath(ctx, myPath);

    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    CGContextRestoreGState(ctx);
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = {0.0, 1.0};

    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];

    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);

    // More coming...
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

@end