//
//  YBookmarkView.m
//  YBookmarkView
//
//  Created by yinbing on 2018/6/14.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import "YBookmarkView.h"
#import "YBookmarkTopView.h"
#import "YBookmarkBottomView.h"

@interface YBookmarkView()<YBookmarkTopViewDelegate,YBookmarkBottomViewDelegate>

@property (nonatomic, strong) NSMutableArray * contentArray;
@property (nonatomic, strong) NSMutableArray * titleArray;
@property (nonatomic, strong) UIView * lineView;
@property (nonatomic, weak) UIViewController *topVC;

@end


@implementation YBookmarkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent
{
    [self defaultConfig];
    [self addSubview:self.bottomView];
    [self addSubview:self.topView];
}

- (void)defaultConfig
{
    _topMarkHeight = 50;
    _topViewHide = NO;
    _bottomMarkHeight = 0.0;
    _fixedTitleWidth = 0;
    _maxTitleWidth = 0;
    _topViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _titleLabelFont = [UIFont systemFontOfSize:15.0];
    _topMarkInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _topMarkCellInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _titleSpacingSize = CGSizeMake(10, 10);
    _titleColor = [UIColor blackColor];
    _titleSelectColor = [UIColor redColor];
//    CGFloat minL = (1.0/[UIScreen mainScreen].scale);
    _topViewSidelineSize = CGSizeMake(0, 1);
    _topViewBottomLineColor = [UIColor lightGrayColor];
    _topViewLineHeight = 0.5;
    _topMarkBGColor = [UIColor whiteColor];
    _topMarkScrollEnabled = YES;
    _bottomMarkScrollEnabled = YES;
    _topViewSidelineColor = [UIColor redColor];
    _titleSelectFont = _titleLabelFont;
}

- (void)setTopMarkScrollEnabled:(BOOL)topMarkScrollEnabled
{
    _topMarkScrollEnabled = topMarkScrollEnabled;
    _topView.titleGridView.scrollEnabled = topMarkScrollEnabled;
}

- (void)setBottomMarkScrollEnabled:(BOOL)bottomMarkScrollEnabled
{
    _bottomMarkScrollEnabled = bottomMarkScrollEnabled;
    _bottomView.contentGridView.scrollEnabled = bottomMarkScrollEnabled;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleSelectFont = titleLabelFont;
}

- (void)reloadData
{
    [self reloadDataHandle];
}

- (void)reloadDataHandle
{
    [self configUI];
    [self.titleArray removeAllObjects];
    [self.contentArray removeAllObjects];
    NSInteger num = [self dataSourceNumberItems];
    for (int i=0; i<num; i++) {
        [self.titleArray addObject:[self dataSourceTitleForIndex:i]];
        [self.contentArray addObject:@""];
    }
    [self reloadLayout];
}

- (void)configUI
{
    CGFloat y = 0;
    CGFloat h = self.topMarkHeight;
    CGRect rect = CGRectMake(0, y, CGRectGetWidth(self.bounds), h);
    self.topView.frame = rect;
    [self configTopView];
    if (!self.topViewHide) {
        y = h;
    }
    rect = CGRectMake(0, y, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-y);
    self.bottomView.frame = rect;
}

- (void)reloadTitles
{
    [self.titleArray removeAllObjects];
    NSInteger num = [self dataSourceNumberItems];
    for (int i=0; i<num; i++) {
        [self.titleArray addObject:[self dataSourceTitleForIndex:i]];
    }
    [self.topView reloadData];
}

- (void)configTopView
{
    self.topView.titleGridView.backgroundColor = self.topMarkBGColor;
    self.topView.titleColor = self.titleColor;
    self.topView.titleSpacingSize = self.titleSpacingSize;
    self.topView.topViewInset = self.topViewInset;
    self.topView.topMarkInset = self.topMarkInset;
    self.topView.topMarkCellInset = self.topMarkCellInset;
    self.topView.titleSelectColor = self.titleSelectColor;
    self.topView.topViewSidelineSize = self.topViewSidelineSize;
    self.topView.topViewLineHeight = self.topViewLineHeight;
    self.topView.topViewBottomLineColor = self.topViewBottomLineColor;
    self.topView.topViewSidelineColor = self.topViewSidelineColor;
    self.topView.titleSelectFont = self.titleSelectFont;
    self.topView.topMarkRightView = self.topMarkRightView;
    self.topView.titleLabelFont = self.titleLabelFont;
    self.topView.actualTitleCell = self.actualTitleCell;
}

- (void)reloadLayout
{
    [self.topView reloadData];
    [self.bottomView reloadData];
    [self bookmarkViewWillScrollToIndex:_currentIndex];
}

- (void)reloadDataForIndex:(NSInteger)index
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (NSString *)dataSourceTitleForIndex:(NSInteger)index
{
    return [self.dataSource bookMarkView:self titleAtIndex:index];
}

