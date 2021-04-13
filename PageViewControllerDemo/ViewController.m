//
//  ViewController.m
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.
//

#import "ViewController.h"

#import "HNWPageTitleView.h"
#import "HNWPageContainerViewController.h"

#import "CommonTableViewController.h"
#import "TestAViewController.h"
#import "TestBViewController.h"

#import "HNWDevice.h"

#define SCREEN_WIDTH                UIScreen.mainScreen.bounds.size.width
#define SCREEN_HEIGHT               UIScreen.mainScreen.bounds.size.height
#define BackgroundViewBaseHeight    180

static NSString *const kObseverKeyContentOffset = @"contentOffset";

@interface ViewController ()<HNWPageTitleViewDelegate, HNWPageTitleViewDataSource, UIScrollViewDelegate, HNWPageContainerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *topContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UIView *titleSegmentView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentViewConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewConstraintH;

@property (nonatomic, strong) HNWPageTitleView *titleView;
@property (strong, nonatomic) HNWPageContainerViewController *pageContainerVC;
//标题
@property (nonatomic, copy) NSArray *titlesArray;

@property (nonatomic,weak)id<NestedDelegate> currentNestedDelegate;
@property (strong, nonatomic) NSMutableArray *listViewControllerArray;

@end

@implementation ViewController

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HNWDevice setupEnvironment];
    [self setNav];
    
    if (@available(iOS 11.0, *)) {
        self.mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];

    self.titlesArray = @[@"热点1",@"科技帖子2",@"国际3",@"数码4",@"小说5",@"军事6",@"国风点赞列表7",@"直播8",@"新时代9",@"北京10",@"国际11",@"数码12",@"小说13",@"军事14"];
    [self setupView];
}

- (void)dealloc {
    if (self.currentNestedDelegate) {
        [self.currentNestedDelegate.getNestedScrollView removeObserver:self forKeyPath:kObseverKeyContentOffset];
    }
}

#pragma mark - UI
- (void)setNav {
    self.title = @"PageViewControllerDemo";
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];   // 消除导航栏细线
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setupView
{
    self.topContentViewConstraintH.constant = BackgroundViewBaseHeight;
    [self.topContentView addSubview:[self setupHeaderView]];
    
    HNWPageViewTitleConfig *config = [HNWPageViewTitleConfig defaultConfig];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"index"] = @(1);
    dict[@"show"] = @(1);
    dict[@"unselectedImage"] = @"ICON_lock_unselected";
    dict[@"selectedImage"] = @"ICON_lock_selected";
    config.iconDictInfo = dict;
    
    config.titleViewAlignment = HNWPageTitleViewAlignmentFull;
    config.separatorLineHidden = NO;
    config.titleNormalFont = [UIFont systemFontOfSize:14];
    
    self.titleView = [[HNWPageTitleView alloc] initWithConfig:config];
    self.titleView.dataSource = self;
    self.titleView.delegate = self;
    [self.titleSegmentView addSubview:self.titleView];
    self.titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, config.titleViewHeight);
    
    CGFloat height = self.bottomContentViewConstraintH.constant = SCREEN_HEIGHT - HNWDevice.safeAreaTopInsetWhenNavigationBarShow-config.titleViewHeight;
    self.pageContainerVC = [[HNWPageContainerViewController alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)
                                                                        listVCs:self.listViewControllerArray
                                                                       delegate:self];
    [self addChildViewController:self.pageContainerVC];
    [self.bottomContentView addSubview:self.pageContainerVC.view];
    
    [self chooseNestedWithIndex:0];
    
    self.titleView.selectedIndex = 2;
    [self.pageContainerVC setContentWithIndex:2 animated:YES];
}

- (UILabel *)setupHeaderView {
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, BackgroundViewBaseHeight)];
    headerView.backgroundColor = [UIColor redColor];
    headerView.text = @"点击响应事件";
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [headerView addGestureRecognizer:gesture];
    return headerView;
}

// 更新导航栏UI
- (void)updateNavUIWithScrollView:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    BOOL bNavHidden = NO;
    if (offsetY > 0) {
        CGFloat alpha = MIN(1.0, MAX(0, offsetY/(BackgroundViewBaseHeight/2.)));
        self.navigationController.navigationBar.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:alpha];
        if (alpha >= 0.8) {
            bNavHidden = NO;
        } else if (alpha <= 0.5) {
            bNavHidden = YES;
        }
    } else {
        self.navigationController.navigationBar.backgroundColor = UIColor.clearColor;
        bNavHidden = YES;
    }

    self.navigationController.navigationBar.hidden = bNavHidden;
    if (bNavHidden) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - other
