//
//  CommonTableViewController.h
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.//  通用表格

#import <UIKit/UIKit.h>
#import "NestedDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonTableViewController : UIViewController<NestedDelegate>

@property (nonatomic, strong) UIView *headerView;

@end

NS_ASSUME_NONNULL_END
