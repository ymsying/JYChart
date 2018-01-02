//
//  SYPFreezeWindowView.m
//  SYPFreezeWindowView
//
//  Created by niko on 17/5/3.
//  Copyright © 2015年 YMS All rights reserved.
//

#import "SYPFreezeWindowView.h"

@interface SYPFreezeWindowView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;  // 主数据区
@property (strong, nonatomic) UIScrollView *sectionScrollView; // 表头
@property (strong, nonatomic) UIScrollView *rowScrollView; // 表首列
@property (strong, nonatomic) SYPSignView *signView; // 表左上角

@property (assign, nonatomic) CGSize cellViewSize;
@property (assign, nonatomic) CGPoint freezePoint;

@property (strong, nonatomic) NSMutableDictionary *cellIdentifier;


@end

@implementation SYPFreezeWindowView

- (UIScrollView *)mainView {
    return _mainScrollView;
}

- (UIScrollView *)sectionView {
    return _sectionScrollView;
}

- (UIScrollView *)rowView {
    return _rowScrollView;
}

- (SYPSignView *)signView {
    return _signView;
}

- (instancetype)initWithFrame:(CGRect)frame FreezePoint: (CGPoint) freezePoint cellViewSize: (CGSize) cellViewSize {
    self = [super initWithFrame:frame];
    if (self) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(freezePoint.x, freezePoint.y, frame.size.width - freezePoint.x, frame.size.height - freezePoint.y)];
        _sectionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(freezePoint.x, 0, frame.size.width - freezePoint.x, freezePoint.y)];
        _rowScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, freezePoint.y, freezePoint.x, frame.size.height - freezePoint.y)];
        _signView = [[SYPSignView alloc] initWithFrame:CGRectMake(0, 0, freezePoint.x, freezePoint.y)];
        [self addSubview:_mainScrollView];
        [self addSubview:_sectionScrollView];
        [self addSubview:_rowScrollView];
        [self addSubview:_signView];
        self.mainScrollView.delegate = self;
        self.sectionScrollView.delegate = self;
        self.rowScrollView.delegate = self;
        
        _mainScrollView.bounces = NO;
        _sectionScrollView.bounces = NO;
        _rowScrollView.bounces = NO;
        
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _sectionScrollView.showsHorizontalScrollIndicator = NO;
        _sectionScrollView.showsVerticalScrollIndicator = NO;
        _rowScrollView.showsHorizontalScrollIndicator = NO;
        _rowScrollView.showsVerticalScrollIndicator = NO;
        
        _mainScrollView.clipsToBounds = NO;
        _sectionScrollView.clipsToBounds = NO;
        _rowScrollView.clipsToBounds = NO;
//        _mainScrollView.backgroundColor = [UIColor whiteColor];
//        _sectionScrollView.backgroundColor = [UIColor whiteColor];
//        _rowScrollView.backgroundColor = [UIColor whiteColor];
        
        [self setContentSize];
        
        _freezePoint = freezePoint;
        _cellViewSize = cellViewSize;
        _cellIdentifier = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setSignViewWithContent:(NSString *)content {
    self.signView.content = content;
}

- (SYPMainViewCell *)dequeueReusableMainCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *mainCellsWithIndexPath = [self.cellIdentifier objectForKey:identifier];
    SYPMainViewCell *mainViewCell = [mainCellsWithIndexPath objectForKey:indexPath];
    return mainViewCell;
}

