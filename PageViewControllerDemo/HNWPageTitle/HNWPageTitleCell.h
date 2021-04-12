//
//  HNWPageTitleCell.h
//  PageViewControllerDemo
//  Created by HN on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import "HNWPageViewTitleConfig.h"


NS_ASSUME_NONNULL_BEGIN

@interface HNWPageTitleCell : UICollectionViewCell

//配置信息 默认样式时用到
@property (nonatomic, strong) HNWPageViewTitleConfig *config;

//标题
@property (nonatomic, strong) UIButton *titleButton;

//配置cell
/**
 配置cell选中/未选中UI
 
 @param selected 已选中/未选中
 */
- (void)configCellOfSelected:(BOOL)selected;

@end

NS_ASSUME_NONNULL_END
