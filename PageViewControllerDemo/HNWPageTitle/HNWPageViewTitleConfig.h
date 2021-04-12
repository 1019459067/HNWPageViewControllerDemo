//
//  HNWPageViewTitleConfig.h
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.
//  显示配置类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/**
 标题对齐，居左，居中，局右
 */
typedef NS_ENUM(NSInteger, HNWPageTitleViewAlignment) {
    HNWPageTitleViewAlignmentFull   = 0,
    HNWPageTitleViewAlignmentCustom = 1, // 自定义宽度
};

/**
 阴影末端形状，圆角、直角
 */
typedef NS_ENUM(NSInteger, HNWPageShadowLineCap) {
    HNWPageShadowLineCapRound = 0,
    HNWPageShadowLineCapSquare = 1,
};

/**
 阴影对齐
 */
typedef NS_ENUM(NSInteger, HNWPageShadowLineAlignment) {
    HNWPageShadowLineAlignmentBottom = 0,
    HNWPageShadowLineAlignmentCenter = 1,
    HNWPageShadowLineAlignmentTop = 2,
};


/**
 阴影动画类型，平移、缩放、无动画
 */
typedef NS_ENUM(NSInteger, HNWPageShadowLineAnimationType) {
    HNWPageShadowLineAnimationTypePan = 0,
    HNWPageShadowLineAnimationTypeZoom = 1,
    HNWPageShadowLineAnimationTypeNone = 2,
};


NS_ASSUME_NONNULL_BEGIN

@interface HNWPageViewTitleConfig : NSObject

/**
 标题正常颜色 默认 grayColor
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 标题选中颜色 默认 blackColor
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/**
 标题正常字体 默认 标准字体18
 */
@property (nonatomic, strong) UIFont *titleNormalFont;

/**
 标题选中字体 默认 标准粗体18
 */
@property (nonatomic, strong) UIFont *titleSelectedFont;

/**
 标题宽度 默认 文字长度
 */
@property (nonatomic, assign) CGFloat titleWidth;

/**
 标题视图总宽度，默认 106  HNWPageTitleViewAlignmentCustom 时有效
 */
@property (nonatomic, assign) CGFloat titleViewWidth;

/**
 标题栏高度 默认 40
 */
@property (nonatomic, assign) CGFloat titleViewHeight;

/**
 标题栏背景色 默认 透明
 */
@property (nonatomic, strong) UIColor *titleViewBackgroundColor;

/**
 标题栏显示位置 默认 HNWPageTitleViewAlignmentLeft（只在标题总长度小于屏幕宽度时有效）
 */
@property (nonatomic, assign) HNWPageTitleViewAlignment titleViewAlignment;

/**
 是否在NavigationBar上显示标题栏 默认NO
 */
@property (nonatomic, assign) BOOL showTitleInNavigationBar;

/**
 隐藏底部阴影 默认 NO
 */
@property (nonatomic, assign) BOOL shadowLineHidden;

/**
 阴影高度 默认 3.0f
 */
@property (nonatomic, assign) CGFloat shadowLineHeight;


/**
 阴影宽度 默认 30.0f
 */
@property (nonatomic, assign) CGFloat shadowLineWidth;

/**
 阴影颜色 默认 黑色
 */
@property (nonatomic, strong) UIColor *shadowLineColor;

/**
 阴影末端形状 默认 HNWPageShadowLineCapRound
 */
@property (nonatomic, assign) HNWPageShadowLineCap shadowLineCap;

/**
 默认动画效果 默认 HNWPageShadowLineAnimationTypePan
 */
@property (nonatomic, assign) HNWPageShadowLineAnimationType shadowLineAnimationType;

/**
 阴影对齐 默认HNWPageShadowLineAlignmentBottom
 */
@property (nonatomic, assign) HNWPageShadowLineAlignment shadowLineAlignment;

/**
 隐藏底部分割线 默认 NO
 */
@property (nonatomic, assign) BOOL separatorLineHidden;

/**
 底部分割线高度 默认 0.5
 */
@property (nonatomic, assign) CGFloat separatorLineHeight;

/**
 底部分割线颜色 默认 lightGrayColor
 */
@property (nonatomic, strong) UIColor *separatorLineColor;

// 选中的图片
@property (strong, nonatomic) NSDictionary *iconDictInfo;

/**
 默认初始化方法
 */
+ (HNWPageViewTitleConfig *)defaultConfig;

@end

NS_ASSUME_NONNULL_END
