//
// Created by @krq_tiger on 13-5-8.
// Copyright (c) 2013 @krq_tiger. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "ELTableViewController.h"
#import "PopView.h"
#import "PopViewController.h"
#import "HttpClient.h"
#import "MainTableViewCell.h"

@class MBProgressHUD;


typedef enum {
    Refresh = 0,
    LoadMore = 1,
} LoadType;

@interface MainViewController : ELTableViewController <PopViewControllerDelegate, HttpClientDelegate, MainTableViewCellDelegate, UIActionSheetDelegate> {
    NSMutableDictionary *_dataSource;
    LoadType _lodeType;
    NSMutableArray *_weeks;

}

- (void)doneFinishedLoading:(NSArray *)infos;

- (void)refresh;

- (void)reloadData:(NSMutableArray *)unFavoriteEpisodes;
@end