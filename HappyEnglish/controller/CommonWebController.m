//
// Created by @krq_tiger on 13-6-20.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "CommonWebController.h"
#import "HappyEnglishAppDelegate.h"
#import "Global.h"
#import "StringUtils.h"


@implementation CommonWebController {
    HttpClient *_httpClient;
    UIActionSheet *_actionSheet;
    NSString *_selectedUrl;
    NSTimer *_timer;
    UIActivityIndicatorView *_activityIndicatorView;
    BOOL _hasToolbar;
    UIBarButtonItem *_backItem;
    UIBarButtonItem *_forwardItem;
    UIBarButtonItem *_refreshItem;
    BOOL _toolbarIsShow;

}


- (id)initWithRequestUrl:(NSString *)requestUrl name:(NSString *)name {
    self = [super init];
    if (self) {
        _requestUrl = requestUrl;
        _name = name;
        _hasToolbar = NO;
    }

    return self;
}

- (id)initWithRequestUrl:(NSString *)requestUrl name:(NSString *)name hasToolbar:(BOOL)hasToolBar {
    self = [self initWithRequestUrl:requestUrl name:name];
    if (self) {
        _hasToolbar = hasToolBar;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    /*  LocalNSURLCache *cache = [[LocalNSURLCache alloc] init];
      [cache setMemoryCapacity:4 * 1024 * 1024];
      [cache setDiskCapacity:10 * 1024 * 1024];
      [NSURLCache setSharedURLCache:cache];*/
    if (_hasToolbar) {
        //_toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 2 * 44, self.view.frame.size.width, 44)];
        //_toolBar.backgroundColor = [UIColor blackColor];
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //_backItem = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav_back.png"]]];
        _backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        _forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_forward.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
        _refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
        NSArray *items = [[NSArray alloc] initWithObjects:_backItem, flexibleItem, _forwardItem, flexibleItem, _refreshItem, nil];
        //[_toolBar setItems:items animated:YES];
        //[self.view addSubview:_toolBar];
        [self setToolbarItems:items];
        //[self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar_background_img.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
        [self.navigationController setToolbarHidden:YES];
        [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
        _backItem.enabled = NO;
        _forwardItem.enabled = NO;
        _refreshItem.enabled = NO;
    }

    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _hasToolbar && _toolbarIsShow ? self.view.frame.size.height - 2 * 44 : self.view.frame.size.height - 44)];
    _webView.delegate = self;
    _webView.opaque = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    if ([HappyEnglishAppDelegate sharedAppDelegate].networkStatus == NotReachable) {
        NSString *path = [REMOTE_FILE_CACHE_FOLDER stringByAppendingPathComponent:[StringUtils md5:_requestUrl]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"无网络连接，加载本地缓存内容!" duration:2];
            //NSLog(@"path=%@", path);
            [_webView loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
        } else {
            [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"无网络连接，请打开网络访问!" duration:2];
        }
    } else {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestUrl]]];
    }
    //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:3600]];

    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [_webView addGestureRecognizer:recognizer];
    recognizer.minimumPressDuration = 1.0f;
    recognizer.delegate = self;
    if (_hasToolbar) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHiddenToolbar)];
        [_webView addGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer.delegate = self;
    }

    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = CGRectMake(0, 0, 50, 50);
    _activityIndicatorView.center = self.view.center;
    _activityIndicatorView.hidden = YES;
    _activityIndicatorView.backgroundColor = [UIColor clearColor];
    _activityIndicatorView.contentMode = UIViewContentModeCenter;
    _activityIndicatorView.hidesWhenStopped = YES;
    [self.view addSubview:_activityIndicatorView];

}

- (void)showOrHiddenToolbar {
    if (_toolbarIsShow) {
        [self.navigationController setToolbarHidden:YES animated:YES];
        _toolbarIsShow = NO;
    } else {
        [self.navigationController setToolbarHidden:NO  animated:YES];
        _toolbarIsShow = YES;
    }
}

- (void)refresh {
    if (_webView) {
        [_webView reload];
    }
}

- (void)goForward {
    if (_webView) {
        [_webView goForward];
    }
}

- (void)goBack {
    if (_webView) {
        [_webView goBack];
    }
}

- (void)returnCallback {
    if (_httpClient) {
        [_httpClient cancel];
        _httpClient = nil;
    }
    _selectedUrl = nil;
    if (_actionSheet) {
        [_actionSheet removeFromSuperview];
        _actionSheet = nil;
    }
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [_webView stopLoading];
    _webView = nil;
}


