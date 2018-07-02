//
//  ICPlayerViewController.h
//  横屏解决方案
//
//  Created by 王志刚 on 2018/7/2.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFOrientationObserver.h"
@interface ICPlayerViewController : UIViewController

@end

@interface ICPlayerOrientationManager : NSObject
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UIView *playerView;

@end


@interface ICPlayerOrientationManager (ZFPlayerOrientationRotation)

@property (nonatomic, readonly) ZFOrientationObserver *orientationObserver;

/// Whether automatic screen rotation is supported.
/// default is YES.
@property (nonatomic) BOOL shouldAutorotate;

/// When ZFFullScreenMode is ZFFullScreenModeLandscape the orientation is LandscapeLeft or LandscapeRight, this value is YES.
/// When ZFFullScreenMode is ZFFullScreenModePortrait, while the player fullSceen this value is YES.
@property (nonatomic, readonly) BOOL isFullScreen;

/// Lock the screen orientation.
@property (nonatomic, getter=isLockedScreen) BOOL lockedScreen;

/// The statusbar hidden.
@property (nonatomic, getter=isStatusBarHidden) BOOL statusBarHidden;

/// The current orientation of the player.
/// Default is UIInterfaceOrientationPortrait.
@property (nonatomic, readonly) UIInterfaceOrientation currentOrientation;

/// The block invoked When player will rotate.
@property (nonatomic, copy, nullable) void(^orientationWillChange)(ICPlayerOrientationManager *player, BOOL isFullScreen);

/// The block invoked when player rotated.
@property (nonatomic, copy, nullable) void(^orientationDidChanged)(ICPlayerOrientationManager *player, BOOL isFullScreen);

/// Add the device orientation observer.
- (void)addDeviceOrientationObserver;

/// Remove the device orientation observer.
- (void)removeDeviceOrientationObserver;

/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModeLandscape.
- (void)enterLandscapeFullScreen:(UIInterfaceOrientation)orientation animated:(BOOL)animated;

/// Enter the fullScreen while the ZFFullScreenMode is ZFFullScreenModePortrait.
- (void)enterPortraitFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

// FullScreen mode is determined by ZFFullScreenMode
- (void)enterFullScreen:(BOOL)fullScreen animated:(BOOL)animated;

@end