- (SYPSectionViewCell *)dequeueReusableSectionCellWithIdentifier:(NSString *)identifier forSection:(NSInteger)section {
    NSMutableDictionary *sectionCellsWithSection = [self.cellIdentifier objectForKey:identifier];
    SYPSectionViewCell *sectionViewCell = [sectionCellsWithSection objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
    return sectionViewCell;
}

- (SYPRowViewCell *)dequeueReusableRowCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row {
    NSMutableDictionary *rowCellsWithRow = [self.cellIdentifier objectForKey:identifier];
    SYPRowViewCell *rowViewCell = [rowCellsWithRow objectForKey:[NSString stringWithFormat:@"%ld",(long)row]];
    return rowViewCell;
}

- (void)setSignViewBackgroundColor:(UIColor *)color {
    self.signView.backgroundColor = color;
}

- (void)setMainViewBackgroundColor:(UIColor *)color {
    self.mainScrollView.backgroundColor = color;
}

- (void)setSectionViewBackgroundColor:(UIColor *)color {
    self.sectionScrollView.backgroundColor = color;
}

- (void)setRowViewBackgroundColor:(UIColor *)color {
    self.rowScrollView.backgroundColor = color;
}

- (void)reloadData {
    for (NSDictionary *dic in [self.cellIdentifier allValues]) {
        for (UIView *view in [dic allValues]) {
            [view removeFromSuperview];
        }
    }
    [self.cellIdentifier removeAllObjects];
    [self reloadViews];
}

#pragma mark - private method
- (void)scrollViewDidScroll:(nonnull UIScrollView *)scrollView
{
    [self refreshViewWhenScroll];
    [self sectionCellInSectionScrollView];
    if ([scrollView isEqual:self.mainScrollView]) {
        // stop other scrollView scroll
        [self.sectionScrollView setContentOffset:self.sectionScrollView.contentOffset animated:NO];
        [self.rowScrollView setContentOffset:self.rowScrollView.contentOffset animated:NO];
        self.sectionScrollView.delegate = nil;
        self.rowScrollView.delegate = nil;
        if (self.bounceStyle == SYPFreezeWindowViewBounceStyleAll) {
            if (self.mainScrollView.contentOffset.y <= 0) {
                [self.sectionScrollView setFrame:CGRectMake(self.sectionScrollView.frame.origin.x, - self.mainScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height)];
                [self.signView setFrame:CGRectMake(self.signView.frame.origin.x, - self.mainScrollView.contentOffset.y, self.signView.frame.size.width, self.signView.frame.size.height)];
            }
            if (self.mainScrollView.contentOffset.x <= 0) {
                [self.rowScrollView setFrame:CGRectMake(- self.mainScrollView.contentOffset.x, self.rowScrollView.frame.origin.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height)];
                [self.signView setFrame:CGRectMake(- self.mainScrollView.contentOffset.x, self.signView.frame.origin.y, self.signView.frame.size.width, self.signView.frame.size.height)];
            }
        }
        // the follow code must writre at last
        [self.sectionScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, 0)];
        [self.rowScrollView setContentOffset:CGPointMake(0, self.mainScrollView.contentOffset.y)];
    } else if ([scrollView isEqual:self.sectionScrollView]) {
        [self.mainScrollView setContentOffset:self.mainScrollView.contentOffset animated:NO];
        [self.rowScrollView setContentOffset:self.rowScrollView.contentOffset animated:NO];
        self.mainScrollView.delegate = nil;
        self.rowScrollView.delegate = nil;
        if (self.bounceStyle == SYPFreezeWindowViewBounceStyleAll && self.sectionScrollView.contentOffset.x <= 0) {
            [self.rowScrollView setFrame:CGRectMake(- self.sectionScrollView.contentOffset.x, self.rowScrollView.frame.origin.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height)];
            [self.signView setFrame:CGRectMake(- self.sectionScrollView.contentOffset.x, 0, self.signView.frame.size.width, self.signView.frame.size.height)];
        }
        [self.mainScrollView setContentOffset:CGPointMake(self.sectionScrollView.contentOffset.x, self.mainScrollView.contentOffset.y)];
    } else if ([scrollView isEqual:self.rowScrollView]) {
        [self.mainScrollView setContentOffset:self.mainScrollView.contentOffset animated:NO];
        [self.sectionScrollView setContentOffset:self.sectionScrollView.contentOffset animated:NO];
        self.mainScrollView.delegate = nil;
        self.sectionScrollView.delegate = nil;
        if (self.bounceStyle == SYPFreezeWindowViewBounceStyleAll && self.rowScrollView.contentOffset.y <= 0) {
            [self.sectionScrollView setFrame:CGRectMake(self.sectionScrollView.frame.origin.x, - self.rowScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height)];
            [self.signView setFrame:CGRectMake(0, - self.rowScrollView.contentOffset.y, self.signView.frame.size.width, self.signView.frame.size.height)];
        }
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, self.rowScrollView.contentOffset.y)];
    }
    self.mainScrollView.delegate = self;
    self.sectionScrollView.delegate = self;
    self.rowScrollView.delegate = self;
}

- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView {
    [self autoAligning];
    [self reloadViews];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self autoAligning];
    }
}

- (void)autoAligning {
    if (self.autoHorizontalAligning && !self.autoVerticalAligning) {
        float multipleX = roundf(self.mainScrollView.contentOffset.x / self.cellViewSize.width);
        [self.mainScrollView setContentOffset:CGPointMake(self.cellViewSize.width * multipleX, self.mainScrollView.contentOffset.y) animated:YES];
    } else if (self.autoVerticalAligning && !self.autoHorizontalAligning) {
        float mutipleY = roundf(self.mainScrollView.contentOffset.y / self.cellViewSize.height);
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, self.cellViewSize.height * mutipleY) animated:YES];
    } else if (self.autoHorizontalAligning && self.autoVerticalAligning) {
        float multipleX = roundf(self.mainScrollView.contentOffset.x / self.cellViewSize.width);
        float mutipleY = roundf(self.mainScrollView.contentOffset.y / self.cellViewSize.height);
        [self.mainScrollView setContentOffset:CGPointMake(self.cellViewSize.width * multipleX, self.cellViewSize.height * mutipleY) animated:YES];
    }
}

- (void)sectionCellInSectionScrollView {
    if (_delegate) {
        if (self.keyIndexPath != nil) {
            SYPSectionViewCell *sectionViewCell = [_delegate sectionCellPointInfreezeWindowView:self];
            if ([sectionViewCell superview]) {
                NSInteger cellAtSection = (sectionViewCell.frame.origin.x - self.mainScrollView.contentOffset.x) / self.cellViewSize.width;
                if (cellAtSection == self.keyIndexPath.section) {
                    NSInteger section = sectionViewCell.frame.origin.x / self.cellViewSize.width;
                    [_delegate sectionCellReachKey:sectionViewCell withSection:section];
                }
            }
        }
    }
}

- (void)tapMainViewCell:(UITapGestureRecognizer *) tapGestureRecognizer {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tapGestureRecognizer.view.frame.origin.y / self.cellViewSize.height inSection:tapGestureRecognizer.view.frame.origin.x / self.cellViewSize.width];
    [_delegate freezeWindowView:self didSelectMainZoneIndexPath:indexPath];
}

- (void)tapSectionToTop:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.rowScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self reloadViews];
}

- (void)tapRowToLeft:(UITapGestureRecognizer *)tapFestureRecognizer {
    [self.sectionScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self reloadViews];
}

- (void)setDataSource:(id<SYPFreezeWindowViewDataSource> __nullable)dataSource {
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self setContentSize];
    }
}

- (void)setDelegate:(id<SYPFreezeWindowViewDelegate> __nullable)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}

- (void)setStyle:(SYPFreezeWindowViewStyle)style {
    _style = style;
}

- (void)setBounceStyle:(SYPFreezeWindowViewBounceStyle)bounceStyle {
    _bounceStyle = bounceStyle;
    switch (bounceStyle) {
        case SYPFreezeWindowViewBounceStyleNone:
        {
            self.mainScrollView.bounces = NO;
            self.sectionScrollView.bounces = NO;
            self.rowScrollView.bounces = NO;
        }
            break;
        case SYPFreezeWindowViewBounceStyleMain:
        {
            self.mainScrollView.bounces = YES;
            self.sectionScrollView.bounces = YES;
            self.rowScrollView.bounces = YES;
        }
        case SYPFreezeWindowViewBounceStyleAll:
        {
            self.mainScrollView.bounces = YES;
            self.sectionScrollView.bounces = YES;
            self.rowScrollView.bounces = YES;
            [self.sectionScrollView setContentSize:CGSizeMake(self.sectionScrollView.contentSize.width, self.sectionScrollView.contentSize.height * 2)];
        }
        default:
            break;
    }
}

