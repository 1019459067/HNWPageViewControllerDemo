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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setttingUI];
}

#pragma mark - UI
- (void)setttingUI
{
    self.horizScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.horizScrollView.showsVerticalScrollIndicator = NO;
    self.horizScrollView.showsHorizontalScrollIndicator = NO;
    self.horizScrollView.pagingEnabled = YES;
    self.horizScrollView.bounces = NO;
    self.horizScrollView.scrollEnabled = YES;
    self.horizScrollView.delegate = self;
    [self.view addSubview:self.horizScrollView];
}

#pragma mark - set data
- (void)setListVCArray:(NSMutableArray *)listVCArray
{
    _listVCArray = listVCArray;

    for (int i = 0; i< listVCArray.count; i++) {
        UIViewController *vc = listVCArray[i];
        
        [self addChildViewController:vc];
        [self.horizScrollView addSubview:vc.view];
        [vc.view setFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }

    [self.horizScrollView setContentSize:CGSizeMake(listVCArray.count*self.view.frame.size.width, self.view.frame.size.height)];
}

- (void)updateUISelectedWithIndex:(NSInteger)selected {
    [self.horizScrollView setContentOffset:CGPointMake(selected * self.view.frame.size.width, self.view.frame.size.height) animated:YES];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSInteger page = targetContentOffset->x/self.view.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(pageContainerViewController:didScrolleddAtIndex:)]) {
        [self.delegate pageContainerViewController:self didScrolleddAtIndex:page];
    }
}

@end
