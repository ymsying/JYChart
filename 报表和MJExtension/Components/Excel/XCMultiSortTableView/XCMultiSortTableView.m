//
//  XCMultiTableView.h
//  XCMultiTableDemo
//
//  Created by Kingiol on 13-7-20.
//  Copyright (c) 2013年 Kingiol. All rights reserved.
//

#import "XCMultiSortTableView.h"

#import "XCMultiSortTableViewDefault.h"
#import "XCMultiSortTableViewBGScrollView.h"
#import "UIView+XCMultiSortTableView.h"
#import "SYPConstantColor.h"

#define AddHeightTo(v, h) { CGRect f = v.frame; f.size.height += h; v.frame = f; }

@interface XCMultiTableView () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

- (void)reset;
- (void)adjustView;
- (void)setUpTopHeaderScrollView;
- (void)accessColumnPointCollection;
- (void)buildSectionFoledStatus:(NSInteger)section;

- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column;
- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@implementation XCMultiTableView {
    
    XCMultiTableViewBGScrollView *contentScrollView;
    UITableView *leftHeaderTableView;
    UITableView *contentTableView;
    
    NSInteger contentTabelSelectedViewTag;

    UILabel *vertextLabel;
    
    NSMutableDictionary *sectionFoldedStatus;
    NSArray *columnPointCollection;
    
    NSMutableArray *leftHeaderDataArray;
    NSMutableArray *contentDataArray;
    
    NSMutableDictionary *columnTapViewDict;
    
    NSMutableDictionary *columnSortedTapFlags;
    
    BOOL responseToNumberSections;
    BOOL responseContentTableCellWidth;
    BOOL responseNumberofContentColumns;
    BOOL responseCellHeight;
    BOOL responseFlagColorForRow;
    BOOL responseTopHeaderHeight;
    BOOL responseBgColorForColumn;
    BOOL responseHeaderBgColorForColumn;
}

@synthesize cellWidth, cellHeight, topHeaderHeight, leftHeaderWidth, sectionHeaderHeight, boldSeperatorLineWidth, normalSeperatorLineWidth, flagContentColor;
@synthesize boldSeperatorLineColor, normalSeperatorLineColor;

@synthesize leftHeaderEnable;

@synthesize datasource;

