//
//  YBookmarkTopView.h
//  YBookmarkView
//
//  Created by yinbing on 2018/6/14.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBookmarkContentCell.h"

@class YBookmarkTopView;
@protocol YBookmarkTopViewDelegate <NSObject>

- (NSMutableArray *)bookmarkTopViewDataArray;
- (CGFloat)bookmarkTopView:(YBookmarkTopView *)bookmarkTopView title:(NSString *)title width:(CGFloat)width;
@optional
- (void)bookmarkTopViewCurrentIndex:(CGFloat)index;
- (void)bookmarkTopView:(YBookmarkTopView *)bookmarkTopView titleCell:(YBookmarkTitleCell *)cell index:(NSInteger)index;

@end

@interface YBookmarkTopView : UIView

@property (nonatomic, weak) id <YBookmarkTopViewDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIView * bottomLine;
@property (nonatomic, strong) UICollectionView * titleGridView;

//默认CGSizeMake(10, 10) */
@property (nonatomic) CGSize titleSpacingSize;
/** *  标题字体*/
@property (nonatomic, strong) UIFont * titleLabelFont;
/** *  顶部view内边距 默认UIEdgeInsetsMake(0, 0, 0, 0) */
@property (nonatomic) UIEdgeInsets topViewInset;
/** *  顶部Mark内边距 默认UIEdgeInsetsMake(0, 10, 0, 10) */
@property (nonatomic) UIEdgeInsets topMarkInset;
/** *  顶部Mark内边距 默认UIEdgeInsetsMake(0, 10, 0, 10) */
@property (nonatomic) UIEdgeInsets topMarkCellInset;
/** *  topMar右侧view*/
@property (nonatomic, strong) UIView * topMarkRightView;
/** *  标题颜色*/
@property (nonatomic, strong) UIColor * titleColor;
/** *  标题选中颜色*/
@property (nonatomic, strong) UIColor * titleSelectColor;
/** *  topView底部 滑块*/
@property (nonatomic, assign) CGSize topViewSidelineSize;
@property (nonatomic, strong) UIColor * topViewSidelineColor;
/** *  topView底部分割线*/
@property (nonatomic, assign) CGFloat topViewLineHeight;
@property (nonatomic, strong) UIColor * topViewBottomLineColor;
@property (nonatomic, strong) UIFont * titleSelectFont;
/** 映射titleCell */
@property (nonatomic, copy) NSString * actualTitleCell;
@property (nonatomic, strong) UIImage * shadowImage;

- (void)reloadData;

- (void)scrollToIndex:(CGFloat)index;

- (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;

@end