- (void)setTapToTop:(BOOL)tapToTop {
    _tapToTop = tapToTop;
    if (tapToTop) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionToTop:)];
        [self.sectionScrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)setTapToLeft:(BOOL)tapToLeft {
    _tapToLeft = tapToLeft;
    if (tapToLeft) {
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRowToLeft:)];
        [self.rowScrollView addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    if (showsHorizontalScrollIndicator) {
        self.mainScrollView.showsHorizontalScrollIndicator = YES;
    } else {
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
    }
}

- (void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator {
    _showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    if (showsVerticalScrollIndicator) {
        self.mainScrollView.showsVerticalScrollIndicator = YES;
    } else {
        self.mainScrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)setContentSize {
    NSInteger sectionNumber = [_dataSource numberOfSectionsInFreezeWindowView:self];
    NSInteger rowNumber = [_dataSource numberOfRowsInFreezeWindowView:self];
    [self.mainScrollView setContentSize:CGSizeMake(self.cellViewSize.width * sectionNumber, self.cellViewSize.height * rowNumber)];
    [self.sectionScrollView setContentSize:CGSizeMake(self.cellViewSize.width * sectionNumber, 0)];
    [self.rowScrollView setContentSize:CGSizeMake(0, self.cellViewSize.height * rowNumber)];
    if (self.bounceStyle == SYPFreezeWindowViewBounceStyleNone) {
        // 整个视图内部不滑动，跟随外部视图滑动
        if (!self.flexibleHeight) {
            self.mainScrollView.bounds = CGRectMake(0, 0, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height);
            self.rowScrollView.bounds = CGRectMake(0, 0, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height);
        }
    }
}


- (void)refreshViewWhenScroll {
    NSInteger section = ((NSInteger)(self.mainScrollView.contentOffset.x - 0.5) / self.cellViewSize.width - 1) < 0 ? 0 : ((NSInteger)(self.mainScrollView.contentOffset.x - 0.5) / self.cellViewSize.width - 1);
    NSInteger row = ((NSInteger)(self.mainScrollView.contentOffset.y - 0.5) / self.cellViewSize.height - 1) < 0 ? 0 : ((NSInteger)(self.mainScrollView.contentOffset.y - 0.5) / self.cellViewSize.height - 1);
    NSInteger sectionMax = (self.mainScrollView.contentOffset.x - 0.5) / self.cellViewSize.width + self.mainScrollView.frame.size.width / self.cellViewSize.width + 2;
    if (sectionMax >= [_dataSource numberOfSectionsInFreezeWindowView:self]) {
        sectionMax = [_dataSource numberOfSectionsInFreezeWindowView:self] - 1;
    }
    NSInteger rowMax = (self.mainScrollView.contentOffset.y - 0.5) / self.cellViewSize.height + self.mainScrollView.frame.size.height / self.cellViewSize.height + 2;
    if (rowMax >= [_dataSource numberOfRowsInFreezeWindowView:self]) {
        rowMax = [_dataSource numberOfRowsInFreezeWindowView:self] - 1;
    }
    for (NSInteger sectionNext = section < 0 ? 0 : section; sectionNext <= sectionMax; sectionNext++) {
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:row inSection:sectionNext]];
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowMax inSection:sectionNext]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:sectionNext]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowMax + 1 inSection:sectionNext]];
    }
    for (NSInteger rowNext = row < 0 ? 0 : row; rowNext <= rowMax; rowNext++) {
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:section]];
        [self addMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:sectionMax]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:section - 1]];
        [self removeMainViewCellWithIndexPath:[NSIndexPath indexPathForRow:rowNext inSection:sectionMax + 1]];
        
    }
    [self addSectionViewCellWithSection:section];
    [self addSectionViewCellWithSection:sectionMax];
    [self addRowViewCellWithRow:row];
    [self addRowViewCellWithRow:rowMax];
    [self removeSectionViewCellWithSection:section - 1];
    [self removeSectionViewCellWithSection:sectionMax + 1];
    [self removeRowViewCellWithRow:row - 1];
    [self removeRowViewCellWithRow:rowMax + 1];
}

