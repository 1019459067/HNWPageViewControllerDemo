//
//  HNWPageTitleUtil.m
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/23.
//

#import "HNWPageTitleUtil.h"

@implementation HNWPageTitleUtil

+ (CGFloat)widthForText:(NSString *)text font:(UIFont *)font size:(CGSize)size {
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{
        NSFontAttributeName : font,
        NSParagraphStyleAttributeName : style
    };
    CGSize textSize = [text boundingRectWithSize:size
                                         options:opts
                                      attributes:attributes
                                         context:nil].size;
    return textSize.width;
}

+ (void)showAnimationToShadow:(UIView *)shadow shadowWidth:(CGFloat)shadowWidth fromItemRect:(CGRect)fromItemRect toItemRect:(CGRect)toItemRect type:(HNWPageShadowLineAnimationType)type progress:(CGFloat)progress {
    
    //没有动画，跳过
    if (type == HNWPageShadowLineAnimationTypeNone) {
        return;
    }
    
    //平移动画
    if (type == HNWPageShadowLineAnimationTypePan) {
        CGFloat distance = CGRectGetMidX(toItemRect) - CGRectGetMidX(fromItemRect);
        CGFloat centerX = CGRectGetMidX(fromItemRect) + fabs(progress)*distance;
        shadow.center = CGPointMake(centerX, shadow.center.y);
    }
    
    //缩放动画
    if (type == HNWPageShadowLineAnimationTypeZoom) {
        CGFloat distance = fabs(CGRectGetMidX(toItemRect) - CGRectGetMidX(fromItemRect));
        CGFloat fromX = CGRectGetMidX(fromItemRect) - shadowWidth/2.0f;
        CGFloat toX = CGRectGetMidX(toItemRect) - shadowWidth/2.0f;
        if (progress > 0) {//向右移动
            //前半段0~0.5，x不变 w变大
            if (progress <= 0.5) {
                //让过程变成0~1
                CGFloat newProgress = 2*fabs(progress);
                CGFloat newWidth = shadowWidth + newProgress*distance;
                CGRect shadowFrame = shadow.frame;
                shadowFrame.size.width = newWidth;
                shadowFrame.origin.x = fromX;
                shadow.frame = shadowFrame;
            }else if (progress >= 0.5) { //后半段0.5~1，x变大 w变小
                //让过程变成1~0
                CGFloat newProgress = 2*(1-fabs(progress));
                CGFloat newWidth = shadowWidth + newProgress*distance;
                CGFloat newX = toX - newProgress*distance;
                CGRect shadowFrame = shadow.frame;
                shadowFrame.size.width = newWidth;
                shadowFrame.origin.x = newX;
                shadow.frame = shadowFrame;
            }
        }else {//向左移动
            //前半段0~-0.5，x变小 w变大
            if (progress >= -0.5) {
                //让过程变成0~1
                CGFloat newProgress = 2*fabs(progress);
                CGFloat newWidth = shadowWidth + newProgress*distance;
                CGFloat newX = fromX - newProgress*distance;
                CGRect shadowFrame = shadow.frame;
                shadowFrame.size.width = newWidth;
                shadowFrame.origin.x = newX;
                shadow.frame = shadowFrame;
            }else if (progress <= -0.5) { //后半段-0.5~-1，x变大 w变小
                //让过程变成1~0
                CGFloat newProgress = 2*(1-fabs(progress));
                CGFloat newWidth = shadowWidth + newProgress*distance;
                CGRect shadowFrame = shadow.frame;
                shadowFrame.size.width = newWidth;
                shadowFrame.origin.x = toX;
                shadow.frame = shadowFrame;
            }
        }
    }
}

+ (UIColor *)colorTransformFrom:(UIColor*)fromColor to:(UIColor *)toColor progress:(CGFloat)progress {
    
    if (!fromColor || !toColor) {
        NSLog(@"Warning !!! color is nil");
        return [UIColor blackColor];
    }
    
    progress = progress >= 1 ? 1 : progress;
    
    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
    
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
    
    CGFloat red = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat green = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat blue = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end