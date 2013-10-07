//
// Created by @krq_tiger on 13-7-3.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "GuideTipView.h"
#import "PopEpisodeView.h"
#import "Global.h"


@implementation GuideTipView {

}

- (id)initWithFrame:(CGRect)frame tipsText:(NSString *)tipsText {
    self = [super initWithFrame:CGRectMake((MAIN_SCREEN_WIDTH- 200) / 2, MAIN_SCREEN_HEIGHT- 100 - 45 - 20, 200, 100)];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 150, 50)];
        textLabel.textAlignment = UITextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = POP_VIEW_BACKGROUND_COLOR;//[UIColor clearColor];
        textLabel.font = TIPS_TEXT_FONT;
        textLabel.text = tipsText;
        textLabel.numberOfLines = 0;
        textLabel.layer.cornerRadius = 6;
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(MARGIN, 50, 40, 40)];
        icon.image = [UIImage imageNamed:@"Icon.png"];
        [self addSubview:icon];
        [self addSubview:textLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end