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

- (void)pageContainerViewController:(HNWPageContainerViewController *)vc didScrolleddAtIndex:(NSInteger)index;

@end

@interface HNWPageContainerViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *listVCArray;
@property (nonatomic, weak) id <HNWPageContainerViewControllerDelegate> delegate;

- (void)updateUISelectedWithIndex:(NSInteger)selected;

@end

NS_ASSUME_NONNULL_END
