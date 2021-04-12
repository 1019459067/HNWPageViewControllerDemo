//
//  HNWPageViewController.h
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.
//  视图分页控制器
//  https://github.com/mengxianliang/HNWPageViewController

#import <UIKit/UIKit.h>

@class HNWPageViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol HNWPageViewControllerDelegate <NSObject>

/**
 当页面切换完成时回调该方法，返回切换到的位置
 
 @param pageViewController 实例
 @param index 切换的位置
 */
- (void)pageViewController:(HNWPageViewController *)pageViewController
        didScrolledAtIndex:(NSInteger)index;

// 与titleView 相关
@optional
- (void)pageViewController:(HNWPageViewController *)pageViewController
titleViewAnimationProgress:(CGFloat)animationProgress;

@optional
- (void)pageViewController:(HNWPageViewController *)pageViewController
        checkScrollAtIndex:(NSInteger)index
                completion:(void(^)(BOOL finished))completion;

@end

@protocol HNWPageViewControllerDataSource <NSObject>

@required

/**
 根据index返回对应的ViewController
 
 @param pageViewController HNWPageViewController实例
 @param index 当前位置
 @return 返回要展示的ViewController
 */
- (UIViewController *)pageViewController:(HNWPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index;

/**
 要展示分页数
 
 @return 返回分页数
 */
- (NSInteger)pageViewControllerNumberOfPage;

@end

@interface HNWPageViewController : UIViewController

/**
 代理
 */
@property (nonatomic, weak) id <HNWPageViewControllerDelegate> delegate;

/**
 数据源
 */
@property (nonatomic, weak) id <HNWPageViewControllerDataSource> dataSource;

/**
 当前位置 默认是0
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 滚动开关 默认 开
 */
@property (nonatomic, assign) BOOL scrollEnabled;


- (BOOL)switchToViewControllerAdIndex:(NSInteger)index animated:(BOOL)animated;
- (void)delegateSelectedAtIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
