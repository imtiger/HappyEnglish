//
// Created by @krq_tiger on 13-6-9.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MultiPlayerSettingViewCell.h"
#import "Global.h"


@implementation MultiPlayerSettingViewCell {

    UILabel *_textLabel;
    UIImageView *_checkedView;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 40)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = SOURCE_LANGUAGE_FONT(15);//[UIFont fontWithName:SOURCE_LANGUAGE_FONT_NAME size:15];
        _textLabel.textColor = [UIColor colorWithRed:105 / 255. green:105 / 255. blue:105 / 255. alpha:1];

        _checkedView = [[UIImageView alloc] initWithFrame:CGRectMake(250, 5, 25, 25)];
        _checkedView.image = [UIImage imageNamed:@"settingCell_selected.png"];
        _checkedView.hidden = YES;
        [self.contentView addSubview:_textLabel];
        [self.contentView addSubview:_checkedView];

    }

    return self;
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

- (void)setChecked:(BOOL)isChecked {
    if (isChecked) {
        _checkedView.hidden = NO;
    } else {
        _checkedView.hidden = YES;
    }
}

@end