//
// Created by tiger on 13-5-8.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "MainTableViewCell.h"
#import "OneDayInfo.h"
#import "MainViewController.h"
#import "JSONParser.h"
#import "NSDate+Helper.h"
#import "Global.h"
#import "OneDayInfoRepository.h"
#import "HappyEnglishAppDelegate.h"
#import "PopEpisodeViewController.h"
#import "GuideTipView.h"
#import "ShareViewController.h"
#import "ShareToWebChatViewController.h"
#import "ShareToSinaWeiboViewController.h"


@implementation MainViewController {
    PopViewController *_popViewController;
    HttpClient *_httpClient;
    GuideTipView *_tipsView;
    UIActionSheet *_shareActionSheet;
    OneDayInfo *_episode;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareEpisode:) name:DO_SHARE_KEY object:nil];
}


- (void)viewWillDisappear:(BOOL)animated {
    _episode = nil;
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DO_SHARE_KEY object:nil];
}


- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //_popViewController = [[PopOneDayViewController alloc] initWithPopViewClass:NSStringFromClass(PopOneDayView.class)];
    //[_popViewController setup:self delegate:self];
    _popViewController = [[PopEpisodeViewController alloc] initWithPopViewClass:NSStringFromClass(PopEpisodeView .class)];
    [_popViewController setup:self delegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFontSettingChanged)
                                                 name:TEXT_FONT_SETTING_CHANGED
                                               object:nil];

    BOOL singleTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:ksingleTipsDone] boolValue];
    if (!singleTipsDone) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popViewDidShow)
                                                     name:POP_VIEW_DID_SHOW
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(popViewDidHidden)
                                                     name:POP_VIEW_DID_HIDDEN
                                                   object:nil];
    }
}

- (void)popViewDidHidden {
    if (_tipsView) {
        [_tipsView removeFromSuperview];
        _tipsView = nil;
    }
    BOOL singleTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:ksingleTipsDone] boolValue];
    if (singleTipsDone) {
        [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:YES] forKey:kmultiTipsDone];
        return;
    }
    [[GlobalAppConfig sharedInstance] setValue:[NSNumber numberWithBool:YES] forKey:ksingleTipsDone];
    _tipsView = [[GuideTipView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, MAIN_SCREEN_HEIGHT- 50 - 45 - 20 - MARGIN, 150, 50) tipsText:@"向左或者向右滑动进行多期播放"];
    [self.view addSubview:_tipsView];
}

- (void)popViewDidShow {
    if (_tipsView) {
        [_tipsView removeFromSuperview];
        _tipsView = nil;
    }
    BOOL singleTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:ksingleTipsDone] boolValue];
    BOOL multiTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:kmultiTipsDone] boolValue];
    if (singleTipsDone && multiTipsDone) {
        return;
    }
    _tipsView = [[GuideTipView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, MAIN_SCREEN_HEIGHT- 50 - 45 - 20 - MARGIN, 150, 50) tipsText:@"向左或者向右滑动来隐藏播放器"];
    [self.view addSubview:_tipsView];
}

- (void)dealloc {
    [_httpClient cancel];
    _episode = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TEXT_FONT_SETTING_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:POP_VIEW_DID_SHOW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:POP_VIEW_DID_HIDDEN object:nil];
}


- (void)textFontSettingChanged {
    [self.tableView reloadData];
}

- (void)shareEpisode:(NSNotification *)notification {
    _episode = notification.object;
    //share
    _shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"分享到"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                           otherButtonTitles:@"新浪微博",
                                                             @"微信好友",
                                                             @"微信朋友圈", nil];
    [_shareActionSheet showInView:self.view];


}

#pragma mark - override super class method -
- (void)loadMoreLoadDatasource {
    int count = 0;
    NSArray *array = [_dataSource allValues];
    for (NSArray *infos in array) {
        count = count + infos.count;
    }
    _lodeType = LoadMore;
    int leastCount = 0;
    NSMutableArray *latestEpisode = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginIndex:0 andPageSize:1];
    if (latestEpisode && latestEpisode.count == 1) {
        OneDayInfo *episode = [latestEpisode objectAtIndex:0];
        leastCount = episode.issueNumber;
    }
    if (count == leastCount && count != 0) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"没有更多数据了!" duration:2];
        return;
    }
    int endNumber = leastCount - count;
    int startNumber = endNumber - LOADMORE_PAGE_LIMIT+ 1;
    if (startNumber <= 0) {
        startNumber = 1;
    }
    NSMutableArray *infos = [[OneDayInfoRepository sharedInstance] getEpisodesWithStartAndEndNumber:startNumber endNumber:endNumber];//TODO load from local db
    if (!infos || infos.count == 0) {
        [self loadBetween:startNumber endNumber:endNumber];
    } else {
        [self doneFinishedLoading:infos];
    }
    /*NSMutableArray *infos = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginIndex:count andPageSize:PAGE_LIMIT];
    if (!infos || infos.count + count < leastCount) {
        [self loadDataSource:count limit:LOADMORE_PAGE_LIMIT useCache:NO];
    } else {
        [self doneFinishedLoading:infos];
    }*/

}

