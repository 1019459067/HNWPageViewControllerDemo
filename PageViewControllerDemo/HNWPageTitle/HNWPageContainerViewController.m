//
//  HNWPageContainerViewController.m
//  PageViewControllerDemo
//
//  Created by HN on 2021/4/13.
//

#import "HNWPageContainerViewController.h"

@interface HNWPageContainerViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *horizScrollView;

@end

@implementation HNWPageContainerViewController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setttingUI];
}

#pragma mark - UI
- (void)setttingUI {
    self.horizScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.horizScrollView.pagingEnabled = YES;
    self.horizScrollView.bounces = NO;
    self.horizScrollView.scrollEnabled = YES;
    self.horizScrollView.delegate = self;
    [self.view addSubview:self.horizScrollView];
}

#pragma mark - other
- (void)setContentWithIndex:(NSInteger)index animated:(BOOL)animated {
    [self.horizScrollView setContentOffset:CGPointMake(index * self.horizScrollView.frame.size.width, 0) animated:animated];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger page = targetContentOffset->x/self.horizScrollView.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(pageContainerViewController:didScrolledAtIndex:)]) {
        [self.delegate pageContainerViewController:self didScrolledAtIndex:page];
    }
}

#pragma mark - set data
- (void)setListVCArray:(NSMutableArray *)listVCArray {
    _listVCArray = listVCArray;
    
    for (int i = 0; i< self.listVCArray.count; i++) {
        UIViewController *vc = self.listVCArray[i];
        
        [self addChildViewController:vc];
        [self.horizScrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    [self.horizScrollView setContentSize:CGSizeMake(self.listVCArray.count*self.view.frame.size.width, 0)];
}
@end