@synthesize topHeaderScrollView, vertexView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderColor = [[UIColor colorWithWhite:XCMultiTableView_BoraerColorGray alpha:1.0f] CGColor];
        self.layer.cornerRadius = XCMultiTableView_CornerRadius;
        self.layer.borderWidth = XCMultiTableView_BorderWidth;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        columnTapViewDict = [NSMutableDictionary dictionary];
        columnSortedTapFlags = [NSMutableDictionary dictionary];
        
        cellWidth = XCMultiTableView_DefaultCellWidth;
        cellHeight = XCMultiTableView_DefaultCellHeight;
        topHeaderHeight = XCMultiTableView_DefaultTopHeaderHeight;
        leftHeaderWidth = XCMultiTableView_DefaultLeftHeaderWidth;
        sectionHeaderHeight = XCMultiTableView_DefaultSectionHeaderHeight;
        
        boldSeperatorLineWidth = XCMultiTableView_DefaultBoldLineWidth;
        normalSeperatorLineWidth = XCMultiTableView_DefaultNormalLineWidth;
        
        boldSeperatorLineColor = [UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0];
        normalSeperatorLineColor = [UIColor colorWithWhite:XCMultiTableView_DefaultLineGray alpha:1.0];
        flagContentColor = [UIColor colorWithWhite:XCMultiTableView_DefaultFlagColor alpha:1.0];
        
        vertexView = [[UIView alloc] initWithFrame:CGRectZero];
        vertexView.backgroundColor = SYPColor_BackgroudColor_SubWhite;
        vertexView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:vertexView];
        
        vertextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        vertextLabel.backgroundColor = SYPColor_BackgroudColor_SubWhite;
        vertextLabel.textColor = SYPColor_TextColor_Chief;
        vertextLabel.font = [UIFont systemFontOfSize:13];
        vertextLabel.textAlignment = NSTextAlignmentCenter;
        [vertexView addSubview:vertextLabel];
        
        topHeaderScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        topHeaderScrollView.backgroundColor = SYPColor_BackgroudColor_SubWhite;
        topHeaderScrollView.parent = self;
        topHeaderScrollView.delegate = self;
        topHeaderScrollView.showsHorizontalScrollIndicator = NO;
        topHeaderScrollView.showsVerticalScrollIndicator = NO;
        topHeaderScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:topHeaderScrollView];
        
        leftHeaderTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        leftHeaderTableView.dataSource = self;
        leftHeaderTableView.delegate = self;
        leftHeaderTableView.bounces = NO;
        leftHeaderTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        leftHeaderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        leftHeaderTableView.backgroundColor = [UIColor clearColor];
        [self addSubview:leftHeaderTableView];
        
        contentScrollView = [[XCMultiTableViewBGScrollView alloc] initWithFrame:CGRectZero];
        contentScrollView.backgroundColor = [UIColor clearColor];
        contentScrollView.parent = self;
        contentScrollView.delegate = self;
        contentScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:contentScrollView];
        
        contentTableView = [[UITableView alloc] initWithFrame:contentScrollView.bounds];
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        contentTableView.bounces = NO;
        contentTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.backgroundColor = [UIColor clearColor];
        [contentScrollView addSubview:contentTableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    CGFloat superWidth = self.bounds.size.width;
    CGFloat superHeight = self.bounds.size.height;
    
    if (leftHeaderEnable) {
        vertexView.frame = CGRectMake(0, 0, leftHeaderWidth, topHeaderHeight);
        vertextLabel.frame = vertexView.bounds;
        
        if ([self.datasource respondsToSelector:@selector(vertexName)]) {
            vertextLabel.text = [self.datasource vertexName];
        }
        
        topHeaderScrollView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, 0, superWidth - leftHeaderWidth - boldSeperatorLineWidth, topHeaderHeight);
        leftHeaderTableView.frame = CGRectMake(0, topHeaderHeight + boldSeperatorLineWidth, leftHeaderWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
        contentScrollView.frame = CGRectMake(leftHeaderWidth + boldSeperatorLineWidth, topHeaderHeight + boldSeperatorLineWidth, superWidth - leftHeaderWidth - boldSeperatorLineWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
    }else {
        topHeaderScrollView.frame = CGRectMake(0, 0, superWidth, topHeaderHeight);
        contentScrollView.frame = CGRectMake(0, topHeaderHeight + boldSeperatorLineWidth, superWidth, superHeight - topHeaderHeight - boldSeperatorLineWidth);
    }
    
    [self adjustView];
}

- (void)reloadData {
    [self reset];
    [leftHeaderTableView reloadData];
    [contentTableView reloadData];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, boldSeperatorLineWidth);
    CGContextSetAllowsAntialiasing(context, false);
    CGContextSetStrokeColorWithColor(context, [boldSeperatorLineColor CGColor]);

    if (leftHeaderEnable) {
        CGFloat x = leftHeaderWidth + boldSeperatorLineWidth / 2.0f;
        CGContextMoveToPoint(context, x, 0.0f);
        CGContextAddLineToPoint(context, x, CGRectGetMaxY(contentTableView.visibleCells.lastObject.frame) + topHeaderHeight);
        CGFloat y = topHeaderHeight + boldSeperatorLineWidth / 2.0f;
        CGContextMoveToPoint(context, 0.0f, y);
        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    }else {
        CGFloat y = topHeaderHeight + boldSeperatorLineWidth / 2.0f;
        CGContextMoveToPoint(context, 0.0f, y);
        CGContextAddLineToPoint(context, self.bounds.size.width, y);
    }

    CGContextStrokePath(context);
}

- (void)dealloc {
    topHeaderScrollView = nil;
    contentScrollView = nil;
    leftHeaderTableView = nil;
    contentTableView = nil;
    vertexView = nil;
    columnPointCollection = nil;
}

#pragma mark - property

