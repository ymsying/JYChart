//
//  SYPTabController.m
//  报表和MJExtension
//
//  Created by 应明顺 on 2017/12/7.
//  Copyright © 2017年 应明顺. All rights reserved.
//

#import "SYPTabController.h"
#import "SYPTabButton.h"
#import "SYPConstantColor.h"
#import "SYPConstantSize.h"
#import "UIView+Extension.h"

#define kTabButtonWidth 80

@interface SYPTabController () {
    NSMutableArray *hierarchyNames;
    NSMutableArray <SYPTabButton *> *tabBtns;
}

@end

@implementation SYPTabController

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        hierarchyNames = [NSMutableArray array];
        tabBtns = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)hierarchyName {
    if (!hierarchyNames) {
        hierarchyNames = [NSMutableArray array];
    }
    return hierarchyNames;
}

// 添加一个选项卡就就一个按钮
- (void)addNewTabWithName:(NSString *)name {
    if (![hierarchyNames containsObject:name] && name) {
        [hierarchyNames addObject:name];
        
        // 刷新前一个按钮文字内容
        SYPTabButton *previousBtn = [tabBtns lastObject];
        [previousBtn setTitle:name forState:UIControlStateNormal];
        
        // 新建一个按钮，默认显示"请选择"
        SYPTabButton *tabBtn = [SYPTabButton buttonWithType:UIButtonTypeCustom];
        tabBtn.frame = CGRectMake(SYPDefaultMargin * hierarchyNames.count + kTabButtonWidth * (hierarchyNames.count - 1), 0, kTabButtonWidth, self.height);
        [tabBtn setTitleColor:SYPColor_LineColor_Blue forState:UIControlStateSelected];
        [tabBtn setTitleColor:SYPColor_TextColor_Minor forState:UIControlStateNormal];
        [tabBtn addTarget:self action:@selector(selecteTab:) forControlEvents:UIControlEventTouchUpInside];
        [tabBtn setTitle:@"请选择" forState:UIControlStateNormal];
        tabBtn.tag = hierarchyNames.count - 10000;
        [self addSubview:tabBtn];
        
        [tabBtns addObject:tabBtn];
        // 只有一个使用首次调用时的传入的文字内容
        if (tabBtns.count == 1) {
            [tabBtn setTitle:name forState:UIControlStateNormal];
        }
        
        [tabBtns enumerateObjectsUsingBlock:^(SYPTabButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.selected = NO;
        }];
        
        tabBtn.selected = YES;
    }
}



- (void)selecteTab:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"请选择"]) return;
    
    NSInteger tag = sender.tag + 10000 - 1;
    NSRange range = NSMakeRange(tag+1, hierarchyNames.count - 1 - tag);
    [hierarchyNames removeObjectsInRange:range];
    range = NSMakeRange(tag + 1, tabBtns.count - 1 - tag);
    [[tabBtns subarrayWithRange:range] enumerateObjectsUsingBlock:^(SYPTabButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [tabBtns removeObjectsInRange:range];
    sender.selected = YES;
    [sender setTitle:hierarchyNames[0] forState:UIControlStateNormal];
    
    if (self.delegate && [(id)self.delegate respondsToSelector:@selector(tabController:selecteTabWithHierarchyName:hierarchyIndex:)]) {
        NSAssert(tag < hierarchyNames.count, @"层级越界");
        [self.delegate tabController:self selecteTabWithHierarchyName:hierarchyNames[tag] hierarchyIndex:tag];
    }
    
    
    NSMutableArray *tabBtnTitles = [NSMutableArray array];
    [tabBtns enumerateObjectsUsingBlock:^(SYPTabButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tabBtnTitles addObject:obj.currentTitle];
    }];
    
}





@end
