//
//  HNWPageTitleUtil.h
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/23.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HNWPageViewTitleConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HNWPageTitleUtil : NSObject

//文字宽度
+ (CGFloat)widthForText:(NSString *)text font:(UIFont *)font size:(CGSize)size;

//执行阴影动画
+ (void)showAnimationToShadow:(UIView *)shadow shadowWidth:(CGFloat)shadowWidth fromItemRect:(CGRect)fromItemRect toItemRect:(CGRect)toItemRect type:(HNWPageShadowLineAnimationType)type progress:(CGFloat)progress;

//颜色过渡
+ (UIColor *)colorTransformFrom:(UIColor*)fromColor to:(UIColor *)toColor progress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
