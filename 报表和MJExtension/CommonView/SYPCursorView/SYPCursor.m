//
//  SYPCursor.m
//  SYPScrollNavBar
//
//  Created by haha on 15/7/6.
//  Copyright (c) 2015年 haha. All rights reserved.
//

#import "SYPCursor.h"
#import "SYPScrollNavBar.h"
#import "UIView+Extension.h"
#import "SYPItemManager.h"
#import "SYPRootScrollView.h"
#import "SYPAnimationTool.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"

#define navLineHeight                   6
#define StaticItemIndex                 3
#define SortItemViewY                   -360
#define SortItemViewMoveToY             -70
#define defBackgroundColor              SYPColor_BackgroudColor_White

@interface SYPCursor()<UIScrollViewDelegate>

@property (nonatomic, strong) SYPScrollNavBar   *scrollNavBar;
@property (nonatomic, strong) SYPRootScrollView *rootScrollView;

@property (nonatomic, assign) BOOL             showNarLine;
@property (nonatomic, assign) BOOL             isDrag;
@property (nonatomic, assign) BOOL             isRefash;
@property (nonatomic, assign) BOOL             isLayout;
@property (nonatomic, assign) CGFloat          oldOffset;
@property (nonatomic, assign) CGFloat          navBarH;
@property (nonatomic, assign) NSInteger        oldBtnIndex;
@end

@implementation SYPCursor

#pragma mark - 懒加载

- (SYPRootScrollView *)rootScrollView{
    if (!_rootScrollView) {
        _rootScrollView = [[SYPRootScrollView alloc]init];
        _rootScrollView.pagingEnabled = YES;
        //_rootScrollView.backgroundColor = [UIColor cyanColor];
        //_rootScrollView.margin = 20;
    }
    return _rootScrollView;
}

- (void)setPageViews:(NSMutableArray *)pageViews{
    _pageViews = pageViews;
    
    self.scrollNavBar.pageViews = pageViews;
    _scrollNavBar.rootScrollView = self.rootScrollView;
}


- (SYPScrollNavBar *)scrollNavBar{
    if (!_scrollNavBar) {
        _scrollNavBar = [[SYPScrollNavBar alloc]init];
        _scrollNavBar.backgroundColor = [UIColor redColor];
    }
    return _scrollNavBar;
}

#pragma mark - 属性配置

- (void)setRootScrollViewHeight:(CGFloat)rootScrollViewHeight{
    _rootScrollViewHeight = rootScrollViewHeight;
    CGRect rect = self.frame;
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat w = rect.size.width;
    CGFloat h = rect.size.height;
    if (self.navBarH == 0 ) {
        self.navBarH = h;
        h = h + _rootScrollViewHeight;
    }
    else {
        h = self.navBarH + _rootScrollViewHeight;
    }
    CGRect frameChanged = CGRectMake(x, y, w, h);
    [self setFrame:frameChanged];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:[UIColor clearColor]];
    self.scrollNavBar.backgroundColor = backgroundColor;
}

- (void)setTitles:(NSArray *)titles{
    BOOL isHaveSameTitle = [self checkisHaveSameItem:titles];
    NSAssert(!isHaveSameTitle, @"错误！！！不可以包含相同的标题");
    _titles = titles;

    [[SYPItemManager shareitemManager] setScrollNavBar:self.scrollNavBar];
    [[SYPItemManager shareitemManager] setItemTitles:(NSMutableArray *)titles];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor{
    _titleNormalColor = titleNormalColor;
    self.scrollNavBar.titleNormalColor = titleNormalColor;
}

- (void)setTitleSelectedColor:(UIColor *)titleSelectedColor{
    _titleSelectedColor = titleSelectedColor;
    self.scrollNavBar.titleSelectedColor = titleSelectedColor;
}

- (void)setBackgroudSelectedColor:(UIColor *)backgroudSelectedColor {
    _backgroudSelectedColor = backgroudSelectedColor;
    self.scrollNavBar.backgroundSelectedColor = backgroudSelectedColor;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    self.scrollNavBar.backgroundImage = backgroundImage;
}

- (void)setIsGraduallyChangColor:(BOOL)isGraduallyChangColor{
    _isGraduallyChangColor = isGraduallyChangColor;
    self.scrollNavBar.isGraduallyChangColor = isGraduallyChangColor;
}

- (void)setIsGraduallyChangFont:(BOOL)isGraduallyChangFont{
    _isGraduallyChangColor = isGraduallyChangFont;
    self.scrollNavBar.isGraduallyChangFont = isGraduallyChangFont;
}

- (void)setMinFontSize:(NSInteger)minFontSize{
    _minFontSize = minFontSize;
    self.scrollNavBar.minFontSize = minFontSize;
}

- (void)setMaxFontSize:(NSInteger)maxFontSize{
    _maxFontSize = maxFontSize;
    self.scrollNavBar.maxFontSize = maxFontSize;
}

- (void)setNavItemAlignmentCenter:(BOOL)navItemAlignmentCenter {
    _navItemAlignmentCenter = navItemAlignmentCenter;
    self.scrollNavBar.isButtonAlignmentCenter = navItemAlignmentCenter;
}

- (void)setNavItemAutoAdjustContent:(BOOL)navItemAutoAdjustContent {
    _navItemAutoAdjustContent = navItemAutoAdjustContent;
    self.scrollNavBar.isButtonAutoWidth = navItemAutoAdjustContent;
}

- (void)setNavItemShowIndicator:(BOOL)navItemShowIndicator {
    _navItemShowIndicator = navItemShowIndicator;
    self.scrollNavBar.isButtonShowIndicator = navItemShowIndicator;
}

#pragma mark - 初始化

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithTitles:(NSArray *)titles AndPageViews:(NSMutableArray *)pageViews{
    self = [super init];
    if (self) {
        self.titles = titles;
        self.pageViews = pageViews;
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.rootScrollView];
    [self addSubview:self.scrollNavBar];
    
    //self.clipsToBounds          = YES;
    self.userInteractionEnabled = YES;
    if (!self.backgroundColor) {
        self.backgroundColor        = defBackgroundColor;
    }
}

- (void)layoutScrollNavBar {
    //不显示排序按钮的布局
    CGFloat scrollX         = SYPDefaultMargin * 2;
    CGFloat scrollY         = 0;
    CGFloat scrollH         = 45;
    self.navBarH            = scrollH;
    CGFloat scrollW         = self.width - scrollX;
    self.scrollNavBar.frame = CGRectMake(scrollX, scrollY, scrollW, scrollH);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat rootScrollViewX = 0;
    CGFloat rootScrollViewY = self.navBarH;
    CGFloat rootScrollViewW = self.width;
    CGFloat rootScrollViewH = self.rootScrollViewHeight;
    self.rootScrollView.frame = CGRectMake(rootScrollViewX, rootScrollViewY, rootScrollViewW, rootScrollViewH);
    
    if (!self.isLayout) {
        [self.rootScrollView reloadPageViews];
        self.isLayout = YES;
    }
    
    [self layoutScrollNavBar];
}

#pragma mark - 业务逻辑

- (BOOL)checkisHaveSameItem:(NSArray *)titles{
    for (int i = 0; i < titles.count; i++) {
        NSString *title1 = titles[i];
        for (int j = 0; j < titles.count; j++) {
            NSString *title2 = titles[j];
            if (j != i && [title1 isEqualToString:title2]) {
                return YES;
            }
        }
    }
    return NO;
}

@end

