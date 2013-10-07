//
// Created by tiger on 13-5-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <QuartzCore/QuartzCore.h>
#import "MainTableViewCell.h"
#import "OneDayInfo.h"
#import "Global.h"


@implementation MainTableViewCell {
    UIButton *_favBtn;
    UILabel *_englishTextLabel;
    UILabel *_chineseTextLabel;
    UILabel *_createDateLabel;
    UILabel *_numberTagLabel;
    UIView *_containerView;
    CALayer *selectBackgroundViewLayer;
    OneDayInfo *_info;

}

#pragma mark -override super class method-
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor clearColor];
        selectBackgroundViewLayer = [CALayer layer];
        selectBackgroundViewLayer.backgroundColor = [UIColor colorWithRed:164 / 255. green:164 / 255. blue:184 / 255. alpha:0.5].CGColor;
        selectBackgroundViewLayer.cornerRadius = 4;
        [backgroundView.layer addSublayer:selectBackgroundViewLayer];
        self.selectedBackgroundView = backgroundView;

        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor colorWithRed:247 / 255. green:247 / 255. blue:247 / 255. alpha:1];
        _containerView.layer.cornerRadius = 4;
        _containerView.layer.shadowColor = [UIColor colorWithRed:185 / 255. green:185 / 255. blue:185 / 255. alpha:1].CGColor;
        _containerView.layer.shadowRadius = 2;
        _containerView.layer.shadowOpacity = 0.8;
        _containerView.layer.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:_containerView];
    }

    return self;
}



#pragma mark - override super class method-
- (void)resizeCell {
    // [super layoutSubviews];
    CGFloat left = MARGIN;
    CGFloat top = MARGIN;
    if (_englishTextLabel) {
        CGSize englishTextSize = [_info.englishText sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeTailTruncation];
        if (englishTextSize.height > MAX_TEXT_HEIGHT) {
            englishTextSize.height = MAX_TEXT_HEIGHT;
        }
        if (englishTextSize.height < MIN_TEXT_HEIGHT) {
            englishTextSize.height = MIN_TEXT_HEIGHT;
        }
        _englishTextLabel.font = ENGLISH_TEXT__SETTING_FONT;
        _englishTextLabel.frame = CGRectMake(left, top, englishTextSize.width, englishTextSize.height);
        top = top + _englishTextLabel.frame.size.height + MARGIN;
    }
    if (_chineseTextLabel) {
        CGSize chineseTextSize = [_info.chineseText sizeWithFont:CHINESE_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeMiddleTruncation];
        if (chineseTextSize.height > MAX_TEXT_HEIGHT) {
            chineseTextSize.height = MAX_TEXT_HEIGHT;
        }
        if (chineseTextSize.height < MIN_TEXT_HEIGHT) {
            chineseTextSize.height = MIN_TEXT_HEIGHT;
        }
        _chineseTextLabel.font = CHINESE_TEXT__SETTING_FONT;
        _chineseTextLabel.frame = CGRectMake(left, top, chineseTextSize.width, chineseTextSize.height);
        top = top + _chineseTextLabel.frame.size.height + MARGIN;
    }

    if (_numberTagLabel) {
        _numberTagLabel.frame = CGRectMake(left, top, NUMBER_TAG_WIDTH, NUMBER_TAG_HEIGHT);
    }


    if (_createDateLabel) {
        CGSize dateSize = [_createDateLabel.text sizeWithFont:DATE_TEXT_FONT constrainedToSize:CGSizeMake(DATE_WIDTH, DATE_HEIGHT) lineBreakMode:UILineBreakModeMiddleTruncation];
        _createDateLabel.frame = CGRectMake(CONTAINER_VIEW_WIDTH - dateSize.width - 35, top, DATE_WIDTH, DATE_HEIGHT);
    }

    if (_favBtn) {
        _favBtn.frame = CGRectMake(CONTAINER_VIEW_WIDTH - MAIN_IMG_WIDTH, top - MARGIN, MAIN_IMG_WIDTH, MAIN_IMG_HEIGHT);
        top = top + 20;
    }


    if (_containerView) {
        _containerView.frame = CGRectMake((MAIN_SCREEN_WIDTH- CONTAINER_VIEW_WIDTH) / 2, MARGIN, CONTAINER_VIEW_WIDTH, top);
    }
    selectBackgroundViewLayer.frame = _containerView.frame;

}

