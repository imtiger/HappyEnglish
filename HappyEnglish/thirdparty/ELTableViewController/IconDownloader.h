//
//  IconDownloader.h
//  RenRenTest
//
//  Created by svp on 10.06.12.
//  Copyright 2012 yanghua_kobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IconDownloaderDelegate <NSObject>

@optional
-(void)appImageDidLoad:(NSIndexPath *)indexPath;

-(void)appImageDidLoad:(NSIndexPath *)indexPath forKey:(NSString*)imgKey;

@end


@interface IconDownloader : NSObject {
	UIImage *appIcon;
	NSString *imgUrl;
	
	float imgWidth;
	float imgHeight;
	
	NSIndexPath *indexPathInTableView;
    NSString *imgKey;                 //支持单元格中，多图片下载
	id <IconDownloaderDelegate> delegate;
    Class _originalClass;             //保存delegate的原始类型，处理delegate提前被释放的问题
	
	NSMutableData *activeDownload;
	NSURLConnection *imageConnection;
}

@property (nonatomic,retain) UIImage *appIcon;
@property (nonatomic,retain) NSString *imgUrl;

@property (nonatomic,assign) float imgWidth;
@property (nonatomic,assign) float imgHeight;

@property (nonatomic,retain) NSIndexPath *indexPathInTableView;
@property (nonatomic,retain) NSString *imgKey;
@property (nonatomic,assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic,retain) NSMutableData *activeDownload;
@property (nonatomic,retain) NSURLConnection *imageConnection;

-(void)startDownload;
-(void)cancelDownload;

@end