- (void)setDatasource:(id<XCMultiTableViewDataSource>)datasource_ {
    if (datasource != datasource_) {
        datasource = datasource_;
        
        responseToNumberSections = [datasource_ respondsToSelector:@selector(numberOfSectionsInTableView:)];
        responseContentTableCellWidth = [datasource_ respondsToSelector:@selector(tableView:contentTableCellWidth:)];
        responseNumberofContentColumns = [datasource_ respondsToSelector:@selector(arrayDataForTopHeaderInTableView:)];
        responseCellHeight = [datasource_ respondsToSelector:@selector(tableView:cellHeightInRow:InSection:)];
        responseFlagColorForRow = [datasource_ respondsToSelector:@selector(tableView:contentColorInRow:InSection:)];
        responseTopHeaderHeight = [datasource_ respondsToSelector:@selector(topHeaderHeightInTableView:)];
        responseBgColorForColumn = [datasource_ respondsToSelector:@selector(tableView:bgColorInSection:InRow:InColumn:)];
        responseHeaderBgColorForColumn = [datasource_ respondsToSelector:@selector(tableView:headerBgColorInColumn:)];
        
//        [self reset];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint childP = [self convertPoint:point toView:leftHeaderTableView];
    if ([leftHeaderTableView hitTest:childP withEvent:event]) {
        return leftHeaderTableView;
    }
    childP = [self convertPoint:point toView:contentTableView];
    if ([contentTableView hitTest:childP withEvent:event]) {
        
        for (NSInteger i = contentTableView.visibleCells.count-1; i >= 0; i--) {
            UIView *contentView = (contentTableView.visibleCells[i]).contentView;
            CGPoint cellP = [contentTableView convertPoint:childP toView:contentView];
            if ([contentView hitTest:cellP withEvent:event]) {
                
                for (NSInteger j = contentView.subviews.count-1; j >= 0; j--) {
                    UIView *subView = contentView.subviews[j];
                    CGPoint viewP = [contentView convertPoint:cellP toView:subView];
                    if ([subView hitTest:viewP withEvent:event]) {
                        
                        contentTabelSelectedViewTag = subView.tag;
                        return subView;
                    }
                }
            }
        }
        return contentTableView;
    }
    return [super hitTest:point withEvent:event];
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *target = nil;
    if (tableView == leftHeaderTableView) {
        target = contentTableView;
        if ([self.delegate respondsToSelector:@selector(tableViewWithType:didSelectRowAtIndexPath:InColumn:)]) {
            [self.delegate tableViewWithType:MultiTableViewTypeLeft didSelectRowAtIndexPath:indexPath InColumn:0];
        }
    }else if (tableView == contentTableView) {
        target = leftHeaderTableView;
        if ([self.delegate respondsToSelector:@selector(tableViewWithType:didSelectRowAtIndexPath:InColumn:)]) {
            [self.delegate tableViewWithType:MultiTableViewTypeRight didSelectRowAtIndexPath:indexPath InColumn:contentTabelSelectedViewTag];
        }
    }else {
        target = nil;
    }
    [target selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightInIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger rows = 0;
    if (![self foldedInSection:section]) {
        rows = [self rowsInSection:section];
    }
    
    return rows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self numberOfSections];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == leftHeaderTableView) {
        return [self leftHeaderTableView:tableView cellForRowAtIndexPath:indexPath];
    }else {
        return [self contentTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UIScrollView *target = nil;
    if (scrollView == leftHeaderTableView) {
        target = contentTableView;
    }else if (scrollView == contentTableView) {
        target = leftHeaderTableView;
    }else if (scrollView == contentScrollView) {
        target = topHeaderScrollView;
    }else if (scrollView == topHeaderScrollView) {
        target = contentScrollView;
    }
    target.contentOffset = scrollView.contentOffset;
}

#pragma mark - private method

- (void)reset {
    
    [self accessDataSourceData];
    
    vertexView.backgroundColor = [self headerBgColorColumn:-1];
    [self accessColumnPointCollection];
    [self buildSectionFoledStatus:-1];
    [self setUpTopHeaderScrollView];
    [contentScrollView reDraw];
}

- (void)adjustView {
    
    CGFloat width = 0.0f;
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (int i = 1; i <= count + 1; i++) {
        if (i == count + 1) {
            width += normalSeperatorLineWidth;
        }else {
            width += normalSeperatorLineWidth + [self accessContentTableViewCellWidth:i - 1];
        }
    }
    
    NSLog(@"width:%f, height:%f", self.frame.size.width, self.frame.size.height);
    
    topHeaderScrollView.contentSize = CGSizeMake(width, topHeaderHeight);
    contentScrollView.contentSize = CGSizeMake(width, self.bounds.size.height - topHeaderHeight - boldSeperatorLineWidth);
    
    contentTableView.frame = CGRectMake(0.0f, 0.0f, width, self.bounds.size.height - topHeaderHeight - boldSeperatorLineWidth);
}

- (void)buildSectionFoledStatus:(NSInteger)section {
    if (sectionFoldedStatus == nil) sectionFoldedStatus = [NSMutableDictionary dictionary];

    NSUInteger sections = [self numberOfSections];
    for (int i = 0; i < sections; i++) {
        if (section == -1) {
            [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:i]];
        }else if (i == section) {
            if ([self foldedInSection:section]) {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:NO] forKey:[self sectionToString:section]];
            }else {
                [sectionFoldedStatus setObject:[NSNumber numberWithBool:YES] forKey:[self sectionToString:section]];
            }
            break;
        }
    }
}

