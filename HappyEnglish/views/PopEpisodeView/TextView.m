//
// Created by @krq_tiger on 13-6-21.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TextView.h"
#import "Global.h"
#import "MainTableViewCell.h"
#import "WordPanel.h"
#import "PopEpisodeView.h"
#import "HappyEnglishAppDelegate.h"

@interface FetchWordDelegate : NSObject <UIGestureRecognizerDelegate>
@end

@implementation FetchWordDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

@end

@implementation TextView {
    BOOL _wordPanelIsShow;
    id <UIGestureRecognizerDelegate> _fetchWordDelegate;
    NSString *_currentWord;
}

- (id)initWithFrame:(CGRect)frame andEpisode:(OneDayInfo *)episode andDelegate:(id <PopEpisodeViewDelegate>)delegate isMulti:(BOOL)isMulti {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenWordPanel)];
        [self addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.delegate = self;
        _delegate = delegate;
        self.episode = episode;
        float y = 2 * MARGIN;
        CGSize englishTextSize = [self.episode.englishText sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(frame.size.width - 16, CGFLOAT_MAX) lineBreakMode:UILineBreakModeHeadTruncation];
        _englishTextView = [[CustomTextView alloc] initWithFrame:CGRectMake(MARGIN, y, frame.size.width, englishTextSize.height)];
        _englishTextView.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8);
        _englishTextView.editable = NO;
        _englishTextView.text = self.episode.englishText;
        _englishTextView.font = ENGLISH_TEXT__SETTING_FONT;
        _englishTextView.textColor = [UIColor whiteColor];
        _englishTextView.backgroundColor = [UIColor clearColor];
        _englishTextView.translateDelegate = self;
        y = y + _englishTextView.frame.size.height + MARGIN;

        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(translate:)];
        _fetchWordDelegate = [[FetchWordDelegate alloc] init];
        recognizer.delegate = _fetchWordDelegate;
        [_englishTextView addGestureRecognizer:recognizer];

        CGSize chineseTextSize = [self.episode.chineseText sizeWithFont:CHINESE_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(frame.size.width - 16, CGFLOAT_MAX) lineBreakMode:UILineBreakModeHeadTruncation];

        _chineseTextView = [[UITextView alloc] initWithFrame:CGRectMake(MARGIN, y, frame.size.width, chineseTextSize.height)];
        _chineseTextView.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8);
        _chineseTextView.editable = NO;
        _chineseTextView.text = self.episode.chineseText;
        _chineseTextView.font = CHINESE_TEXT__SETTING_FONT;
        _chineseTextView.textColor = [UIColor whiteColor];
        _chineseTextView.backgroundColor = [UIColor clearColor];
        y = y + _chineseTextView.frame.size.height + MARGIN;

        BOOL hasOffline = [self.episode hasAllOffline];
        _downLoadTagLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(MARGIN, y, 80, 20)];
        _downLoadTagLabel.font = CHINESE_TEXT_FONT;
        _downLoadTagLabel.textColor = [UIColor whiteColor];
        _downLoadTagLabel.backgroundColor = [UIColor clearColor];
        if (hasOffline) {
            _downLoadTagLabel.text = isMulti && !episode ? @"" : @"已下载";
            CGSize size = [_downLoadTagLabel.text sizeWithFont:CHINESE_TEXT_FONT constrainedToSize:CGSizeMake(frame.size.width, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeCharacterWrap];
            _downLoadTagLabel.frame = CGRectMake(MARGIN, y, size.width, size.height);
        } else {
            _downLoadTagLabel.text = isMulti && !episode ? @"" : @"未下载";
            CGSize size = [_downLoadTagLabel.text sizeWithFont:CHINESE_TEXT_FONT constrainedToSize:CGSizeMake(frame.size.width, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeCharacterWrap];
            _downLoadTagLabel.frame = CGRectMake(MARGIN, y, size.width, size.height);
        }

        _createDateLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - DATE_WIDTH- MARGIN), y, DATE_WIDTH, DATE_HEIGHT)];
        _createDateLabel.font = CHINESE_TEXT_FONT;
        _createDateLabel.backgroundColor = [UIColor clearColor];
        _createDateLabel.text = [Global formatDate:self.episode.createDate];
        _createDateLabel.textColor = [UIColor whiteColor];

        UIImageView *textPanelBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popView_textPanel_bg.png"]];
        textPanelBgView.frame = self.bounds;
        //[self addSubview:textPanelBgView];
        //[self sendSubviewToBack:textPanelBgView];
        self.backgroundColor = POP_VIEW_BACKGROUND_COLOR;
        [self addSubview:_englishTextView];
        [self addSubview:_chineseTextView];
        [self addSubview:_downLoadTagLabel];
        [self addSubview:_createDateLabel];
        if (!hasOffline && !isMulti && ![[[GlobalAppConfig sharedInstance] valueForKey:kwifiAutoDownload] boolValue]) {
            _downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(_downLoadTagLabel.frame.size.width + MARGIN, y, 40, 40)];
            [_downloadBtn setImage:[UIImage imageNamed:@"popView_downloadBtn.png"] forState:UIControlStateNormal];
            [_downloadBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
            [_downloadBtn addTarget:self action:@selector(downloadAudio) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_downloadBtn];
        }
    }

    return self;
}

