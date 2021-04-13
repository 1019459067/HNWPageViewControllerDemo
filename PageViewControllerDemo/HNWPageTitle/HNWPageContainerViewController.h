//
//  HNWPageContainerViewController.h
//  PageViewControllerDemo
//
//  Created by HN on 2021/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HNWPageContainerViewController;
@protocol HNWPageContainerViewControllerDelegate <NSObject>

- (void)pageContainerViewController:(HNWPageContainerViewController *)vc didScrolledAtIndex:(NSInteger)index;

@end

@interface HNWPageContainerViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *listVCArray;

@property (weak, nonatomic) id <HNWPageContainerViewControllerDelegate> delegate;

- (void)setContentWithIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
