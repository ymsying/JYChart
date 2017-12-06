//
//  SYPFreezeWindowView.h
//  SYPFreezeWindowView
//
//  Created by niko on 17/5/3.
//  Copyright © 2015年 YMS All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYPMainViewCell.h"
#import "SYPSectionViewCell.h"
#import "SYPRowViewCell.h"
#import "SYPSignView.h"

@protocol SYPFreezeWindowViewDataSource;
@protocol SYPFreezeWindowViewDelegate;

typedef NS_ENUM(NSInteger, SYPFreezeWindowViewStyle) {
    SYPFreezeWindowViewStyleDefault,
    SYPFreezeWindowViewStyleRowOnLine      //the row section view on line
};

typedef NS_ENUM(NSInteger, SYPFreezeWindowViewBounceStyle) {
    SYPFreezeWindowViewBounceStyleNone,
    SYPFreezeWindowViewBounceStyleMain,
    SYPFreezeWindowViewBounceStyleAll
};

/**
 模仿Excel效果，可以冻结左侧第一列
 */
@interface SYPFreezeWindowView : UIView

- (instancetype)initWithFrame:(CGRect)frame FreezePoint: (CGPoint) freezePoint cellViewSize: (CGSize) cellViewSize;

- (void)setSignViewWithContent:(NSString *)content;

- (SYPMainViewCell *)dequeueReusableMainCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (SYPSectionViewCell *)dequeueReusableSectionCellWithIdentifier:(NSString *)identifier forSection:(NSInteger)section;
- (SYPRowViewCell *)dequeueReusableRowCellWithIdentifier:(NSString *)identifier forRow:(NSInteger)row;

- (void)setSignViewBackgroundColor:(UIColor *)color;
- (void)setMainViewBackgroundColor:(UIColor *)color;
- (void)setSectionViewBackgroundColor:(UIColor *)color;
- (void)setRowViewBackgroundColor:(UIColor *)color;

- (void)reloadData;

- (UIScrollView *)mainView;
- (UIScrollView *)sectionView;
- (UIScrollView *)rowView;
- (SYPSignView *) signView;

@property (weak, nonatomic) id<SYPFreezeWindowViewDataSource> dataSource;
@property (weak, nonatomic) id<SYPFreezeWindowViewDelegate> delegate;
@property (assign, nonatomic) SYPFreezeWindowViewStyle style;
@property (assign, nonatomic) SYPFreezeWindowViewBounceStyle bounceStyle;
@property (nonatomic, getter=isTapToTop) BOOL tapToTop;
@property (nonatomic, getter=isTapToLeft) BOOL tapToLeft;
@property (nonatomic) BOOL showsHorizontalScrollIndicator;
@property (nonatomic) BOOL showsVerticalScrollIndicator;
@property (strong, nonatomic) NSIndexPath *keyIndexPath;
@property (nonatomic) BOOL autoHorizontalAligning;
@property (nonatomic) BOOL autoVerticalAligning;
@property (nonatomic, assign) BOOL flexibleHeight;

@end

@protocol SYPFreezeWindowViewDataSource <NSObject>

@required

- (SYPMainViewCell *)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (SYPSectionViewCell *)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView cellAtSection:(NSInteger)section;

- (SYPRowViewCell *)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView cellAtRow:(NSInteger)row;

- (NSInteger)numberOfSectionsInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView;

- (NSInteger)numberOfRowsInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView;

@optional

// - (SYPSignView *)signViewInFreezeWindowView:(SYPFreezeWindowView *)freezeWindowView;

@end

@protocol SYPFreezeWindowViewDelegate <NSObject>

@optional
// Called after the user changes the selection.
- (void)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView didSelectMainZoneIndexPath:(NSIndexPath *)indexPath;
// 首列纵向点击
- (void)freezeWindowView:(SYPFreezeWindowView *)freezeWindowView didSelectRowZoneIndexPath:(NSIndexPath *)indexPath;

// Called when you set the key indexPath.
- (SYPSectionViewCell *)sectionCellPointInfreezeWindowView:(SYPFreezeWindowView *)freezeWindowView;
// Called after the cell in a key indexPath.
- (void)sectionCellReachKey:(SYPSectionViewCell *)sectionViewCell withSection:(NSInteger)section;
@end