- (NSInteger)dataSourceNumberItems
{
    return [self.dataSource numberOfItemInBookMarkView:self];
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index
{
    if (!self.contentArray.count) {
        return nil;
    }
    UIViewController * vc = [self.contentArray objectAtIndex:index];
    if (![vc isKindOfClass:[UIViewController class]]) {
        vc = nil;
    }
    return vc;
}

- (UIViewController *)currentViewController
{
    if (!self.contentArray.count) {
        return nil;
    }
    UIViewController * vc = [self.contentArray objectAtIndex:self.currentIndex];
    if (![vc isKindOfClass:[UIViewController class]]) {
        vc = nil;
    }
    return vc;
}

- (UIViewController *)viewControllerForClass:(Class)clss
{
    if (!self.contentArray.count) {
        return nil;
    }
    for (UIViewController * vc in self.contentArray) {
        if ([vc isKindOfClass:clss]) {
            return vc;
        }
    }
    return nil;
}

- (NSString *)titleForIndex:(NSInteger)index
{
    if (!self.titleArray.count) {
        return nil;
    }
    NSString * title = [self.titleArray objectAtIndex:index];
    return title;
}

#pragma mark - YBookmarkTopViewDelegate 代理

- (NSMutableArray *)bookmarkTopViewDataArray
{
    return self.titleArray;
}

- (CGFloat)bookmarkTopView:(YBookmarkTopView *)bookmarkTopView title:(NSString *)title width:(CGFloat)width
{
    if (self.fixedTitleWidth) {
        return self.fixedTitleWidth;
    }
    CGFloat w = width + self.topMarkCellInset.left + self.topMarkCellInset.right;
    if (self.maxTitleWidth) {
        return w > self.maxTitleWidth ? self.maxTitleWidth : w;
    }
    return w;
}

- (void)bookmarkTopViewCurrentIndex:(CGFloat)index
{
    [self.bottomView scrollToIndex:index];
    NSInteger i = roundf(index);
    self.currentIndex = i;
}

- (void)bookmarkTopView:(YBookmarkTopView *)bookmarkTopView titleCell:(YBookmarkTitleCell *)cell index:(NSInteger)index
{
    if (self.delegate && [self.dataSource respondsToSelector:@selector(bookMarkView:titleCell:index:)]) {
        [self.dataSource bookMarkView:self titleCell:cell index:index];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    [self bookmarkViewWillScrollToIndex:currentIndex];
}

#pragma mark - YBookmarkBottomViewDelegate 代理

- (NSMutableArray *)bookmarkBottomViewDataArray
{
    return self.contentArray;
}

- (__kindof UIViewController *)bookmarkBottomViewTopVC
{
    return self.topVC;
}

- (__kindof UIViewController *)bookmarkBottomViewVCForIndex:(NSInteger)index
{
    UIViewController * vc = [self.contentArray objectAtIndex:index];
    if (![vc isKindOfClass:[UIViewController class]]) {
        vc = [self.dataSource bookMarkView:self viewAtIndex:index viewRect:self.bottomView.bounds];
        [self.contentArray replaceObjectAtIndex:index withObject:vc];
    }
    return vc;
}

- (void)bookmarkBottom:(YBookmarkBottomView *)bookmarkBottom willDisplayingVC:(UIViewController *)vc index:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookMarkView:willDisplayingVC:index:)]) {
        [self.delegate bookMarkView:self willDisplayingVC:vc index:index];
    }
}

- (void)bookmarkBottom:(YBookmarkBottomView *)bookmarkBottom didEndDisplayingVC:(UIViewController *)vc index:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookMarkView:didEndDisplayingVC:index:)]) {
        [self.delegate bookMarkView:self didEndDisplayingVC:vc index:index];
    }
}

- (void)bookmarkBottomViewCurrentIndex:(CGFloat)index
{
    [self.topView scrollToIndex:index];
    NSInteger i = floorf(index);
    self.currentIndex = i;
}

- (void)bookmarkViewWillScrollToIndex:(CGFloat)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookMarkView:didScrollToIndex:)]) {
        [self.delegate bookMarkView:self didScrollToIndex:index];
    }
}

- (void)setBookMarkViewIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated
{
    [self bookmarkBottomViewCurrentIndex:indexPath.item];
    [self.bottomView scrollToIndex:indexPath.item];
}

- (NSArray *)bookMarkViewTitles
{
    return self.titleArray;
}

- (NSArray *)bookMarkViewControllers
{
    return self.contentArray;
}

- (void)dropTopViewShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity
{
    [self.topView dropShadowWithOffset:offset radius:radius color:color opacity:opacity];
}

- (void)setTopShadowImage:(UIImage *)topShadowImage
{
    self.topView.shadowImage = topShadowImage;
}

#pragma mark -

- (YBookmarkTopView *)topView
{
    if (!_topView) {
        _topView = [[YBookmarkTopView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), self.topMarkHeight)];
        _topView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _topView.delegate = self;

    }
    return _topView;
}

- (YBookmarkBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[YBookmarkBottomView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)-self.topMarkHeight)];
        _bottomView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _bottomView.delegate = self;
        
    }
    return _bottomView;
}

- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray array];
    }
    return _contentArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (UIViewController *)topVC
{
    if (!_topVC) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(bookMarkViewTopVC:)]) {
            _topVC = [self.dataSource bookMarkViewTopVC:self];
        }else{
            _topVC = self.topViewController;
        }
    }
    return _topVC;
}

- (UIViewController *)topViewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    } while (next);
    
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