- (void)setUpTopHeaderScrollView {
    
    [topHeaderScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    for (NSInteger i = 0; i < count; i++) {
        
        CGFloat topHeaderW = [self accessContentTableViewCellWidth:i];
        CGFloat topHeaderH = [self accessTopHeaderHeight];
        
        CGFloat widthP = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, topHeaderW, topHeaderH)];
        view.clipsToBounds = YES;
        view.center = CGPointMake(widthP, topHeaderH / 2.0f);
        view.tag = i - 10000;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = [[datasource arrayDataForTopHeaderInTableView:self] objectAtIndex:i];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = SYPColor_TextColor_Chief;
        label.numberOfLines = 0;
        [label sizeToFit];
        
        AlignHorizontalPosition alignPosition = AlignHorizontalPositionLeft;
        if ([self.datasource respondsToSelector:@selector(tableView:inColumn:)]) {
            alignPosition = [self.datasource tableView:self inColumn:i];
        }
        
        switch (alignPosition) {
            case AlignHorizontalPositionLeft:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(labelW * 0.5 - 10, topHeaderH * 0.5);
            }
                break;
            case AlignHorizontalPositionRight:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(topHeaderW - labelW * 0.5 - 10, topHeaderH * 0.5);
            }
                break;
            default:
            {
                label.center = CGPointMake(topHeaderW / 2.0f - 10, topHeaderH / 2.0f);
            }
                break;
        }
        
        UIColor *color = [self headerBgColorColumn:i];
        view.backgroundColor = color;
        label.backgroundColor = color;
        
        [view addSubview:label];
        
        UIImageView *sortIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_sort"]];
        sortIcon.tag = view.tag + 20000;
        sortIcon.frame = ({
            CGRect frame = label.frame;
            frame.size.width = 6;
            frame.size.height = 12;
            frame.origin.x += (label.frame.size.width + 4);
            frame.origin.y = (label.center.y - 6);
            frame;
        });
        [view addSubview:sortIcon];
        NSLog(@"%@", sortIcon);
        
        
        UITapGestureRecognizer *topHeaderGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentHeaderTap:)];
        
        [view addGestureRecognizer:topHeaderGecognizer];
        
        NSString *columnStr = [NSString stringWithFormat:@"-1_%@", @(view.tag)];
        [columnTapViewDict setObject:view forKey:columnStr];
        
        if ([columnSortedTapFlags objectForKey:columnStr] == nil) {
            [columnSortedTapFlags setObject:@(TableColumnSortTypeNone) forKey:columnStr];
        } else {
            sortIcon.image = [UIImage imageNamed:@"icon_array"];
            TableColumnSortType type = [[columnSortedTapFlags objectForKey:columnStr] integerValue];
            if (type == TableColumnSortTypeAsc) {
                sortIcon.layer.transform = CATransform3DIdentity;
            } else if (type == TableColumnSortTypeDesc) {
                sortIcon.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else if (type == TableColumnSortTypeNone) {
                sortIcon.image = [UIImage imageNamed:@"icon_sort"];
            }
        }
        
        [topHeaderScrollView addSubview:view];
    }
    
    [topHeaderScrollView reDraw];

}

- (void)accessColumnPointCollection {
    NSUInteger columns = responseNumberofContentColumns ? [datasource arrayDataForTopHeaderInTableView:self].count : 0;
    if (columns == 0) @throw [NSException exceptionWithName:@"accessColumnPointCollection" reason:@"number of content columns must more than 0" userInfo:nil];
    NSMutableArray *tmpAry = [NSMutableArray array];
    CGFloat widthColumn = 0.0f;
    CGFloat widthP = 0.0f;
    for (int i = 0; i < columns; i++) {
        CGFloat columnWidth = [self accessContentTableViewCellWidth:i];
        widthColumn += (normalSeperatorLineWidth + columnWidth);
        widthP = widthColumn - columnWidth / 2.0f;
        [tmpAry addObject:[NSNumber numberWithFloat:widthP]];
    }
    columnPointCollection = [tmpAry copy];
}

