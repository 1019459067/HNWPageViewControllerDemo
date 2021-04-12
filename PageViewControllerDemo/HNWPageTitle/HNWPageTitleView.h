//
//  HNWPageTitleView.h
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.
//  分页控制器标题栏
//  https://github.com/mengxianliang/HNWPageViewController

#import <UIKit/UIKit.h>
#import "HNWPageTitleCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HNWPageTitleView;
@protocol HNWPageTitleViewDataSource <NSObject>

@required

/**
 根据index返回对应的标题
 
 @param index 当前位置
 @return 返回要展示的标题
 */
- (NSString *)pageTitleView:(HNWPageTitleView *)view pageTitleViewTitleForIndex:(NSInteger)index;

/**
 要展示分页数
 
 @return 返回分页数
 */
- (NSInteger)pageTitleViewNumber;

@end

@protocol HNWPageTitleViewDelegate <NSObject>

/**
 选中位置代理方法

 @param index 所选位置
 */
- (void)pageTitleView:(HNWPageTitleView *)view didSelectedAtIndex:(NSInteger)index;

@optional
/**
 上次选中位置代理方法

 @param lastSelectedIndex 所选位置
 */
- (void)pageTitleView:(HNWPageTitleView *)view didSelectedAtLastSelectedIndex:(NSInteger)lastSelectedIndex;

@optional
- (void)pageTitleView:(HNWPageTitleView *)pageTitleView checkSelectAtIndex:(NSInteger)index completion:(void(^)(BOOL finished))completion;

@end

@interface HNWPageTitleView : UIView

/**
 数据源
 */
@property (nonatomic, weak) id <HNWPageTitleViewDataSource> dataSource;

/**
 代理方法
 */
@property (nonatomic, weak) id <HNWPageTitleViewDelegate> delegate;

/**
 选中位置
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 右侧按钮
 */
@property (nonatomic, strong) UIButton *rightButton;

/**
 初始化方法

 @param config 配置信息
 @return TitleView 实例
 */
- (instancetype)initWithConfig:(HNWPageViewTitleConfig *)config;

/**
 刷新数据，当标题信息改变时调用
 */
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
