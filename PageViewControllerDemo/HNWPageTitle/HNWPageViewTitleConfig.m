//
//  HNWPageViewTitleConfig.m
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.

#import "HNWPageViewTitleConfig.h"

@implementation HNWPageViewTitleConfig

+  (HNWPageViewTitleConfig *)defaultConfig {
    HNWPageViewTitleConfig *config = [[HNWPageViewTitleConfig alloc] init];
    
    //标题-----------------------------------
    //默认未选中标题颜色 灰色
    config.titleNormalColor = [UIColor grayColor];
    //默认选中标题颜色 黑色
    config.titleSelectedColor = [UIColor blackColor];
    //默认未选中标题字体 18号系统字体
    config.titleNormalFont = [UIFont systemFontOfSize:18];
    //默认选中标题字体 18号粗体系统字体
    config.titleSelectedFont = [UIFont boldSystemFontOfSize:18];
    
    //标题栏------------------------------------
    //默认标题栏高度 40
    config.titleViewHeight = 44.0f;
    //默认标题栏背景颜色 透明
    config.titleViewBackgroundColor = [UIColor clearColor];
    //默认标题栏对齐方式 局左
    config.titleViewAlignment = HNWPageTitleViewAlignmentFull;
    // 默认标题视图总宽度 106
    config.titleViewWidth = 106;
    //阴影--------------------------------------
    //默认显示阴影
    config.shadowLineHidden = NO;
    //默认阴影宽度 30
    config.shadowLineWidth = 30.0f;
    //默认阴影高度 3
    config.shadowLineHeight = 3.0f;
    //默认阴影颜色 黑色
    config.shadowLineColor = [UIColor blackColor];
    //默认阴影动画 平移
    config.shadowLineAnimationType = HNWPageShadowLineAnimationTypePan;
    
    //底部分割线-----------------------------------
    //默认显示分割线
    config.separatorLineHidden = NO;
    //默认分割线颜色 浅灰色
    config.separatorLineColor = [UIColor lightGrayColor];
    //默认分割线高度 0.5
    config.separatorLineHeight = 0.5f;
    return config;
}

@end
