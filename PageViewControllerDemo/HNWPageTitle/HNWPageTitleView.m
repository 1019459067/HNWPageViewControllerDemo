//
//  HNWPageTitleView.m
//  PageViewControllerDemo
//
//  Created by HN on 2021/3/22.

#import "HNWPageTitleView.h"
#import "HNWPageTitleCell.h"

#pragma mark -
#pragma mark CellModel类
@interface HNWPageTitleCellModel : NSObject

@property (nonatomic, assign) CGRect frame;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation HNWPageTitleCellModel

@end

#pragma mark - 标题类
#pragma mark HNWPageTitleView
@interface HNWPageTitleView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

//集合视图
@property (nonatomic, strong) UICollectionView *collectionView;

//配置信息
@property (nonatomic, strong) HNWPageViewTitleConfig *config;

//阴影线条
@property (nonatomic, strong) UIView *shadowLine;

//底部分割线
@property (nonatomic, strong) UIView *separatorLine;

//cell的模型
@property (nonatomic, strong) NSMutableArray *cellModels;

// 上一次选中的位置
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@end

@implementation HNWPageTitleView

- (instancetype)initWithConfig:(HNWPageViewTitleConfig *)config {
    if (self = [super init]) {
        [self initTitleViewWithConfig:config];
    }
    return self;
}

- (void)initTitleViewWithConfig:(HNWPageViewTitleConfig *)config {
    
    self.cellModels = [[NSMutableArray alloc] init];
    
    self.config = config;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = config.titleViewBackgroundColor;
    [self.collectionView registerClass:[HNWPageTitleCell class] forCellWithReuseIdentifier:@"HNWPageTitleCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:self.collectionView];
    
    self.separatorLine = [[UIView alloc] init];
    self.separatorLine.backgroundColor = config.separatorLineColor;
    self.separatorLine.hidden = config.separatorLineHidden;
    [self addSubview:self.separatorLine];
    
    self.shadowLine = [[UIView alloc] init];
    self.shadowLine.bounds = CGRectMake(0, 0, self.config.shadowLineWidth, self.config.shadowLineHeight);
    self.shadowLine.backgroundColor = config.shadowLineColor;
    self.shadowLine.layer.cornerRadius = self.config.shadowLineHeight/2.0f;
    if (self.config.shadowLineCap == HNWPageShadowLineCapSquare) {
        self.shadowLine.layer.cornerRadius = 0;
    }
    self.shadowLine.layer.masksToBounds = YES;
    self.shadowLine.hidden = config.shadowLineHidden;
    [self.collectionView addSubview:self.shadowLine];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat collectionW = self.bounds.size.width;
    if (self.rightButton) {
        CGFloat btnW = self.bounds.size.height;
        collectionW = self.bounds.size.width - btnW;
        self.rightButton.frame = CGRectMake(self.bounds.size.width - btnW, 0, btnW, btnW);
    }
    
    CGFloat collectionViewL = 0;
    if (self.config.titleViewAlignment == HNWPageTitleViewAlignmentCustom) {
        collectionViewL = (collectionW-self.config.titleViewWidth)/2.;
    }
    self.collectionView.frame = CGRectMake(collectionViewL, 0, collectionW, self.bounds.size.height);
    
    self.separatorLine.frame = CGRectMake(0, self.bounds.size.height - self.config.separatorLineHeight, self.bounds.size.width, self.config.separatorLineHeight);
    
    [self fixShadowLineCenter];
    [self.collectionView sendSubviewToBack:self.shadowLine];
    [self bringSubviewToFront:self.separatorLine];
}

#pragma mark -
#pragma mark CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource pageTitleViewNumber];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellW = collectionView.bounds.size.width;
    NSInteger cellNum = [self.dataSource pageTitleViewNumber];
    
    if (cellNum > 5) { // 最大放五个
        cellNum = 5;
    }
    if (self.config.titleViewAlignment == HNWPageTitleViewAlignmentCustom) {
        cellW = self.config.titleViewWidth;
    }
    cellW = cellW/(CGFloat)cellNum;
    return CGSizeMake(cellW, collectionView.bounds.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HNWPageTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HNWPageTitleCell" forIndexPath:indexPath];
    cell.config = self.config;
    NSString *title = [self.dataSource pageTitleView:self
                          pageTitleViewTitleForIndex:indexPath.item];
    [cell.titleButton setTitle:title forState:UIControlStateNormal];
   
    if (self.config.iconDictInfo.allValues) {
        NSInteger indexIcon = [self.config.iconDictInfo[@"index"] intValue];
        BOOL showIcon = [self.config.iconDictInfo[@"show"] boolValue];

        if (indexIcon == indexPath.item && showIcon) {
            NSString *unselectedImage = self.config.iconDictInfo[@"unselectedImage"];
            NSString *selectedImage = self.config.iconDictInfo[@"selectedImage"];
            
            if (indexIcon == self.selectedIndex) {
                [cell.titleButton setImage:[UIImage imageNamed:selectedImage] forState:UIControlStateNormal];
            } else {
                [cell.titleButton setImage:[UIImage imageNamed:unselectedImage] forState:UIControlStateNormal];
            }
            cell.titleButton.imageEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
            cell.titleButton.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
        } else {
            [cell.titleButton setImage:nil forState:UIControlStateNormal];
        }
    }
    [cell configCellOfSelected:(indexPath.item == self.selectedIndex)];
    [self addCellModel:indexPath frame:cell.frame];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(pageTitleView:checkSelectAtIndex:completion:)]) {
        [self.delegate pageTitleView:self
                  checkSelectAtIndex:indexPath.item
                          completion:^(BOOL finished) {
            if (finished) {
                [self pageTitleViewDidSelectedAtIndex:indexPath.item];
            }
        }];
    } else {
        [self pageTitleViewDidSelectedAtIndex:indexPath.item];
    }
}

- (void)pageTitleViewDidSelectedAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    if ([self.delegate respondsToSelector:@selector(pageTitleView:didSelectedAtIndex:)]) {
        [self.delegate pageTitleView:self didSelectedAtIndex:index];
    }
}

#pragma mark -
#pragma mark 添加CellModel
- (void)addCellModel:(NSIndexPath *)indexPath frame:(CGRect)frame {
    HNWPageTitleCellModel *newModel = [[HNWPageTitleCellModel alloc] init];
    newModel.frame = frame;
    newModel.indexPath = indexPath;
    bool contain = NO;
    for (HNWPageTitleCellModel *model in self.cellModels) {
        if (model.indexPath.item == indexPath.item) {
            contain = YES;
        }
    }
    if (!contain) {
        [self.cellModels addObject:newModel];
    }
}

#pragma mark -
#pragma mark Setter
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self updateLayout];
}

- (void)setRightButton:(UIButton *)rightButton {
    _rightButton = rightButton;
    [self addSubview:rightButton];
}

- (void)updateLayout {
    
    if (_selectedIndex == _lastSelectedIndex) {return;}
    
    //更新cellUI
    [self.collectionView reloadData];
    
    //自动居中
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
    //设置阴影位置
    CGPoint center = [self shadowLineCenterForIndex:_selectedIndex];
    self.shadowLine.center = center;
    if ([self.delegate respondsToSelector:@selector(pageTitleView:didSelectedAtLastSelectedIndex:)]) {
        [self.delegate pageTitleView:self didSelectedAtLastSelectedIndex:_lastSelectedIndex];
    }
    //保存上次选中位置
    _lastSelectedIndex = _selectedIndex;
}

- (void)fixShadowLineCenter {
    //避免找不到Cell,先滚动到指定位置
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    //避免cell不在屏幕上显示，延时0.01秒加载
    CGPoint shadowCenter = [self shadowLineCenterForIndex:_selectedIndex];
    if (shadowCenter.x > 0) {
        self.shadowLine.center = shadowCenter;
    }else {
        if (self.shadowLine.center.x <= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                self.shadowLine.center = [self shadowLineCenterForIndex:self.selectedIndex];
            });
        }
    }
}

//刷新方法
- (void)reloadData {
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark 阴影位置
- (CGPoint)shadowLineCenterForIndex:(NSInteger)index {
    HNWPageTitleCell *cell = (HNWPageTitleCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    CGRect cellFrame = cell.frame;
    if (!cell) {
        for (HNWPageTitleCellModel *model  in self.cellModels) {
            if (model.indexPath.item == index) {
                cellFrame = model.frame;
            }
        }
    }
    CGFloat centerX = CGRectGetMidX(cellFrame);
    CGFloat separatorLineHeight = self.config.separatorLineHidden ? 0 : self.config.separatorLineHeight;
    CGFloat centerY = self.bounds.size.height - self.config.shadowLineHeight/2.0f - separatorLineHeight;
    if (self.config.shadowLineAlignment == HNWPageShadowLineAlignmentTop) {
        centerY = self.config.shadowLineHeight/2.0f;
    }
    if (self.config.shadowLineAlignment == HNWPageShadowLineAlignmentCenter) {
        centerY = CGRectGetMidY(cellFrame);
    }
    return CGPointMake(centerX, centerY);
}

@end