#pragma mark  - implement UIWebViewDelegate -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *currentURl = request.URL.absoluteString;
    //NSLog(@"shouldStartLoadWithRequest.currenturl=%@", currentURl);
    if ([currentURl isEqualToString:_requestUrl]) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(loadLocalData) userInfo:nil repeats:NO];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    _activityIndicatorView.hidden = NO;
    [_activityIndicatorView startAnimating];
    NSString *currentURL = webView.request.URL.absoluteString;
    //NSLog(@"webViewDidStartLoad:currenturl=%@", currentURL);
}

- (void)loadLocalData {
    if (_activityIndicatorView) {
        [_activityIndicatorView stopAnimating];
    }
    NSString *currentURL = _webView.request.URL.absoluteString;
    if (!currentURL || currentURL.length == 0) {
        return;
    }
    NSString *path = [REMOTE_FILE_CACHE_FOLDER stringByAppendingPathComponent:[StringUtils md5:currentURL]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [_webView stopLoading];
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"网络太慢，加载本地缓存内容!" duration:1];
        //NSLog(@"path=%@", path);
        [_webView loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityIndicatorView stopAnimating];
    [_timer invalidate];
    NSString *currentURL = webView.request.URL.absoluteString;
    NSString *mimeType = [webView.request valueForHTTPHeaderField:@"Content-Type"];
    //NSLog(@"webViewDidFinishLoad.currenturl=%@,mimeType=%@", currentURL, mimeType);
    if ([currentURL isEqualToString:_requestUrl]) {
        NSString *html = [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:REMOTE_FILE_CACHE_FOLDER]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:REMOTE_FILE_CACHE_FOLDER withIntermediateDirectories:YES attributes:nil error:nil];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *path = [REMOTE_FILE_CACHE_FOLDER stringByAppendingPathComponent:[StringUtils md5:currentURL]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
            [html writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
        });
    }
    if ([_webView canGoBack]) {
        _backItem.enabled = YES;
    }
    if ([_webView canGoForward]) {
        _forwardItem.enabled = YES;
    }
    _refreshItem.enabled = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _activityIndicatorView.hidden = YES;
    [_activityIndicatorView stopAnimating];
    [_timer invalidate];
    _timer = nil;
    NSString *currentURL = webView.request.URL.absoluteString;
    if ([currentURL isEqualToString:_requestUrl]) {
        NSString *path = [REMOTE_FILE_CACHE_FOLDER stringByAppendingPathComponent:[StringUtils md5:currentURL]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [_webView stopLoading];
            [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"请求数据出错，加载本地缓存内容!" duration:1];
            [_webView loadHTMLString:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
        }
    }
}


#pragma mark - implement UIGestureRecognizeDelegate  -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}



#pragma mark - implement HttpClientDelegate - 
- (void)httpClient:(HttpClient *)httpClient withRequestedData:(NSData *)data {
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)httpClient:(HttpClient *)httpClient withError:(NSError *)error {
    [_activityIndicatorView stopAnimating];
    [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"图片保存失败，请稍后再试!" duration:2];
}

#pragma mark - implement ActionSheetDelegate -
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"保存图片"]) {
        _httpClient = [[HttpClient alloc] initWithRequestUrl:_selectedUrl andQueryStringDictionary:nil useCache:YES delegate:self];
        [_httpClient doRequestAsynchronous];
        _activityIndicatorView.hidden = NO;
        [_activityIndicatorView startAnimating];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}


- (void)longPressed :(UILongPressGestureRecognizer *)sender {
    int scrollPositionY = [[_webView stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] intValue];
    int scrollPositionX = [[_webView stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] intValue];
    int displayWidth = [[_webView stringByEvaluatingJavaScriptFromString:@"window.outerWidth"] intValue];
    CGFloat scale = _webView.frame.size.width / displayWidth;
    CGPoint pt = [sender locationInView:_webView];
    pt.x *= scale;
    pt.y *= scale;
    pt.x += scrollPositionX;
    pt.y += scrollPositionY;

    NSString *js = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).tagName", pt.x, pt.y];
    NSString *tagName = [_webView stringByEvaluatingJavaScriptFromString:js];
    if ([tagName isEqualToString:@"IMG"]) {
        if (_selectedUrl) {
            return;
        }
        NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
        _selectedUrl = [_webView stringByEvaluatingJavaScriptFromString:imgURL];
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
        [_actionSheet showInView:self.view];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [_activityIndicatorView stopAnimating];
    if (error) {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"图片保存失败!" duration:2];
    }
    else {
        [[HappyEnglishAppDelegate sharedAppDelegate] showHUDTextOnlyInfo:@"图片保存成功!" duration:2];
    }
    [_actionSheet removeFromSuperview];
    _actionSheet = nil;
    _selectedUrl = nil;
    _httpClient = nil;
}

- (void)dealloc {
    [_httpClient cancel];
    _httpClient = nil;
    [_timer invalidate];
    _timer = nil;
    [_webView stopLoading];
    _webView = nil;
    [NSURLCache setSharedURLCache:nil];
}


@end