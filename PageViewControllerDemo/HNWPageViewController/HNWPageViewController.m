//
//  HNWPageViewController.m
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.

#import "HNWPageViewController.h"

@interface HNWPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>

//分页控制器
@property (nonatomic, strong) UIPageViewController *pageVC;
//ScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
//显示过的vc数组，用于试图控制器缓存
@property (nonatomic, strong) NSMutableArray *shownVCArr;
//是否加载了pageVC
@property (nonatomic, assign) BOOL pageVCDidLoad;
//上一次选中的位置
@property (nonatomic, assign) NSInteger lastSelectedIndex;

@end

@implementation HNWPageViewController

#pragma mark -
#pragma mark 初始化方法
//初始化需要使用initWithConfig方法
- (instancetype)init {
    if (self = [super init]) {
        [self initUI];
        [self initData];
    }
    return self;
}

- (void)initUI
{
    //创建PageVC
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    [self.view addSubview:self.pageVC.view];
    [self addChildViewController:self.pageVC];
    
    //设置ScrollView代理
    for (UIScrollView *scrollView in self.pageVC.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            self.scrollView = scrollView;
            self.scrollView.delegate = self;
            self.scrollView.showsHorizontalScrollIndicator = NO;
        }
    }
}

//初始化vc缓存数组
- (void)initData {
    self.shownVCArr = [[NSMutableArray alloc] init];
    //默认可以滚动
    self.scrollEnabled = YES;
    self.lastSelectedIndex = -1;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    //更新pageVC位置
    self.pageVC.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    //自动选中当前位置_selectedIndex
    if (!self.pageVCDidLoad) {
        //设置加载标记为已加载
        self.pageVCDidLoad = YES;
        [self switchToViewControllerAdIndex:self.selectedIndex animated:NO];
    }
}

#pragma mark -
#pragma mark UIPageViewControllerDelegate
//滚动切换时调用
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (!completed) {
        NSLog(@"xwh failed");
        return;
    }
    //更新选中位置
    UIViewController *currentVC = previousViewControllers.lastObject;
    for (int i = 0; i<self.shownVCArr.count; i++) {
        UIViewController *vc = self.shownVCArr[i];
        if ([vc isKindOfClass:currentVC.class]) {
            _selectedIndex = i;
            break;
        }
    }
    //回调代理方法
    [self delegateSelectedAtIndex:self.selectedIndex];
    NSLog(@"didFinishAnimating: %@",currentVC);
    
//    for (UIScrollView *scrollView in currentVC.view.subviews) {
//        if ([scrollView isKindOfClass:[UIScrollView class]]) {
//            scrollView.scrollEnabled = YES;
//        }
//    }
}

//滚动切换时调用
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    UIViewController *currentVC = pendingViewControllers.lastObject;
    NSLog(@"willTransitionToViewControllers: %@",currentVC);
//    for (UIScrollView *scrollView in currentVC.view.subviews) {
//        if ([scrollView isKindOfClass:[UIScrollView class]]) {
//            scrollView.scrollEnabled = NO;
//        }
//    }
}

#pragma mark -
#pragma mark UIPageViewControllerDataSource
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    //修正因为拖拽距离过大，导致空白界面问题
    NSInteger index = [self getIndexWithViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerForIndex:index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger index = [self getIndexWithViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerForIndex:index];
}

#pragma mark -
#pragma mark ScrollViewDelegate
//滚动时计算标题动画进度
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat value = scrollView.contentOffset.x - scrollView.bounds.size.width;
    if ([self.delegate respondsToSelector:@selector(pageViewController:titleViewAnimationProgress:)]) {
        [self.delegate pageViewController:self titleViewAnimationProgress:value/scrollView.bounds.size.width];
    }
}

#pragma mark -
#pragma mark Setter
//设置选中位置
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    //范围越界，抛出异常
    if (selectedIndex < 0 || selectedIndex > [self numberOfPage]) {
        [NSException raise:@"selectedIndex is not right ！！！" format:@"It is out of range"];
    }
    BOOL switchSuccess = [self switchToViewControllerAdIndex:selectedIndex animated:YES];
    if (!switchSuccess) {return;}
}

//滑动开关
- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.scrollView.scrollEnabled = scrollEnabled;
}

#pragma mark -
#pragma mark 切换位置方法
- (BOOL)switchToViewControllerAdIndex:(NSInteger)index animated:(BOOL)animated {
    if ([self numberOfPage] == 0) {return NO;}

    //更新当前位置
    _selectedIndex = index;
    //设置滚动方向
    UIPageViewControllerNavigationDirection direction = UIPageViewControllerNavigationDirectionForward;
    if (self.lastSelectedIndex > _selectedIndex) {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    //设置当前展示VC
    [self.pageVC setViewControllers:@[[self viewControllerForIndex:index]] direction:direction animated:animated completion:nil];
    
    [self delegateSelectedAtIndex:self.selectedIndex];
    return YES;
}

#pragma mark -
#pragma mark 辅助方法
//指定位置的视图控制器 缓存方法
- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    
    //如果越界，则返回nil
    if (index < 0 || index >= [self numberOfPage]) {
        return nil;
    }
    //获取当前vc
    UIViewController *currentVC = nil;
    if (index<=self.shownVCArr.count-1 && self.shownVCArr.count) {
        currentVC = self.shownVCArr[index];
    }

    //如果之前显示过，则从内存中读取
    for (UIViewController *vc in self.shownVCArr) {
        if ([vc isKindOfClass:currentVC.class]) {
            return vc;
        }
    }
    
    //如果之前没显示过，则通过dataSource创建
    UIViewController *vc = [self.dataSource pageViewController:self viewControllerForIndex:index];
    //把vc添加到缓存集合
    [self.shownVCArr addObject:vc];
    //添加子视图控制器
    [self addChildViewController:vc];
    return vc;
}
- (NSInteger)getIndexWithViewController:(UIViewController *)viewController
{
    NSInteger index = -1;
    for (int i = 0; i<self.shownVCArr.count; i++) {
        UIViewController *vc = self.shownVCArr[i];
        if ([vc isKindOfClass:viewController.class]) {
            index = i;
            break;
        }
    }
    return index;
}
//总页数
- (NSInteger)numberOfPage {
    return [self.dataSource pageViewControllerNumberOfPage];
}

//执行代理方法
- (void)delegateSelectedAtIndex:(NSInteger)index
{
    if (index == self.lastSelectedIndex) {return;}
    if ([self.delegate respondsToSelector:@selector(pageViewController:checkScrollAtIndex:completion:)]) {
        [self.delegate pageViewController:self
                       checkScrollAtIndex:index
                               completion:^(BOOL finished) {
            if (finished) {
                [self didScrolledAtIndex:index];
            }
        }];
    } else {
        [self didScrolledAtIndex:index];
    }
}

- (void)didScrolledAtIndex:(NSInteger)index
{
    self.lastSelectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(pageViewController:didScrolledAtIndex:)]) {
        [self.delegate pageViewController:self didScrolledAtIndex:index];
    }
}
@end