- (void)updateUISelectedWithIndex:(NSInteger)selected {
    [self chooseNestedWithIndex:selected];
    [self.pageContainerVC setContentWithIndex:selected animated:YES];
}

- (void)chooseNestedWithIndex:(NSInteger)index {
    id<NestedDelegate> delegate = self.listViewControllerArray[index];
    if (self.currentNestedDelegate) {
        [self.currentNestedDelegate.getNestedScrollView removeObserver:self forKeyPath:kObseverKeyContentOffset];
    }
    
    self.currentNestedDelegate = delegate;
    [self.currentNestedDelegate.getNestedScrollView addObserver:self forKeyPath:kObseverKeyContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([kObseverKeyContentOffset isEqualToString:keyPath]) {
        [self scrollViewDidScroll:object];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gesture {
    NSLog(@"tapGesture");
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateNavUIWithScrollView:self.mainScrollView];

    //最大上滑距离
    CGFloat maxOffset = self.topContentViewConstraintH.constant-HNWDevice.safeAreaTopInsetWhenNavigationBarShow;
    CGFloat mainContentOffsetY = self.mainScrollView.contentOffset.y;
    
    if (scrollView == self.mainScrollView) {
        if (mainContentOffsetY > maxOffset) {
            [self.mainScrollView setContentOffset:CGPointMake(0, maxOffset)];
        }else if(mainContentOffsetY < 0) {
            [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
        }
    } else if (scrollView == self.currentNestedDelegate.getNestedScrollView) {
        UIScrollView *currentScrollView = self.currentNestedDelegate.getNestedScrollView;
        CGFloat currentOffsetY = currentScrollView.contentOffset.y;
        //避免死循环
        if (currentOffsetY == 0) {
            return;
        }
        
        if (currentOffsetY < 0) {
            //下滑
            if(mainContentOffsetY > 0) {
                [self.mainScrollView setContentOffset:CGPointMake(0, mainContentOffsetY+currentOffsetY)];
                [currentScrollView setContentOffset:CGPointMake(0, 0)];
            }
        } else if (currentOffsetY >0) {
            //上拉
            if(mainContentOffsetY < maxOffset) {
                [self.mainScrollView setContentOffset:CGPointMake(0, mainContentOffsetY+currentOffsetY)];
                [currentScrollView setContentOffset:CGPointMake(0, 0)];
            }
        }
    }
}

#pragma mark - HNWPageContainerViewControllerDelegate
- (void)pageContainerViewController:(HNWPageContainerViewController *)vc didScrolledAtIndex:(NSInteger)index {
    self.titleView.selectedIndex = index;
    [self chooseNestedWithIndex:index];
}
#pragma mark HNWPageTitleViewDelegate, HNWPageTitleViewDataSource
- (NSInteger)pageTitleViewNumber {
    return self.titlesArray.count;
}

- (NSString *)pageTitleView:(HNWPageTitleView *)view pageTitleViewTitleForIndex:(NSInteger)index {
    return self.titlesArray[index];
}

- (void)pageTitleView:(HNWPageTitleView *)view didSelectedAtIndex:(NSInteger)index {
    [self updateUISelectedWithIndex:index];
}

//- (void)pageTitleView:(HNWPageTitleView *)view didSelectedAtLastSelectedIndex:(NSInteger)lastSelectedIndex
//{
////    self.lastSelectedIndex = lastSelectedIndex;
//}
//
//- (void)pageTitleView:(HNWPageTitleView *)pageTitleView checkSelectAtIndex:(NSInteger)index completion:(nonnull void (^)(BOOL))completion
//{
//    completion(YES);
////    if (index == 0) {
////        NSLog(@"无法点击");
////        completion(NO);
////    } else {
////        completion(YES);
////    }
//}

#pragma mark - get data
- (NSMutableArray *)listViewControllerArray {
    if (!_listViewControllerArray) {
        _listViewControllerArray = [NSMutableArray array];
        for (int i = 0; i < self.titlesArray.count; i++) {
            if (i == 0) {
                TestAViewController *vc = [[TestAViewController alloc] init];
                [_listViewControllerArray addObject:vc];
            } else if (i == 1) {
                TestBViewController *vc = [[TestBViewController alloc] init];
                [_listViewControllerArray addObject:vc];
            } else {
                CommonTableViewController *vc = [[CommonTableViewController alloc] init];
                [_listViewControllerArray addObject:vc];
            }
        }
    }
    return _listViewControllerArray;
}

@end
