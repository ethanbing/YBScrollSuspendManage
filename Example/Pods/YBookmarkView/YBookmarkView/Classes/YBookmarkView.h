//
//  YBookmarkView.h
//  YBookmarkView
//
//  Created by yinbing on 2018/6/14.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBookmarkContentCell.h"
#import "YBookmarkTopView.h"
#import "YBookmarkBottomView.h"

@class YBookmarkView;
@protocol YBookMarkViewDataSource <NSObject>

@required 

/**
 bookMarkView 数据来源

 @param bookMarkView bookMarkView
 @return 控制器数量
 */
- (NSInteger)numberOfItemInBookMarkView:(YBookmarkView *)bookMarkView;

/**
 top title 标签

 @param bookMarkView bookMarkView
 @param index 第几个标签
 @return title
 */
- (NSString *)bookMarkView:(YBookmarkView *)bookMarkView titleAtIndex:(NSInteger)index;

/**
 控制器  数据来源
 说明：每个控制器不会重复调用
 @param bookMarkView bookMarkView
 @param index 第几个标签
 @param viewRect 控制器的CGRect 大小
 @return 控制器
 */
- (UIViewController *)bookMarkView:(YBookmarkView *)bookMarkView viewAtIndex:(NSInteger)index viewRect:(CGRect)viewRect;

@optional
//可以自定义TitleCell 样式 默认不需要实现
- (void)bookMarkView:(YBookmarkView *)bookMarkView titleCell:(YBookmarkTitleCell *)cell index:(NSInteger)index;

/**
 父类控制器
 @return 基本是带有导航栏的控制器
 */
- (UIViewController *)bookMarkViewTopVC:(YBookmarkView *)bookMarkView;
///** *  右侧角标 */
//- (NSString *)bookMarkView:(YBookmarkView *)bookMarkView markAtIndex:(NSInteger)index;

@end

@protocol YBookMarkViewDelegate <NSObject>

@optional

- (void)bookMarkView:(YBookmarkView *)bookMarkView didSelectTitleAtIndex:(NSInteger)index;
- (void)bookMarkView:(YBookmarkView *)bookMarkView didScrollToIndex:(NSInteger)index;
//** bottomMark 滑动结束*/
- (void)bookMarkView:(YBookmarkView *)bookMarkView didEndDecelerating:(NSInteger)index;
- (void)bookMarkView:(YBookmarkView *)bookMarkView updateLayoutIndex:(NSInteger)index viewController:(UIViewController *)vc;
//** bottomMark 将要显示*/
- (void)bookMarkView:(YBookmarkView *)bookMarkView bottomMarkWillDisplayCell:(UICollectionViewCell *)cell atIndex:(NSInteger)index;
//** bottomMark 将要显示vc*/
- (void)bookMarkView:(YBookmarkView *)bookMarkView willDisplayingVC:(__kindof UIViewController *)vc index:(NSInteger)index;
//** bottomMark 结束显示vc*/
- (void)bookMarkView:(YBookmarkView *)bookMarkView didEndDisplayingVC:(__kindof UIViewController *)vc index:(NSInteger)index;

@end

@interface YBookmarkView : UIView

@property (nonatomic, weak) id<YBookMarkViewDataSource> dataSource;
@property (nonatomic, weak) id<YBookMarkViewDelegate> delegate;
@property (nonatomic, strong) YBookmarkTopView *topView;
@property (nonatomic, strong) YBookmarkBottomView * bottomView;
/** *  是否隐藏topView 默认NO */
@property (nonatomic, assign) BOOL topViewHide;
/** *  顶部Mark高度  默认50.0 */
@property (nonatomic, assign) CGFloat topMarkHeight;
@property (nonatomic, assign) CGFloat bottomMarkHeight;
/** *  顶部Mark背景色  默认白色 */
@property (nonatomic, strong) UIColor * topMarkBGColor;
/** *  最大标题宽度 */
@property (nonatomic, assign) CGFloat maxTitleWidth;
/** *  固定标题宽度 默认0 自动宽度*/
@property (nonatomic, assign) CGFloat fixedTitleWidth;
/** *  title 最小间距 (minimumLineSpacing,minimumInteritemSpacing)
 默认CGSizeMake(10, 10) */
@property (nonatomic) CGSize titleSpacingSize;
/** *  标题字体*/
@property (nonatomic, strong) UIFont * titleLabelFont;
/** *  顶部view内边距 默认UIEdgeInsetsMake(0, 0, 0, 0) */
@property (nonatomic) UIEdgeInsets topViewInset;
/** *  顶部Mark内边距 默认UIEdgeInsetsMake(0, 10, 0, 10) */
@property (nonatomic) UIEdgeInsets topMarkInset;
/** *  顶部Mark内边距 默认UIEdgeInsetsMake(0, 10, 0, 10) */
@property (nonatomic) UIEdgeInsets topMarkCellInset;
/** *  顶部的Mark滚动手势激活  默认 YES 激活 */
@property (nonatomic, assign) BOOL topMarkScrollEnabled;
/** *  下面的Mark滚动手势激活  默认 YES 激活 */
@property (nonatomic, assign) BOOL bottomMarkScrollEnabled;
/** *  topMar右侧view*/
@property (nonatomic, strong) UIView * topMarkRightView;
/** *  当前索引 */
@property (nonatomic, assign) NSInteger currentIndex;
/** *  标题颜色*/
@property (nonatomic, strong) UIColor * titleColor;
/** *  标题选中颜色*/
@property (nonatomic, strong) UIColor * titleSelectColor;
/** *  topView底部 滑块   topViewSidelineSize 宽度设置0  就是自动宽度*/
@property (nonatomic, assign) CGSize topViewSidelineSize;
@property (nonatomic, strong) UIColor * topViewSidelineColor;
/** *  topView底部分割线*/
@property (nonatomic, assign) CGFloat topViewLineHeight;
@property (nonatomic, strong) UIColor * topViewBottomLineColor;
@property (nonatomic, strong) UIFont * titleSelectFont;

/** 映射titleCell 就是继承YBookmarkTitleCell 的类名 */
@property (nonatomic, copy) NSString * actualTitleCell;
@property (nonatomic, strong) UIImage * topShadowImage;

/**
 *  赋完值后  必须刷新数据
 */
- (void)reloadData;

- (void)reloadLayout;

- (void)reloadTitles;

//- (void)reloadDataForIndex:(NSInteger)index;

- (void)setBookMarkViewIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

- (__kindof UIViewController *)viewControllerForIndex:(NSInteger)index;

- (__kindof UIViewController *)currentViewController;

- (NSString *)titleForIndex:(NSInteger)index;

- (__kindof UIViewController *)viewControllerForClass:(Class)clss;

- (NSArray *)bookMarkViewTitles;

- (NSArray *)bookMarkViewControllers;

- (void)dropTopViewShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;

@end
