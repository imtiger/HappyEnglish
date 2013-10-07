//
// Created by @krq_tiger on 13-5-9.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class OneDayInfo;

#define MAIN_IMG_HEIGHT 30
#define MAIN_IMG_WIDTH 50
#define NUMBER_TAG_HEIGHT 15
#define NUMBER_TAG_WIDTH 80
#define CONTAINER_VIEW_WIDTH 310
#define CONTENT_TEXT_WIDTH CONTAINER_VIEW_WIDTH-2*MARGIN
#define DATE_WIDTH 80
#define DATE_HEIGHT 15
#define MAX_TEXT_HEIGHT 60
#define MIN_TEXT_HEIGHT 30


@protocol MainTableViewCellDelegate <NSObject>

- (void)doFavorite:(OneDayInfo *)oneDayInfo senderView:(UIView *)senderView cell:(UITableViewCell *)cell;

@end

@interface MainTableViewCell : UITableViewCell

@property(nonatomic, weak) id <MainTableViewCellDelegate> delegate;

- (void)setDataSource:(id)data;

+ (CGFloat)heightOfRowWithObject:(id)data;

- (void)resizeCell;

@end
