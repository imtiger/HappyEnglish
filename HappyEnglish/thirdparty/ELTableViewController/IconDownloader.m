//
//  IconDownloader.m
//  RenRenTest
//
//  Created by svp on 10.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import "IconDownloader.h"

Class object_getClass(id object);

@implementation IconDownloader

@synthesize appIcon;
@synthesize imgUrl;
@synthesize imgWidth;
@synthesize imgHeight;
@synthesize indexPathInTableView;
@synthesize imgKey;
@synthesize delegate;
@synthesize activeDownload;
@synthesize imageConnection;

-(void)dealloc{
	[appIcon release];
	[imgUrl release];
	[indexPathInTableView release];
    [imgKey release];
	[activeDownload release];
	[imageConnection cancel];
	[imageConnection release];
	
	[super dealloc];
}

-(void)startDownload{
    self.activeDownload=[NSMutableData data];
    //异步加载图片
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:
                           [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl]] delegate:self];
    
    self.imageConnection=conn;
    [conn release];
}

-(void)cancelDownload{
	[self.imageConnection cancel];
	self.imageConnection=nil;
	self.activeDownload=nil;
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[self.activeDownload appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	self.activeDownload=nil;
	self.imageConnection=nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    UIImage *image=[[UIImage alloc]initWithData:self.activeDownload];
    
    if ((image.size.width!=imgWidth || image.size.height!=imgHeight)&&
        (imgWidth+imgHeight!=0)) {
        CGSize itemSize=CGSizeMake(imgWidth, imgHeight);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect=CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [image drawInRect:imageRect];
        self.appIcon=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else {
        self.appIcon=image;
    }
    
    self.activeDownload=nil;
    [image release];
    
    self.imageConnection=nil;
    
    //解决：下载没有结束，controller已被释放带来的代理方法调用失败的问题
    //added by:yh       Date:2012-09-08
    Class _currentClass=object_getClass(delegate);
    if (_currentClass==_originalClass) {
        if (self.imgKey&&(![self.imgKey isEqualToString:@""])) {
            [delegate appImageDidLoad:self.indexPathInTableView forKey:self.imgKey];
        }else{
            [delegate appImageDidLoad:self.indexPathInTableView];
        }
    }
}

#pragma mark -override setter-
-(void)setDelegate:(id<IconDownloaderDelegate>)_delegate{
    if (_delegate!=delegate) {
        delegate=_delegate;
        _originalClass=object_getClass(_delegate);
    }
}



@end
