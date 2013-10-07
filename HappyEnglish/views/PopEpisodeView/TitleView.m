//
// Created by @krq_tiger on 13-6-22.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TitleView.h"
#import "Global.h"
#import "PopEpisodeView.h"
#import "HappyEnglishAPI.h"


@implementation TitleView {
}

- (id)initWithFrame:(CGRect)frame andEpisode:(OneDayInfo *)episode andDelegate:(id <PopEpisodeViewDelegate>)delegate isMulti:(BOOL)isMulti {
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.episode = episode;
        _titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleView.image = [UIImage imageNamed:@"popView_toolbar_bg.png"];
        _titleView.userInteractionEnabled = YES;
        //_titleView.backgroundColor = [UIColor whiteColor];
        float titleLabelX = frame.size.width / 2 - 200 / 2;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelX, 0, 200, frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.text = isMulti ? [@"多期播放" stringByAppendingFormat:@"(%@)", [self getEpisodeModeString]] : [NSString stringWithFormat:@"单期播放(第%d期)", self.episode.issueNumber];
        _titleLabel.font = CHINESE_TEXT_FONT;
        _titleLabel.textColor = [UIColor whiteColor];
        float btnWidth = 39;
        float btnHeight = 32;
        _sharedBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - btnWidth - 2 * MARGIN, (frame.size.height - btnHeight) / 2, btnWidth, btnHeight)];
        [_sharedBtn setBackgroundImage:[UIImage imageNamed:@"popView_sharedBtn@2x.png"] forState:UIControlStateNormal];
        [_sharedBtn addTarget:self action:@selector(shareEpisode) forControlEvents:UIControlEventTouchUpInside];

        [_titleView addSubview:_titleLabel];
        [_titleView addSubview:_sharedBtn];
        [self addSubview:_titleView];

    }
    return self;
}

- (void)shareEpisode {
    [[NSNotificationCenter defaultCenter] postNotificationName:DO_SHARE_KEY object:self.episode];
}

- (NSString *)getEpisodeModeString {
    NSString *tips;
    EpisodePeriod episodePeriod;
    [[[GlobalAppConfig sharedInstance] valueForKey:kepisodePeriod] getValue:&episodePeriod];
    switch (episodePeriod) {
        case ThisWeek: {
            tips = @"本周";
        }
            break;
        case LastWeek: {
            tips = @"上周";
        }
            break;
        case LastTwoWeeks: {
            tips = @"前两周";
        }
            break;
        case LastThreeWeeks: {
            tips = @"前三周";
        }
            break;
        case ThisMonth: {
            tips = @"本月";
        }
            break;
        case LastMonth: {
            tips = @"上个月";
        }
            break;
        case Favorite: {
            tips = @"收藏列表";
        }
            break;
        case  YourChoice: {
            NumberRange numberRange = [HappyEnglishAPI queryIssueNumberRange];
            int startNumber = numberRange.startNumber;
            int endNumber = numberRange.endNumber;
            tips = [NSString stringWithFormat:@"%d期-%d期", startNumber, endNumber];
        }
            break;
    }
    return tips;
}

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)oneDayInfo isMultiEpisode:(BOOL)isMultiEpisode {
    //_titleLabel.text = [NSString stringWithFormat:@"第%d期", oneDayInfo.issueNumber];
}


@end