- (CGFloat)accessContentTableViewCellWidth:(NSUInteger)column {
    return responseContentTableCellWidth ? [datasource tableView:self contentTableCellWidth:column] : cellWidth;
}

- (UITableViewCell *)leftHeaderTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *inde = @"leftHeaderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inde];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat cellH = [self cellHeightInIndexPath:indexPath];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftHeaderWidth, cellH)];
    view.clipsToBounds = YES;
    
    UILabel *label =  [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = [[leftHeaderDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    label.numberOfLines = 0;
//    [label sizeToFit];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.center = CGPointMake(leftHeaderWidth / 2.0f + 15, cellH / 2.0f);
    label.frame = ({
        CGRect frame = view.bounds;
        frame.size.width -= 20;
        frame.origin.x += (15 + 4 + 4);
        frame;
    });
    UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:-1];
    view.backgroundColor = color;
    label.backgroundColor = color;
    
    [view addSubview:label];
    
    UIColor *flagColor = [self flagColorInIndexPath:indexPath];
    label.textColor = flagColor;
    if (![flagContentColor isEqual:flagColor]) {
        
        UIView *flagPoint = [[UIView alloc] initWithFrame:CGRectMake(4, (cellH - 15) / 2.0, 15, 15)];
        flagPoint.layer.cornerRadius = CGRectGetWidth(flagPoint.frame)/2.0;
        flagPoint.backgroundColor = [flagColor appendAlpha:0.15];
        //    flagPoint.hidden = YES;
        [view addSubview:flagPoint];
        
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
        point.layer.cornerRadius = CGRectGetWidth(point.frame)/2.0;
        point.backgroundColor = flagColor;
        point.center = CGPointMake(CGRectGetWidth(flagPoint.frame) /2.0, CGRectGetWidth(flagPoint.frame) /2.0);
        [flagPoint addSubview:point];
    }

    
    [cell.contentView addSubview:view];
    
    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}

- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger count = [datasource arrayDataForTopHeaderInTableView:self].count;
    static NSString *cellID = @"contentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    NSMutableArray *ary = [contentDataArray[indexPath.section][indexPath.row] valueForKey:@"mainData"];
    
    for (NSInteger i = 0; i < count; i++) {
        
        CGFloat cellW = [self accessContentTableViewCellWidth:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
        
        CGFloat width = [[columnPointCollection objectAtIndex:i] floatValue];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellW, cellH)];
        view.center = CGPointMake(width, cellH / 2.0f);
        view.clipsToBounds = YES;
        view.tag = i;
        
        id obj = [ary objectAtIndex:i];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.text = [NSString stringWithFormat:@"%@", [obj valueForKey:@"_value"]];
        label.textColor = SYPColor_AlertBackgroudColor_BlackGray;
        [label sizeToFit];
        
        AlignHorizontalPosition alignPosition = AlignHorizontalPositionLeft;
        if ([self.datasource respondsToSelector:@selector(tableView:inColumn:)]) {
            alignPosition = [self.datasource tableView:self inColumn:i];
        }
        
        switch (alignPosition) {
            case AlignHorizontalPositionLeft:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(labelW * 0.5, cellH * 0.5);
            }
                break;
            case AlignHorizontalPositionRight:
            {
                CGFloat labelW = CGRectGetWidth(label.frame);
                label.center = CGPointMake(cellW - labelW * 0.5, cellH * 0.5);
            }
                break;
            default:
            {
                label.center = CGPointMake(cellW / 2.0f, cellH / 2.0f);
            }
                break;
        }
        
        
        UIColor *color = [self bgColorInSection:indexPath.section InRow:indexPath.row InColumn:i];
        
        view.backgroundColor = color;
        label.backgroundColor = color;
        
        [view addSubview:label];
        
        [cell.contentView addSubview:view];
    }
    
    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}

#pragma mark - GestureRecognizer

