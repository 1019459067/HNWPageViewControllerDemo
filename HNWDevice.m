//
//  HNWDevice.m
//  huinongwang
//
//  Created by Young on 2020/1/10.
//  Copyright © 2020 cnhnb. All rights reserved.
//

#import "HNWDevice.h"

#define HNWDevicePrivateSingletonInstance [HNWDevice privateSingletonInstance]

@interface HNWDevice () {
    BOOL _isResetAllValuesRequired;
    UIWindow *_appropriateWindow;
    CGFloat _navigationBarHeight;
    CGFloat _safeAreaTopInsetWhenNavigationBarShow;
    CGFloat _safeAreaTopInsetWhenNavigationBarHidden;
    CGFloat _safeAreaBottomInsetWhenBottomBarShow;
    CGFloat _safeAreaBottomInsetWhenBottomBarHidden;
}
@end

@implementation HNWDevice

#pragma mark - Public
+ (void)setupEnvironment {
    if (NSThread.isMainThread) {
        [HNWDevicePrivateSingletonInstance hnwResetAllValues];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [HNWDevicePrivateSingletonInstance hnwResetAllValues];
        });
    }
}

+ (CGFloat)screenWidth {
    return UIScreen.mainScreen.bounds.size.width;
}

+ (CGFloat)screenHeight {
    return UIScreen.mainScreen.bounds.size.height;
}

+ (CGFloat)navigationBarHeight {
    return HNWDevicePrivateSingletonInstance->_navigationBarHeight;
}

+ (CGFloat)safeAreaTopInsetWhenNavigationBarShow {
    return HNWDevicePrivateSingletonInstance->_safeAreaTopInsetWhenNavigationBarShow;
}

+ (CGFloat)safeAreaTopInsetWhenNavigationBarHidden {
    return HNWDevicePrivateSingletonInstance->_safeAreaTopInsetWhenNavigationBarHidden;
}

+ (CGFloat)safeAreaBottomInsetWhenBottomBarShow {
    return HNWDevicePrivateSingletonInstance->_safeAreaBottomInsetWhenBottomBarShow;
}

+ (CGFloat)safeAreaBottomInsetWhenBottomBarHidden {
    return HNWDevicePrivateSingletonInstance->_safeAreaBottomInsetWhenBottomBarHidden;
}

#pragma mark - Private
- (instancetype)init {
    self = [super init];
    if (self) {
        _isResetAllValuesRequired = YES;
    }
    return self;
}

+ (HNWDevice *)privateSingletonInstance {
    static HNWDevice *device = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        device = [[HNWDevice alloc] init];
    });
    return device;
}

- (void)hnwResetAllValues {
    // 重置标识
    if (!_isResetAllValuesRequired) {
        return;
    }
    _isResetAllValuesRequired = NO;
    // 创建适配场景
    UIViewController *rootViewController = [[UIViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[navigationController];
    [navigationController setNavigationBarHidden:NO animated:NO];
    navigationController.navigationBar.translucent = YES;
    tabBarController.tabBar.translucent = YES;
    // 创建临时 window
    _appropriateWindow = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _appropriateWindow.rootViewController = tabBarController;
    _appropriateWindow.windowLevel = UIWindowLevelNormal - 1;
    _appropriateWindow.backgroundColor = UIColor.whiteColor;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        _appropriateWindow.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
    _appropriateWindow.hidden = NO;
    [_appropriateWindow setNeedsLayout];
    [_appropriateWindow layoutIfNeeded];
    // 计算各项高度
    if (@available(iOS 11.0, *)) {
        _safeAreaTopInsetWhenNavigationBarHidden = tabBarController.view.safeAreaInsets.top;
        _safeAreaTopInsetWhenNavigationBarShow = rootViewController.view.safeAreaInsets.top;
        _safeAreaBottomInsetWhenBottomBarHidden = tabBarController.view.safeAreaInsets.bottom;
        _safeAreaBottomInsetWhenBottomBarShow = rootViewController.view.safeAreaInsets.bottom;
    } else {
        _safeAreaTopInsetWhenNavigationBarHidden = UIApplication.sharedApplication.statusBarFrame.size.height;
        _safeAreaTopInsetWhenNavigationBarShow = rootViewController.topLayoutGuide.length;
        _safeAreaBottomInsetWhenBottomBarHidden = 0;
        _safeAreaBottomInsetWhenBottomBarShow = rootViewController.bottomLayoutGuide.length;
    }
    _navigationBarHeight = _safeAreaTopInsetWhenNavigationBarShow - _safeAreaTopInsetWhenNavigationBarHidden;
    // 释放 window
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_appropriateWindow.hidden = YES;
        self->_appropriateWindow = nil;
    });
}

@end
