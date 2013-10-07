//
// Created by @krq_tiger on 13-6-19.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <MediaPlayer/MediaPlayer.h>
#import "TestController.h"
#import "TestView.h"


@implementation TestController {
    UIView *_one;
    UIView *_two;

    UIView *_three;
    UITableView *_tableView;
    NSTimer *_timer;
    MPMoviePlayerController *_player;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    /* float y = 0;
     NSString *text = @"I know the process is frustrating,but it's so worth it";
     CGSize englishTextSize = [text sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(310, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
     UITextView *label = [[UITextView alloc] initWithFrame:CGRectMake(0, y, 310, englishTextSize.height)];
     [self.view addSubview:label];
     label.text = text;
     label.font = ENGLISH_TEXT__SETTING_FONT;
     //label.numberOfLines = 0;
     //label.lineBreakMode = UILineBreakModeTailTruncation;
     y = y + label.frame.size.height + 20;
     NSLog(@"UILineBreakModeTailTruncation=%@", NSStringFromCGSize(englishTextSize));

     englishTextSize = [text sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(310, CGFLOAT_MAX) lineBreakMode:UILineBreakModeHeadTruncation];
     UITextView *label1 = [[UITextView alloc] initWithFrame:CGRectMake(0, y, 310, englishTextSize.height)];
     [self.view addSubview:label1];
     label1.text = text;
     label1.font = ENGLISH_TEXT__SETTING_FONT;
     label1.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8);

     //label1.numberOfLines = 0;
     //label1.lineBreakMode = UILineBreakModeHeadTruncation;
     y = y + label.frame.size.height + 20;
     NSLog(@"UILineBreakModeHeadTruncation=%@", NSStringFromCGSize(englishTextSize));

     englishTextSize = [text sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(310, CGFLOAT_MAX) lineBreakMode:UILineBreakModeClip];
     UITextView *label2 = [[UITextView alloc] initWithFrame:CGRectMake(0, y, 310, englishTextSize.height)];
     [self.view addSubview:label2];
     label2.text = text;
     label2.font = ENGLISH_TEXT__SETTING_FONT;
     label2.contentInset = UIEdgeInsetsMake(-8, -8, -8, -8);
     label2.editable = NO;


     //label2.numberOfLines = 0;
     //label1.lineBreakMode = UILineBreakModeClip;
     y = y + label2.frame.size.height + 20;
     NSLog(@"UILineBreakModeClip=%@", NSStringFromCGSize(englishTextSize));

     englishTextSize = [text sizeWithFont:ENGLISH_TEXT__SETTING_FONT constrainedToSize:CGSizeMake(310, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
     UITextView *label3 = [[UITextView alloc] initWithFrame:CGRectMake(0, y, 310, englishTextSize.height)];
     [self.view addSubview:label3];
     label3.text = text;
     label3.font = ENGLISH_TEXT__SETTING_FONT;

     //label3.numberOfLines = 0;
     //label1.lineBreakMode = UILineBreakModeCharacterWrap;
     NSLog(@"UILineBreakModeCharacterWrap=%@", NSStringFromCGSize(englishTextSize));*/

    /* UIView *one = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
     one.backgroundColor = [UIColor greenColor];
     _one = one;
     [self.view addSubview:one];

     UIView *three = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 40)];
     three.backgroundColor = [UIColor blackColor];
     _three = three;
     [_one addSubview:three];

     UIView *two = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 300)];
     two.backgroundColor = [UIColor greenColor];
     _two = two;
     [self.view addSubview:two];

     _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
     _tableView.delegate = self;
     _tableView.dataSource = self;

     [_two addSubview:_tableView];


     *//*UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;*//*

    UIPanGestureRecognizer *tapGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;*/


    TestView *testView = [[TestView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    testView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:testView];
/*
    _player = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"http://audiofile.oss.aliyuncs.com/124-explain.mp3?spm=0.0.0.0.SvIIbJ&file=124-explain.mp3"]];
    [_player play];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(updatePlayProgress)
                                            userInfo:nil
                                             repeats:YES];*/


}

- (void)updatePlayProgress {
    NSLog(@"current=%f,time=%f,palytime=%f", _player.currentPlaybackTime, _player.duration, _player.playableDuration);
}

- (void)tap:(id)sender {
    UITapGestureRecognizer *recognizer = sender;
    CGPoint point = [recognizer locationInView:self.view];
    NSLog(@"self.view=%@", NSStringFromCGPoint(point));

    point = [recognizer locationInView:_one];
    NSLog(@"one=%@", NSStringFromCGPoint(point));


    point = [recognizer locationInView:_two];
    NSLog(@"two=%@", NSStringFromCGPoint(point));

    point = [recognizer locationInView:_three];
    NSLog(@"three=%@", NSStringFromCGPoint(point));
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test"];
    cell.textLabel.text = @"test";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicke=%@", indexPath);
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([touch.view isDescendantOfView:_tableView]) {

        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    return YES;
}


@end