- (void)egoRefreshReloadDataSource {
    _lodeType = Refresh;
    //[self loadDataSource:0 limit:PAGE_LIMIT useCache:NO];
    int localLeastCount = 0;
    NSMutableArray *latestEpisode = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginIndex:0 andPageSize:1];
    if (latestEpisode && latestEpisode.count == 1) {
        OneDayInfo *episode = [latestEpisode objectAtIndex:0];
        localLeastCount = episode.issueNumber;
    }
    [self loadBetween:localLeastCount + 1 endNumber:10000];
}

- (void)loadBetween:(int)startNumber endNumber:(int)endNumber {
    NSString *requestUrl = @"http://open.imtiger.net/englishListByNum";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%d", startNumber] forKey:@"start"];
    [dict setObject:[NSString stringWithFormat:@"%d", endNumber] forKey:@"end"];
    if (_httpClient) {
        [_httpClient cancel];
    }
    _httpClient = [[HttpClient alloc] initWithRequestUrl:requestUrl andQueryStringDictionary:dict useCache:NO delegate:self];
    [_httpClient doRequestAsynchronous];
}


- (void)egoRefreshScrollViewDataSourceDidFinishedLoading {
    [super egoRefreshScrollViewDataSourceDidFinishedLoading];
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading {
    [super loadMoreScrollViewDataSourceDidFinishedLoading];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self refresh];
}


- (void)loadDataSource:(int)start limit:(int)limit useCache:(BOOL)useCache {
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    [queryStrings setObject:[NSString stringWithFormat:@"%d", start] forKey:@"start"];
    [queryStrings setObject:[NSString stringWithFormat:@"%d", limit] forKey:@"limit"];
    if (_httpClient) {
        [_httpClient cancel];
    }
    _httpClient = [[HttpClient alloc] initWithRequestUrl:REQUEST_URL andQueryStringDictionary:queryStrings useCache:useCache delegate:self];
    [_httpClient doRequestAsynchronous];
}



#pragma mark - implement PopViewControllerDelegate -
/*- (NSObject *)getDataAtPoint:(CGPoint)point {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (!indexPath) {
        return nil;
    }
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    NSNumber *section = [_weeks objectAtIndex:indexPath.section];
    return [[_dataSource objectForKey:section] objectAtIndex:indexPath.row];
}

- (UIView *)getViewHavingData {
    return self.tableView;
}*/

- (UIView *)getContainerView {
    return self.view.superview.superview;
}




#pragma mark - implement tableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_dataSource objectForKey:[_weeks objectAtIndex:section]] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _weeks.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"第%d周", [[_weeks objectAtIndex:section] intValue]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    UIImageView *header = [[UIImageView alloc] init];
    header.image = [UIImage imageNamed:@"main_title_bg.png"];
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, 0, 100, 25)];
    int weekOfYear = [[_weeks objectAtIndex:section] intValue];
    int weekOfYearToday = [[NSDate date] getWeekOfYear];
    NSString *title;
    if (weekOfYearToday == weekOfYear) {
        title = @"本周";
    } else if (weekOfYearToday - 1 == weekOfYear) {
        title = @"上周";
    } else if (weekOfYearToday - 2 == weekOfYear) {
        title = @"上上周";
    } else {
        title = [NSString stringWithFormat:@"第%d周", weekOfYear];
    }
    sectionHeader.text = title;
    sectionHeader.font = CHINESE_TEXT_FONT;
    sectionHeader.backgroundColor = [UIColor clearColor];
    sectionHeader.textAlignment = UITextAlignmentLeft;
    [header addSubview:sectionHeader];
    [bgView addSubview:header];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"mainTableViewCell";
    MainTableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!tableViewCell) {
        tableViewCell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        tableViewCell.delegate = self;
    }
    NSMutableArray *infoOfWeek = [_dataSource objectForKey:[_weeks objectAtIndex:indexPath.section]];
    OneDayInfo *info = [infoOfWeek objectAtIndex:indexPath.row];
    if (info) {
        [tableViewCell setDataSource:info];
        [tableViewCell resizeCell];
    }
    return tableViewCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *week = [_weeks objectAtIndex:indexPath.section];
    CGFloat height = [MainTableViewCell heightOfRowWithObject:[[_dataSource objectForKey:week] objectAtIndex:indexPath.row]];
    return height;
}

