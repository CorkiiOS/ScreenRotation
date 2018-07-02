//
//  ViewController.m
//  横屏解决方案
//
//  Created by 王志刚 on 2018/7/2.
//  Copyright © 2018年 iCorki. All rights reserved.
//



#import "ViewController.h"
#import "ZFOrientationObserver.h"
#import "ICPlayerViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if (![UIDevice currentDevice].generatesDeviceOrientationNotifications) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)handleDeviceOrientationChange {
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:([UIDevice currentDevice].orientation)];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[ICPlayerViewController new] animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
