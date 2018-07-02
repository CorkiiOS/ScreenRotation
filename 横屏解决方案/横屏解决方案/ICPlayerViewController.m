//
//  ICPlayerViewController.m
//  横屏解决方案
//
//  Created by 王志刚 on 2018/7/2.
//  Copyright © 2018年 iCorki. All rights reserved.
//
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#import "ICPlayerViewController.h"
#import "ZFOrientationObserver.h"
#import <objc/message.h>
@interface ICPlayerViewController ()

@property (nonatomic, strong) UIView *player;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ICPlayerOrientationManager *manager;

@end

@implementation ICPlayerViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self addDeviceOrientationObserver];
    [self.navigationController.navigationBar setHidden:YES];
}

- (ICPlayerOrientationManager *)manager {
    if (_manager == nil) {
        _manager = [[ICPlayerOrientationManager alloc] init];
        _manager.contentView = self.contentView;
        _manager.playerView = self.player;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.contentView = [UIView new];
    self.contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2);
    self.contentView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.contentView];
    
    self.player = [UIView new];
    self.player.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2);
    self.player.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.player];
    
    [self.manager addDeviceOrientationObserver];

    
    @weakify(self)
    self.manager.orientationWillChange = ^(ICPlayerOrientationManager * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
    };
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layOutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    if (self.isFullScreen) {
//        return UIStatusBarStyleLightContent;
//    }
//    return UIStatusBarStyleDefault;
//}

//- (BOOL)prefersStatusBarHidden {
//
//    NSLog(@"%ld", self.statusBarHidden);
//    return self.statusBarHidden;
//}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end

@implementation ICPlayerOrientationManager

@end

@implementation ICPlayerOrientationManager (ZFPlayerOrientationRotation)

- (void)addDeviceOrientationObserver {
    [self.orientationObserver addDeviceOrientationObserver];
}

- (void)removeDeviceOrientationObserver {
    [self.orientationObserver removeDeviceOrientationObserver];
}

- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated {
    self.orientationObserver.fullScreenMode = ZFFullScreenModeLandscape;
    [self.orientationObserver enterLandscapeFullScreen:orientation animated:animated];
}

- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    self.orientationObserver.fullScreenMode = ZFFullScreenModePortrait;
    [self.orientationObserver enterPortraitFullScreen:fullScreen animated:YES];
}

- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated {
    if (self.orientationObserver.fullScreenMode == ZFFullScreenModePortrait) {
        [self.orientationObserver enterPortraitFullScreen:fullScreen animated:YES];
    } else {
        UIInterfaceOrientation orientation = UIInterfaceOrientationUnknown;
        orientation = fullScreen? UIInterfaceOrientationLandscapeRight : UIInterfaceOrientationPortrait;
        [self.orientationObserver enterLandscapeFullScreen:orientation animated:animated];
    }
}

#pragma mark - getter

- (ZFOrientationObserver *)orientationObserver {
    if (!self.contentView && !self.playerView) return nil;
    @weakify(self)
    ZFOrientationObserver *orientationObserver = objc_getAssociatedObject(self, _cmd);
    if (!orientationObserver) {
        orientationObserver = [[ZFOrientationObserver alloc] initWithRotateView:self.playerView containerView:self.contentView];
        orientationObserver.orientationWillChange = ^(ZFOrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            @strongify(self)
            if (self.orientationWillChange) self.orientationWillChange(self, isFullScreen);
//            if ([self.controlView respondsToSelector:@selector(videoPlayer:orientationWillChange:)]) {
//                [self.controlView videoPlayer:self orientationWillChange:observer];
//            }
//            [self.controlView setNeedsLayout];
//            [self.controlView layoutIfNeeded];
        };
        orientationObserver.orientationDidChanged = ^(ZFOrientationObserver * _Nonnull observer, BOOL isFullScreen) {
            @strongify(self)
            if (self.orientationDidChanged) self.orientationDidChanged(self, isFullScreen);
//            if ([self.controlView respondsToSelector:@selector(videoPlayer:orientationDidChanged:)]) {
//                [self.controlView videoPlayer:self orientationDidChanged:observer];
//            }
        };
        objc_setAssociatedObject(self, _cmd, orientationObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return orientationObserver;
}

- (void (^)(ICPlayerOrientationManager * _Nonnull, BOOL))orientationWillChange {
    return objc_getAssociatedObject(self, _cmd);
}

- (void (^)(ICPlayerOrientationManager * _Nonnull, BOOL))orientationDidChanged {
    return objc_getAssociatedObject(self, _cmd);
}

- (BOOL)isFullScreen {
    return self.orientationObserver.isFullScreen;
}

- (UIInterfaceOrientation)currentOrientation {
    return self.orientationObserver.currentOrientation;
}

- (BOOL)isStatusBarHidden {
    return self.orientationObserver.isStatusBarHidden;
}

- (BOOL)isLockedScreen {
    return self.orientationObserver.isLockedScreen;
}

- (BOOL)shouldAutorotate {
    return self.orientationObserver.shouldAutorotate;
}

#pragma mark - setter

- (void)setOrientationWillChange:(void (^)(ICPlayerOrientationManager * _Nonnull, BOOL))orientationWillChange {
    objc_setAssociatedObject(self, @selector(orientationWillChange), orientationWillChange, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setOrientationDidChanged:(void (^)(ICPlayerOrientationManager * _Nonnull, BOOL))orientationDidChanged {
    objc_setAssociatedObject(self, @selector(orientationDidChanged), orientationDidChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setStatusBarHidden:(BOOL)statusBarHidden {
    objc_setAssociatedObject(self, @selector(isStatusBarHidden), @(statusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.statusBarHidden = statusBarHidden;
}

- (void)setLockedScreen:(BOOL)lockedScreen {
    objc_setAssociatedObject(self, @selector(isLockedScreen), @(lockedScreen), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.lockedScreen = lockedScreen;
//    if ([self.controlView respondsToSelector:@selector(lockedVideoPlayer:lockedScreen:)]) {
//        [self.controlView lockedVideoPlayer:self lockedScreen:lockedScreen];
//    }
}

- (void)setShouldAutorotate:(BOOL)shouldAutorotate {
    objc_setAssociatedObject(self, @selector(shouldAutorotate), @(shouldAutorotate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.orientationObserver.shouldAutorotate = shouldAutorotate;
}

@end