#pragma mark - implement UIActionSheetDelegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImage *screenshot = [self screenshot];
    switch (buttonIndex) {
        case 0: {                                         //新浪微博
            NSLog(@"sinaweibo");
            ShareToSinaWeiboViewController *shareViewController = [[ShareToSinaWeiboViewController alloc] initWithEpisode:_episode title:@"分享到新浪微博!"];
            shareViewController.backgroundImage = screenshot;
            [self presentViewController:shareViewController animated:YES completion:nil];
        }
            break;

        case 1: {                                         //微信好友
            NSLog(@"webchat session");
            if (!([self wxCheck]))return;
            ShareToWebChatViewController *shareViewController = [[ShareToWebChatViewController alloc] initWithEpisode:_episode scene:WXSceneSession title:@"分享给微信好友"];
            shareViewController.backgroundImage = screenshot;
            [self presentViewController:shareViewController animated:YES completion:nil];
        }
            break;

        case 2: {                                         //微信朋友圈
            NSLog(@"webchat timeline");
            if (!([self wxCheck]))return;
            ShareToWebChatViewController *shareViewController = [[ShareToWebChatViewController alloc] initWithEpisode:_episode scene:WXSceneTimeline title:@"分享到微信朋友圈"];
            shareViewController.backgroundImage = screenshot;
            [self presentViewController:shareViewController animated:YES completion:nil];
        }

        default:
            break;
    }
}

- (BOOL)wxCheck {
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"微信未安装");
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"您还未安装微信!" duration:2];
        return NO;
    }
    if (![WXApi isWXAppSupportApi]) {
        NSLog(@"微信版本不支持分享！");
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"微信版本不支持分享!" duration:2];
        return NO;
    }
    return YES;
}


#pragma mark - implement tableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *week = [_weeks objectAtIndex:indexPath.section];
    OneDayInfo *oneDayInfo = [[_dataSource objectForKey:week] objectAtIndex:indexPath.row];
    _popViewController.data = oneDayInfo;
    [_popViewController showInView:self.getContainerView animation:YES];
    if (_tipsView) {
        [_tipsView removeFromSuperview];
        _tipsView = nil;
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - implement MainTableViewCellDelegate -
- (void)doFavorite:(OneDayInfo *)oneDayInfo senderView:(UIView *)senderView cell:(UITableViewCell *)cell {
    [[OneDayInfoRepository sharedInstance] updateOneDayInfo:oneDayInfo];
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:senderView, @"senderView", cell, @"cell", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:DO_FAVORITE_KEY object:oneDayInfo userInfo:userInfo];// :DO_FAVORITE_KEY object:oneDayInfo];

}


#pragma mark - implement HttpClientDelegate -
- (void)httpClient:(HttpClient *)httpClient withRequestedData:(NSData *)data {
    NSArray *infos = [JSONParser parseOneDayInfos:data];
    for (OneDayInfo *oneDayInfo in infos) {
        OneDayInfoRepository *repository = [OneDayInfoRepository sharedInstance];
        [repository createOneDayInfo:oneDayInfo];
        oneDayInfo.isFavorite = [repository isFavorite:oneDayInfo];
    }
    //[[AudiosDownloader sharedInstance] start:infos];
    [self doneFinishedLoading:infos];
    if (infos && infos.count > 0) {
        BOOL singleTipsDone = [[[GlobalAppConfig sharedInstance] valueForKey:ksingleTipsDone] boolValue];
        if (!singleTipsDone) {
            if (_tipsView) {
                [_tipsView removeFromSuperview];
                _tipsView = nil;
            }
            _tipsView = [[GuideTipView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, MAIN_SCREEN_HEIGHT- 50 - 45 - 20 - MARGIN, 150, 50) tipsText:@"点击上面任何一期节目进行单期播放"];
            [self.view addSubview:_tipsView];
        }
    }
}

- (void)httpClient:(HttpClient *)httpClient withError:(NSError *)error {
    NetworkStatus networkStatus = [HappyEnglishAppDelegate sharedAppDelegate].networkStatus;
    if (networkStatus == NotReachable) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"无网络连接，请联网重试！" duration:2];
    } else {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"服务器出错，请稍后重试！" duration:2];
    }
}