- (void)reloadViews {
    NSInteger sectionNumber = [_dataSource numberOfSectionsInFreezeWindowView:self];
    NSInteger rowNumber = [_dataSource numberOfRowsInFreezeWindowView:self];
    NSInteger sectionInScreen = self.mainScrollView.contentOffset.x / self.cellViewSize.width + self.mainScrollView.frame.size.width / self.cellViewSize.width + 3;
    NSInteger rowInScreen = self.mainScrollView.contentOffset.y / self.cellViewSize.height + self.mainScrollView.frame.size.height / self.cellViewSize.height + 3;
    for (NSInteger row = self.mainScrollView.contentOffset.y / self.cellViewSize.height < 0 ? 0 : self.mainScrollView.contentOffset.y / self.cellViewSize.height; (row < rowNumber && row < rowInScreen); row++) {
        for (NSInteger section = self.mainScrollView.contentOffset.x / self.cellViewSize.width < 0 ? 0 : self.mainScrollView.contentOffset.x / self.cellViewSize.width; (section < sectionNumber && section < sectionInScreen); section++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [self addMainViewCellWithIndexPath:indexPath];
            [self addSectionViewCellWithSection:indexPath.section];
            [self addRowViewCellWithRow:indexPath.row];
        }
    }
}


#pragma mark - remove a cell
- (void)removeMainViewCellWithIndexPath:(NSIndexPath *)indexPath {
    SYPMainViewCell *mainViewCell = [_dataSource freezeWindowView:self cellForRowAtIndexPath:indexPath];
    CGRect intersectionRect = CGRectIntersection(mainViewCell.frame, CGRectMake(self.mainScrollView.contentOffset.x, self.mainScrollView.contentOffset.y, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height));
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        [mainViewCell removeFromSuperview];
    }
}

- (void)removeSectionViewCellWithSection:(NSInteger)section {
    SYPSectionViewCell *sectionViewCell = [_dataSource freezeWindowView:self cellAtSection:section];
    CGRect intersectionRect = CGRectIntersection(sectionViewCell.frame, CGRectMake(self.sectionScrollView.contentOffset.x, self.sectionScrollView.contentOffset.y, self.sectionScrollView.frame.size.width, self.sectionScrollView.frame.size.height));
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        [sectionViewCell removeFromSuperview];
    }
}

- (void)removeRowViewCellWithRow:(NSInteger)row {
    SYPRowViewCell *rowViewCell = [_dataSource freezeWindowView:self cellAtRow:row];
    CGRect intersectionRect = CGRectIntersection(rowViewCell.frame, CGRectMake(self.rowScrollView.contentOffset.x, self.rowScrollView.contentOffset.y, self.rowScrollView.frame.size.width, self.rowScrollView.frame.size.height));
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        [rowViewCell removeFromSuperview];
    }
}

#pragma mark - add a cell
- (void)addMainViewCellWithIndexPath:(NSIndexPath *)indexPath {
    SYPMainViewCell *mainViewCell = [_dataSource freezeWindowView:self cellForRowAtIndexPath:indexPath];
    if (mainViewCell != nil && [mainViewCell superview] == nil) {
        NSString *mainReuseIdentifier = mainViewCell.reuseIdentifier;
        [self.mainScrollView addSubview:mainViewCell];
        if ([self dequeueReusableMainCellWithIdentifier:mainReuseIdentifier forIndexPath:indexPath] == nil) {
            if (_delegate) {
                UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMainViewCell:)];
                [mainViewCell addGestureRecognizer:gestureRecognizer];
            }
            [mainViewCell setFrame:CGRectMake(indexPath.section * self.cellViewSize.width, indexPath.row * self.cellViewSize.height, self.cellViewSize.width * mainViewCell.sectionNumber, self.cellViewSize.height * mainViewCell.rowNumber)];
            NSMutableDictionary *mainCellsWithIndexPath = [self.cellIdentifier objectForKey:mainReuseIdentifier];
            if (mainCellsWithIndexPath == nil) {
                mainCellsWithIndexPath = [[NSMutableDictionary alloc] init];
                [mainCellsWithIndexPath setObject:mainViewCell forKey:indexPath];
                [self.cellIdentifier setObject:mainCellsWithIndexPath forKey:mainReuseIdentifier];
            } else {
                [mainCellsWithIndexPath setObject:mainViewCell forKey:indexPath];
            }
        }
    }
}