- (void)leftHeaderTap:(UITapGestureRecognizer *)recognizer {
    
    @synchronized(self) {
        NSUInteger section = recognizer.view.tag;
        [self buildSectionFoledStatus:section];
       
        [leftHeaderTableView beginUpdates];
        [contentTableView beginUpdates];

        NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < [self rowsInSection:section]; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        
        if ([self foldedInSection:section]) {
            [leftHeaderTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [contentTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [leftHeaderTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [contentTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }

        [leftHeaderTableView endUpdates];
        [contentTableView endUpdates];
    }
}

- (void)contentHeaderTap:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    
    NSIndexPath *indexPath = [self accessUIViewVirtualTag:view];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row + 10000 inSection:indexPath.section];
    NSUInteger length = [indexPath length];
    
    if (length != 2) return;
    
    if ([self.delegate respondsToSelector:@selector(tableView:didSelectHeadColumnAtIndexPath:sortType:)]) {
        NSString *columnStr = [NSString stringWithFormat:@"-1_%@", @(view.tag)];
        for (NSString *columnStr1 in columnSortedTapFlags.allKeys) {
            if (![columnStr1 isEqualToString:columnStr]) {
                [columnSortedTapFlags setObject:@(TableColumnSortTypeNone) forKey:columnStr1];
            } else {
                NSLog(@"tag = %@", @(view.tag));
            }
        }
        TableColumnSortType type = [[columnSortedTapFlags objectForKey:columnStr] integerValue];
        if (type == TableColumnSortTypeNone) {
            type = TableColumnSortTypeAsc;
        } else if (type == TableColumnSortTypeAsc) {
            type = TableColumnSortTypeDesc;
        } else if (type == TableColumnSortTypeDesc) {
            type = TableColumnSortTypeAsc;
        }
        [columnSortedTapFlags setObject:@(type) forKey:columnStr];
        
        [self.delegate tableView:self didSelectHeadColumnAtIndexPath:indexPath sortType:type];
    }
}

#pragma mark - other method

- (NSUInteger)rowsInSection:(NSUInteger)section {
    return [[leftHeaderDataArray objectAtIndex:section] count];
}

- (NSUInteger)numberOfSections {
    NSUInteger sections = responseToNumberSections ? [datasource numberOfSectionsInTableView:self] : 1;
    return sections < 1 ? 1 : sections;
}

- (NSString *)sectionToString:(NSUInteger)section {
    return [NSString stringWithFormat:@"%@", @(section)];
}

- (BOOL)foldedInSection:(NSUInteger)section {
    return [[sectionFoldedStatus objectForKey:[self sectionToString:section]] boolValue];
}

- (CGFloat)cellHeightInIndexPath:(NSIndexPath *)indexPath {
    return responseCellHeight ? [datasource tableView:self cellHeightInRow:indexPath.row InSection:indexPath.section] : cellHeight;
}

- (UIColor *)flagColorInIndexPath:(NSIndexPath *)indexPath {
    return responseFlagColorForRow ? [datasource tableView:self contentColorInRow:indexPath.row InSection:indexPath.section] : flagContentColor;
}

- (CGFloat)accessTopHeaderHeight {
    return responseTopHeaderHeight ? [datasource topHeaderHeightInTableView:self] : topHeaderHeight;
}

- (UIColor *)bgColorInSection:(NSUInteger)section InRow:(NSUInteger)row InColumn:(NSUInteger)column {
    return responseBgColorForColumn ? [datasource tableView:self bgColorInSection:section InRow:row InColumn:column] : [UIColor clearColor];
}

- (UIColor *)headerBgColorColumn:(NSUInteger)column {
    return responseHeaderBgColorForColumn ? [datasource tableView:self headerBgColorInColumn:column] : [UIColor clearColor];
}

- (void)accessDataSourceData {
    leftHeaderDataArray = [NSMutableArray array];
    contentDataArray = [NSMutableArray array];
    
    NSUInteger sections = [datasource numberOfSectionsInTableView:self];
    for (int i = 0; i < sections; i++) {
        [leftHeaderDataArray addObject:[datasource arrayDataForLeftHeaderInTableView:self InSection:i]];
        [contentDataArray addObject:[datasource arrayDataForContentInTableView:self InSection:i]];
    }
}

- (NSIndexPath *)accessUIViewVirtualTag:(UIView *)view {
    for (NSString *key in [columnTapViewDict allKeys]) {
        UIView *vi = [columnTapViewDict objectForKey:key];
        if (vi == view) {
            NSArray *sep = [key componentsSeparatedByString:@"_"];
            NSUInteger section = [[sep objectAtIndex:0] integerValue];
            NSUInteger row = [[sep objectAtIndex:1] integerValue];
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    return nil;
}

@end
