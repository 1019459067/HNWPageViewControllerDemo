//
//  HNWPageTitleCell.m
//  PageViewControllerDemo
//  Created by HN on 2021/3/22.
//

#import <UIKit/UIKit.h>
#import "HNWPageTitleCell.h"
#import "HNWPageTitleUtil.h"

#pragma mark -
#pragma mark Cell类

@interface HNWPageTitleCell ()


@end

@implementation HNWPageTitleCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.titleButton = [[UIButton alloc] init];
        self.titleButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:self.titleButton];
        self.titleButton.userInteractionEnabled = NO;
        self.config = [HNWPageViewTitleConfig defaultConfig];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleButton.frame = self.bounds;
}

- (void)configCellOfSelected:(BOOL)selected {
    [self.titleButton setTitleColor:selected ? self.config.titleSelectedColor : self.config.titleNormalColor forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = selected ? self.config.titleSelectedFont : self.config.titleNormalFont;
}

@end
