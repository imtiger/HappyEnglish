//
// Created by @krq_tiger on 13-6-28.
// Copyright (c) 2013 kariqu. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SettingBaseChildController.h"
#import "Global.h"


@implementation SettingBaseChildController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([NSStringFromClass(self.parentViewController.class) isEqualToString:@"UINavigationController"]) {
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 45)];
        titleView.text = _name;
        titleView.textAlignment = UITextAlignmentCenter;
        titleView.font = CHINESE_TITLE_FONT;
        titleView.textColor = [UIColor blackColor];
        titleView.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = titleView;
        UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 32)];
        [leftButton setImage:[UIImage imageNamed:@"nav-bar-back-button.png"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }

}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
    [self returnCallback];
    if (self.returnCallbackBlock) {
        self.returnCallbackBlock();
    }
}

- (void)returnCallback {
    //do nothing sub class override the behavior
}


@end