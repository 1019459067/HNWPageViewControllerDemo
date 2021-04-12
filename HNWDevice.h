//
//  HNWDevice.h
//  huinongwang
//
//  Created by Young on 2020/1/10.
//  Copyright © 2020 cnhnb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HNWDevice : NSObject

/// 环境设置
+ (void)setupEnvironment;

/// 主屏幕宽度，返回 UIScreen.mainScreen.bounds.size.width
@property (class, nonatomic, readonly) CGFloat screenWidth;

/// 主屏幕高度，返回 UIScreen.mainScreen.bounds.size.height
@property (class, nonatomic, readonly) CGFloat screenHeight;

/// 导航栏高度
@property (class, nonatomic, readonly) CGFloat navigationBarHeight;

/// 导航栏显示时 顶部安全边距（即 statusBar height + navigationBar height）
@property (class, nonatomic, readonly) CGFloat safeAreaTopInsetWhenNavigationBarShow;
/// 导航栏隐藏时 顶部安全边距（即 statusBar height）
@property (class, nonatomic, readonly) CGFloat safeAreaTopInsetWhenNavigationBarHidden;

/// TabBar 或 ToolBar 显示时 底部安全边距
@property (class, nonatomic, readonly) CGFloat safeAreaBottomInsetWhenBottomBarShow;
/// TabBar 或 ToolBar 隐藏时 底部安全边距
@property (class, nonatomic, readonly) CGFloat safeAreaBottomInsetWhenBottomBarHidden;

@end

NS_ASSUME_NONNULL_END
