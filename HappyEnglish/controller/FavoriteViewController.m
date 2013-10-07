//
// Created by @krq_tiger on 13-6-14.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "FavoriteViewController.h"
#import "OneDayInfoRepository.h"
#import "Global.h"
#import "OneDayInfo.h"
#import "NSDate+Helper.h"
#import "HappyEnglishAppDelegate.h"


@implementation FavoriteViewController {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self performSelector:@selector(egoRefreshReloadDataSource) withObject:nil afterDelay:0.5];
}

- (void)viewDidLoad {
    //do nothing
}


- (void)loadMoreLoadDatasource {
    int count = 0;
    NSArray *array = [_dataSource allValues];
    for (NSArray *infos in array) {
        count = count + infos.count;
    }
    NSMutableArray *infos = [[OneDayInfoRepository sharedInstance] getFavoriteEpisodesWithBeginIndex:count andPageSize:PAGE_LIMIT];
    if (!infos || infos.count == 0) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"没有更多数据了!" duration:2];
        return;
    }
    [self doneFinishedLoading:infos];
}


- (void)egoRefreshReloadDataSource {
    _dataSource = nil;
    _weeks = nil;
    NSMutableArray *infos = [[OneDayInfoRepository sharedInstance] getFavoriteEpisodesWithBeginIndex:0 andPageSize:PAGE_LIMIT];
    if (!infos || infos.count == 0) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"收藏夹为空，点击小星星收藏哦!" duration:2];
        [self.tableView reloadData];
        return;
    }
    [self doneFinishedLoading:infos];
}


#pragma mark - implement MainTableViewCellDelegate -
- (void)doFavorite:(OneDayInfo *)oneDayInfo senderView:(UIView *)senderView cell:(UITableViewCell *)cell {
    [super doFavorite:oneDayInfo senderView:senderView cell:cell];
    if (!oneDayInfo.isFavorite) {
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGRect oldFrame = cell.frame;
                             oldFrame.origin.x = oldFrame.origin.x - oldFrame.size.width;
                             cell.frame = oldFrame;
                         }
                         completion:^(BOOL finished) {
                             NSNumber *weekOfYear = [NSNumber numberWithInt:[oneDayInfo.createDate getWeekOfYear]];
                             NSMutableArray *infos = [_dataSource objectForKey:weekOfYear];
                             [infos removeObject:oneDayInfo];
                             if (infos.count == 0) {
                                 [_weeks removeObject:weekOfYear];
                             }
                             if (!_unfavorites) {
                                 _unfavorites = [[NSMutableArray alloc] init];
                             }
                             [_unfavorites addObject:oneDayInfo];
                             [self.tableView reloadData];
                         }];

    }

}


@end