- (void)refresh {
    NSMutableArray *infos = [[OneDayInfoRepository sharedInstance] getEpisodesWithBeginIndex:0 andPageSize:PAGE_LIMIT];
    if (infos == nil || infos.count == 0) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"数据加载中..." duration:3];
        //[self.refreshHeaderView enforceRefresh:self.tableView];
        _lodeType = Refresh;
        [self loadDataSource:0 limit:PAGE_LIMIT useCache:NO];
    } else {
        [self doneFinishedLoading:infos];
    }
}

- (void)doneFinishedLoading:(NSArray *)infos {
    /*
    switch (_lodeType) {
        case Refresh: {
            if (!infos || infos.count == 0) {
                [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"服务器出错啦，请稍后再试!" duration:3];
                return;
            }
        }
            break;
        case LoadMore: {
            if (!infos || infos.count == 0) {
                [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"没有更多数据了!" duration:2];
                return;
            }
        }
            break;
    }*/
    if (!infos || infos.count <= 0)return;
    NSMutableDictionary *allInfos = [[NSMutableDictionary alloc] init];
    for (OneDayInfo *info in infos) {
        int weekOfYear = [info.createDate getWeekOfYear];
        NSNumber *key = [NSNumber numberWithInt:weekOfYear];
        NSMutableArray *infosOfWeek = [allInfos objectForKey:key];
        if (!infosOfWeek) {
            infosOfWeek = [[NSMutableArray alloc] init];
            [allInfos setObject:infosOfWeek forKey:key];
        }
        [infosOfWeek addObject:info];
    }
    if (!_weeks) {
        _weeks = [[NSMutableArray alloc] init];
    }
    if (!_dataSource) {
        _dataSource = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *keys = [[NSMutableArray alloc] initWithArray:[allInfos allKeys]];
    [self mergeKeys:keys targetArray:_weeks];
    [self sortIntArray:_weeks];
    for (NSNumber *key in allInfos.allKeys) {
        NSMutableArray *infosOfWeek = [_dataSource objectForKey:key];
        if (!infosOfWeek) {
            NSMutableArray *object = [allInfos objectForKey:key];
            [self sortInfos:object];
            [_dataSource setObject:object forKey:key];
        } else {
            [self mergeInfos:[allInfos objectForKey:key] targetArray:infosOfWeek];
            [self sortInfos:infosOfWeek];
        }
    }
    [self.tableView reloadData];
}

- (void)mergeKeys:(NSMutableArray *)sourceArray targetArray:(NSMutableArray *)targetArray {
    for (NSNumber *key in sourceArray) {
        if (![targetArray containsObject:key]) {
            [targetArray addObject:key];
        }
    }
}

- (void)mergeInfos:(NSMutableArray *)sourcesArray targetArray:(NSMutableArray *)targetArray {
    for (OneDayInfo *key in sourcesArray) {
        if ([targetArray containsObject:key]) {
            OneDayInfo *info = [targetArray objectAtIndex:[targetArray indexOfObject:key]];
            info.isFavorite = key.isFavorite;
        } else {
            [targetArray addObject:key];
        }
    }
}

- (void)sortInfos:(NSMutableArray *)infos {
    [infos sortUsingComparator:^NSComparisonResult(id one, id two) {
        OneDayInfo *info1 = one;
        OneDayInfo *info2 = two;
        if (![[info1 createDate] beforeDate:info2.createDate]) {
            return NSOrderedAscending;
        }
        if ([[info1 createDate] beforeDate:info2.createDate]) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];

}


- (void)sortIntArray:(NSMutableArray *)keys {
    [keys sortUsingComparator:^NSComparisonResult(id key1, id key2) {
        if ([key1 intValue] > [key2 intValue]) {
            return NSOrderedAscending;
        }
        if ([key1 intValue] < [key2 intValue]) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
}


- (void)reloadData:(NSMutableArray *)unFavoriteEpisodes {
    if (!unFavoriteEpisodes || unFavoriteEpisodes.count == 0) {
        return;
    }
    NSMutableArray *allEpisodes = [[NSMutableArray alloc] init];
    NSArray *allWeekEpisodes = [_dataSource allValues];
    for (NSArray *weekEpisodes in allWeekEpisodes) {
        [allEpisodes addObjectsFromArray:weekEpisodes];
    }
    int count = unFavoriteEpisodes.count;
    for (OneDayInfo *episode in allEpisodes) {
        if ([unFavoriteEpisodes containsObject:episode]) {
            episode.isFavorite = NO;
            count--;
        }
        if (count == 0) {
            break;
        }
    }
    [self.tableView reloadData];
}

- (UIImage *)screenshot {
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}
@end