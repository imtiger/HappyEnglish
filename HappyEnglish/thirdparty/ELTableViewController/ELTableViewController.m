//
//  ELTableViewController.m
//  FastEasyBlog
//
//  Created by yanghua_kobe on 12/1/12.
//  Copyright (c) 2012 yanghua_kobe. All rights reserved.
//

#import "ELTableViewController.h"

@interface ELTableViewController ()

@property(nonatomic, assign) CGRect tableViewFrame;

- (void)initTableView;

- (void)initRefreshHeaderView;

- (void)initLoadMoreFooterView;

@end

@implementation ELTableViewController

@synthesize tableViewFrame;
@synthesize tableView = _tableView;
@synthesize dataSource = _dataSource;
@synthesize imageDownloadsInProgress = _imageDownloadsInProgress;
@synthesize imageDownloadedInstances = _imageDownloadedInstances;

@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize loadMoreFooterView = _loadMoreFooterView;

@synthesize loadMoreFooterViewEnabled;
@synthesize refreshHeaderViewEnabled;

@synthesize isRefreshing;
@synthesize isLoadingMore;

@synthesize currentOffsetPoint;


@synthesize loadImagesForVisiableRowsFunc = _loadImagesForVisiableRowsFunc;
@synthesize appImageDownloadCompleted = _appImageDownloadCompleted;

- (void)dealloc {
    [_tableView release], _tableView = nil;
    [_refreshHeaderView release], _refreshHeaderView = nil;
    [_loadMoreFooterView release], _loadMoreFooterView = nil;
    [_imageDownloadsInProgress release], _imageDownloadsInProgress = nil;
    [_imageDownloadedInstances release], _imageDownloadedInstances = nil;

    [_dataSource release], _dataSource = nil;

    [_loadImagesForVisiableRowsFunc release], _loadImagesForVisiableRowsFunc = nil;
    [_appImageDownloadCompleted release], _appImageDownloadCompleted = nil;

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView {
    if (self = [super init]) {
        refreshHeaderViewEnabled = enableRefreshHeaderView;
        loadMoreFooterViewEnabled = enableLoadMoreFooterView;
    }

    return self;
}

- (id)initWithRefreshHeaderViewEnabled:(BOOL)enableRefreshHeaderView
          andLoadMoreFooterViewEnabled:(BOOL)enableLoadMoreFooterView
                     andTableViewFrame:(CGRect)frame {
    if (self = [self initWithRefreshHeaderViewEnabled:enableRefreshHeaderView andLoadMoreFooterViewEnabled:enableLoadMoreFooterView]) {
        tableViewFrame = frame;
    }

    return self;
}

- (void)loadView {
    if (nil != self.nibName) {
        [super loadView];

    } else {
        if (CGRectEqualToRect(self.tableViewFrame, CGRectZero)) {
            self.tableViewFrame = self.wantsFullScreenLayout ? [self ScreenBounds] : [self NavigationFrame];
        }
        self.view = [[[UIView alloc] initWithFrame:self.tableViewFrame] autorelease];
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }

    [self initTableView];
    if (self.refreshHeaderViewEnabled) {
        [self initRefreshHeaderView];
    }

    if (self.loadMoreFooterViewEnabled) {
        [self initLoadMoreFooterView];
    }
    [self initBlocks];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - public methods -
- (void)initBlocks {
    //to be override
}

#pragma mark - private methods -
- (void)initTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                              style:UITableViewStylePlain];

    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)initRefreshHeaderView {
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
            CGRectMake(0.0f,
                    0.0f - self.tableView.bounds.size.height,
                    self.view.frame.size.width,
                    self.tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [self.tableView addSubview:self.refreshHeaderView];
}

- (void)initLoadMoreFooterView {
    _loadMoreFooterView = [[LoadMoreTableFooterView alloc] initWithFrame:
            CGRectMake(0.0f,
                    self.tableView.contentSize.height,
                    self.tableView.frame.size.width,
                    self.tableView.bounds.size.height)];
    _loadMoreFooterView.delegate = self;
    [self.tableView addSubview:self.loadMoreFooterView];
}



#pragma mark - LoadMoreTableFooterDelegate Methods -
- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreTableFooterView *)view {
    [self loadMoreLoadDatasource];
    [self performSelector:@selector(loadMoreScrollViewDataSourceDidFinishedLoading) withObject:self afterDelay:3.0];
    self.isLoadingMore = YES;
}


- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreTableFooterView *)view {
    return self.isLoadingMore;
}

#pragma mark - EGORefreshTableHeaderDelegate Methods -
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    [self egoRefreshReloadDataSource];
    [self performSelector:@selector(egoRefreshScrollViewDataSourceDidFinishedLoading) withObject:self afterDelay:3.0];
    self.isRefreshing = YES;

}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    return self.isRefreshing;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view {
    return [NSDate date];
}

#pragma mark - done refresh or loadMore completed hook method -

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading {
    self.isRefreshing = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

- (void)loadMoreScrollViewDataSourceDidFinishedLoading {
    self.isLoadingMore = NO;
    [self.loadMoreFooterView loadMoreScrollViewDataSourceDidFinishedLoading:self.tableView];
};

#pragma mark - UIScrollViewDelegate Methods -
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    self.currentOffsetPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint pt = scrollView.contentOffset;
    if (self.currentOffsetPoint.y < pt.y) {
        [self.loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
    } else {
        [self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGPoint pt = scrollView.contentOffset;
    if (self.currentOffsetPoint.y < pt.y) {
        [self.loadMoreFooterView loadMoreScrollViewDidEndDragging:scrollView];
    } else {
        [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }

    if (!decelerate && self.loadImagesForVisiableRowsFunc) {
        self.loadImagesForVisiableRowsFunc();
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.loadImagesForVisiableRowsFunc) {
        self.loadImagesForVisiableRowsFunc();
    }
}

#pragma mark - download image async -
- (void)appImageDidLoad:(NSIndexPath *)indexPath {
    if (self.appImageDownloadCompleted) {
        self.appImageDownloadCompleted(indexPath);
    }
}


@end