+ (CGFloat)heightOfRowWithObject:(id)data {
    OneDayInfo *info = data;
    CGFloat height = MARGIN;
    if (info.englishText) {
        CGSize englishTextSize = [info.englishText sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeMiddleTruncation];
        if (englishTextSize.height > MAX_TEXT_HEIGHT) {
            englishTextSize.height = MAX_TEXT_HEIGHT;
        }
        if (englishTextSize.height < MIN_TEXT_HEIGHT) {
            englishTextSize.height = MIN_TEXT_HEIGHT;
        }
        height = height + englishTextSize.height + MARGIN;
    }
    if (info.chineseText) {
        CGSize chineseTextSize = [info.chineseText sizeWithFont:CHINESE_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(CONTENT_TEXT_WIDTH, MAX_TEXT_HEIGHT) lineBreakMode:UILineBreakModeMiddleTruncation];
        if (chineseTextSize.height > MAX_TEXT_HEIGHT) {
            chineseTextSize.height = MAX_TEXT_HEIGHT;
        }
        if (chineseTextSize.height < MIN_TEXT_HEIGHT) {
            chineseTextSize.height = MIN_TEXT_HEIGHT;
        }
        height = height + chineseTextSize.height + MARGIN;
    }
    if (info.createDate) {
        height = height + DATE_HEIGHT;
    }
    return height + 3 * MARGIN;//height + NUMBER_TAG_HEIGHT +  MARGIN;
}


- (void)setDataSource:(id)data {
    _info = data;
    self.englishText = _info.englishText;
    self.chineseText = _info.chineseText;
    if (_info.isFavorite) {
        self.favBtn = [UIImage imageNamed:@"main_cell_favorite.png"];
    } else {
        self.favBtn = [UIImage imageNamed:@"main_cell_un_favorite.png"];
    }

    self.createDate = _info.createDate;
    self.number = _info.issueNumber;

}


#pragma mark - custom setter method -
- (void)setEnglishText:(NSString *)newEnglishText {
    if (!_englishTextLabel) {
        _englishTextLabel = [[UILabel alloc] init];
        _englishTextLabel.numberOfLines = 0;
        _englishTextLabel.font = ENGLISH_TEXT__SETTING_FONT;
        _englishTextLabel.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:_englishTextLabel];
    }
    _englishTextLabel.text = newEnglishText;
}

- (void)setChineseText:(NSString *)newChineseText {
    if (!_chineseTextLabel) {
        _chineseTextLabel = [[UILabel alloc] init];
        _chineseTextLabel.numberOfLines = 0;
        _chineseTextLabel.textAlignment = UITextAlignmentLeft;
        _chineseTextLabel.font = CHINESE_TEXT__SETTING_FONT;
        _chineseTextLabel.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:_chineseTextLabel];
    }
    _chineseTextLabel.text = newChineseText;
}

- (void)setCreateDate:(NSDate *)newCreateDate {
    if (!_createDateLabel) {
        _createDateLabel = [[UILabel alloc] init];
        _createDateLabel.font = DATE_TEXT_FONT;
        _createDateLabel.backgroundColor = [UIColor clearColor];
        [_containerView addSubview:_createDateLabel];
    }
    _createDateLabel.text = [Global formatDate:_info.createDate];
}

- (void)setFavBtn:(UIImage *)btnBg {
    if (!_favBtn) {
        _favBtn = [[UIButton alloc] init];
        //[_favBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:btnBg];
        //imageView.userInteractionEnabled = YES;
        //[_favBtn addSubview:imageView];
        //[_favBtn backgroundRectForBounds:CGRectMake(0, 0, MAIN_IMG_WIDTH, MAIN_IMG_HEIGHT)];
        //_favBtn.backgroundColor = [UIColor redColor];
        [_favBtn addTarget:self action:@selector(doFavorite) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_favBtn];
    }
    [_favBtn setImage:btnBg forState:UIControlStateNormal];
    [_favBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 7, 5, 0)];

}

- (void)doFavorite {
    if (_info.isFavorite) {
        _info.isFavorite = NO;
        [_favBtn setImage:[UIImage imageNamed:@"main_cell_un_favorite.png"] forState:UIControlStateNormal];
    } else {
        _info.isFavorite = YES;
        [_favBtn setImage:[UIImage imageNamed:@"main_cell_favorite.png"] forState:UIControlStateNormal];
    }
    [self.delegate doFavorite:_info senderView:_favBtn cell:self];
}

- (void)setNumber:(NSInteger)number {
    if (!_numberTagLabel) {
        //_numberTagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag_48.png"]];
        _numberTagLabel = [[UILabel alloc] init];
        _numberTagLabel.backgroundColor = [UIColor clearColor];//[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag_32.png"]];
        _numberTagLabel.font = CHINESE_TEXT_FONT;
        _numberTagLabel.textAlignment = UITextAlignmentLeft;
        //[_numberTagImageView addSubview:_numberTagLabel];
        [_containerView addSubview:_numberTagLabel];
    }
    _numberTagLabel.text = [NSString stringWithFormat:@"%d期", number];

}


- (void)prepareForReuse {
    [super prepareForReuse];
    _info = nil;
}


@end