- (void)addSectionViewCellWithSection:(NSInteger)section {
    SYPSectionViewCell *sectionViewCell = [_dataSource freezeWindowView:self cellAtSection:section];
    if (sectionViewCell != nil && [sectionViewCell superview] == nil) {
        NSString *sectionReuseIdentifier = sectionViewCell.reuseIdentifier;
        [self.sectionScrollView addSubview:sectionViewCell];
        if ([self dequeueReusableSectionCellWithIdentifier:sectionReuseIdentifier forSection:section] == nil) {
            // TODO: 添加纵向按钮的点击
            
            
            [sectionViewCell setFrame:CGRectMake(section * self.cellViewSize.width, 0, self.cellViewSize.width, self.freezePoint.y)];
            NSMutableDictionary *sectionCellsWithSection = [self.cellIdentifier objectForKey:sectionReuseIdentifier];
            if (sectionCellsWithSection == nil) {
                sectionCellsWithSection = [[NSMutableDictionary alloc] init];
                [sectionCellsWithSection setObject:sectionViewCell forKey:[NSString stringWithFormat:@"%ld",(long)section]];
                [self.cellIdentifier setObject:sectionCellsWithSection forKey:sectionReuseIdentifier];
            } else {
                [sectionCellsWithSection setObject:sectionViewCell forKey:[NSString stringWithFormat:@"%ld",(long)section]];
            }
        }
    }
}

- (void)addRowViewCellWithRow:(NSInteger)row {
    SYPRowViewCell *rowViewCell = [_dataSource freezeWindowView:self cellAtRow:row];
    if (rowViewCell != nil && [rowViewCell superview] == nil) {
        NSString *rowReuseIdentifier = rowViewCell.reuseIdentifier;
        [self.rowScrollView addSubview:rowViewCell];
        if ([self dequeueReusableRowCellWithIdentifier:rowReuseIdentifier forRow:row] == nil) {
            // TODO: 添加横向按钮的点击
            
            
            switch (_style) {
                case SYPFreezeWindowViewStyleDefault:
                    [rowViewCell setFrame:CGRectMake(0, self.cellViewSize.height * row, self.freezePoint.x, self.cellViewSize.height)];
                    break;
                case SYPFreezeWindowViewStyleRowOnLine:
                    [rowViewCell setFrame:CGRectMake(0, self.cellViewSize.height * row + self.cellViewSize.height / 2, self.freezePoint.x, self.cellViewSize.height)];
                    rowViewCell.separatorStyle = SYPFreezeViewCellSeparatorStyleNone;
                default:
                    break;
            }
            NSMutableDictionary *rowCellsWithRow = [self.cellIdentifier objectForKey:rowReuseIdentifier];
            if (rowCellsWithRow == nil) {
                rowCellsWithRow = [[NSMutableDictionary alloc] init];
                [rowCellsWithRow setObject:rowViewCell forKey:[NSString stringWithFormat:@"%ld",(long)row]];
                [self.cellIdentifier setObject:rowCellsWithRow forKey:rowReuseIdentifier];
            } else {
                [rowCellsWithRow setObject:rowViewCell forKey:[NSString stringWithFormat:@"%ld",(long)row]];
            }
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self reloadViews];
}

@end