- (void)updateViewToAudioStartedState:(AudioType)audioType episode:(OneDayInfo *)episode isMultiEpisode:(BOOL)isMultiEpisode {
    float y = 2 * MARGIN;
    CGSize englishTextSize = [episode.englishText sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(_englishTextView.frame.size.width - 16, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeHeadTruncation];
    _englishTextView.frame = CGRectMake(MARGIN, y, _englishTextView.frame.size.width, englishTextSize.height);
    y = y + _englishTextView.frame.size.height + MARGIN;
    CGSize chineseTextSize = [episode.chineseText sizeWithFont:CHINESE_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(_chineseTextView.frame.size.width - 16, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeHeadTruncation];
    _chineseTextView.frame = CGRectMake(MARGIN, y, _chineseTextView.frame.size.width, chineseTextSize.height);
    y = y + _chineseTextView.frame.size.height + MARGIN;
    BOOL hasOffline = [episode hasOffline:audioType];
    if (hasOffline) {
        _downLoadTagLabel.text = @"已下载";
        CGSize size = [_downLoadTagLabel.text sizeWithFont:CHINESE_TEXT_FONT constrainedToSize:CGSizeMake(POP_VIEW_WIDTH, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeHeadTruncation];
        _downLoadTagLabel.frame = CGRectMake(MARGIN, y, size.width, size.height);
        _downloadBtn.hidden = YES;
    } else {
        _downLoadTagLabel.text = @"未下载";
        CGSize size = [_downLoadTagLabel.text sizeWithFont:CHINESE_TEXT_FONT constrainedToSize:CGSizeMake(POP_VIEW_WIDTH, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeHeadTruncation];
        _downLoadTagLabel.frame = CGRectMake(MARGIN, y, size.width, size.height);
        if (!_downloadBtn && !isMultiEpisode) {
            _downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(_downLoadTagLabel.frame.size.width + MARGIN, y, 40, 40)];
            [_downloadBtn setImage:[UIImage imageNamed:@"popView_downloadBtn.png"] forState:UIControlStateNormal];
            [_downloadBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
            [_downloadBtn addTarget:self action:@selector(downloadAudio) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_downloadBtn];
        }
        if (_downloadBtn) {
            _downloadBtn.frame = CGRectMake(_downLoadTagLabel.frame.size.width + MARGIN, y, 40, 40);
            _downloadBtn.hidden = ([[[GlobalAppConfig sharedInstance] valueForKey:kwifiAutoDownload] boolValue]) ? YES : NO;
            _downloadBtn.enabled = YES;
        }
    }
    _createDateLabel.frame = CGRectMake((POP_VIEW_WIDTH - DATE_WIDTH- MARGIN), y, DATE_WIDTH, DATE_HEIGHT);
    _englishTextView.text = episode.englishText;
    _chineseTextView.text = episode.chineseText;
    _createDateLabel.text = [Global formatDate:episode.createDate];
}


#pragma mark - target selector -
- (void)translate:(id)sender {
    if (_wordPanel) {
        _wordPanel.hidden = YES;
        _wordPanelIsShow = NO;
    }
    NSRange range = [_englishTextView selectedRange];
    if (range.location >= _englishTextView.text.length)return;
    UITextRange *selectionRange = [_englishTextView selectedTextRange];
    CGRect selectionStartRect = [_englishTextView caretRectForPosition:selectionRange.start];
    _selectRect = selectionStartRect;
    NSString *selection = [_englishTextView.text substringWithRange:range];
    selection = [selection stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!selection || selection.length == 0 || [selection isEqualToString:_currentWord]) {
        return;
    } else {
        _currentWord = selection;
    }
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(translateUsingWeb)];
    [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    [[UIMenuController sharedMenuController] setTargetRect:_selectRect inView:self];
    //[(id <PopEpisodeViewDelegate>) self.delegate translate:selection];
}


- (void)showWordPanel:(Word *)word {
    _wordPanelIsShow = YES;
    NSString *meaning = [word meaning];
    if (!meaning || [meaning isEqualToString:@""]) {
        meaning = @"未找到解释!";
        [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"未找到解释，点击翻译" duration:2];
        UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(translateUsingWeb)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObject:menuItem]];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        [[UIMenuController sharedMenuController] setTargetRect:_selectRect inView:self];
        return;
    }
    NSString *phoneticSymbol = word.phoneticSymbol;
    NSString *source = [word.source stringByAppendingFormat:@":[%@]", phoneticSymbol ? phoneticSymbol : @""];
    if (!_wordPanel) {
        _wordPanel = [[WordPanel alloc] initWithFrame:CGRectZero];
        [self addSubview:_wordPanel];
    }
    _wordPanel.source = source;
    _wordPanel.meaning = meaning;
    _wordPanel.selectRect = _selectRect;
    [_wordPanel reLayout];
}

- (void)translate {
    if (_currentWord && _currentWord.length > 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DO_TRANSLATE_KEY object:_currentWord];
    }
}


- (void)downloadAudio {
    NetworkStatus networkStatus = [HappyEnglishAppDelegate sharedAppDelegate].networkStatus;
    if (networkStatus == NotReachable) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayErrorInformation:@"无网络连接,请开启网络后下载！" duration:2];
        return;
    }
    _downloadBtn.hidden = YES;
    [(id <PopEpisodeViewDelegate>) self.delegate downloadAudio];
    [[HappyEnglishAppDelegate sharedAppDelegate] showOverlayProgressInformation:@"开始下载音频！" duration:2];
}

- (void)settingToSingleEpisodePlayer {
    _downloadBtn.hidden = NO;
}

- (void)settingToMultiEpisodePlayer {
    _downloadBtn.hidden = YES;
}

- (void)changeToDownloadedState {
    _downLoadTagLabel.text = @"已下载";
    _downloadBtn.hidden = YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)hiddenWordPanel {
    NSArray *subViews = _englishTextView.subviews;
    for (UIView *subView in subViews) {
        if ([NSStringFromClass(subView.class) isEqualToString:@"UITextSelectionView"]) {
            [subView removeFromSuperview];
        }
    }
    _wordPanel.hidden = YES;
    _wordPanelIsShow = NO;
    _currentWord = nil;

}


@end