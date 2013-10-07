//
//  ELTableViewController.h
//
//  Created by yanghua_kobe on 12/1/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreTableFooterView.h"
#import "IconDownloader.h"

//use to load image (async)
typedef void (^loadImagesForVisiableRowsFunc)(void);

typedef void (^appImageDownloadCompleted)(NSIndexPath *);

@interface ELTableViewController : UIViewController
        <
        UITableViewDelegate,
        UITableViewDataSource,
        EGORefreshTableHeaderDelegate,
        LoadMoreTableFooterDelegate,
        IconDownloaderDelegate
        >

@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *dataSource;
@property(nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

/**
 *if you havn't special Object for stone downloaded image instance, use it!
 *added by:yanghua
 *date: 2013-3-27
 */
@property(nonatomic, retain) NSMutableDictionary *imageDownloadedInstances;

@property(nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, retain) LoadMoreTableFooterView *loadMoreFooterView;

//readonly properties
@property(nonatomic, assign, readonly) BOOL refreshHeaderViewEnabled;
@property(nonatomic, assign, readonly) BOOL loadMoreFooterViewEnabled;

@property(nonatomic, assign) BOOL isRefreshing;
@property(nonatomic, assign) BOOL isLoadingMore;

//use to judge refresh or loadMore
@property(nonatomic, assign) CGPoint currentOffsetPoint;


@property(nonatomic, copy) loadImagesForVisiableRowsFunc loadImagesForVisiableRowsFunc;
@property(nonatomic, copy) appImageDownloadCompleted appImageDownloadCompleted;


- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView;

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView
                     andTableViewFrame:(CGRect)frame;

- (void)loadMoreScrollViewDataSourceDidFinishedLoading;

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading;

- (void)loadMoreLoadDatasource;

- (void)egoRefreshReloadDataSource;

@end


@interface ELTableViewController (Extension)

- (CGRect)ScreenBounds;

- (CGRect)NavigationFrame;

@end

@implementation ELTableViewController (Extension)

- (CGRect)ScreenBounds {
    CGRect bounds = [UIScreen mainScreen].bounds;
    return bounds;
}

- (CGRect)NavigationFrame {
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    return CGRectMake(0, 0, frame.size.width, frame.size.height - 44.0f);
}


@end
