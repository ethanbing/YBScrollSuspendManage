//
//  YBookmarkTopView.m
//  YBookmarkView
//
//  Created by yinbing on 2018/6/14.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import "YBookmarkTopView.h"
#import "YBookmarkContentCell.h"
#import "YBookmarkView.h"

@interface YBookmarkTopView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIView * splitLine;

/// 开始颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat startR;
@property (nonatomic, assign) CGFloat startG;
@property (nonatomic, assign) CGFloat startB;
/// 完成颜色, 取值范围 0~1
@property (nonatomic, assign) CGFloat endR;
@property (nonatomic, assign) CGFloat endG;
@property (nonatomic, assign) CGFloat endB;

@end


@implementation YBookmarkTopView

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
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomLine];
    [self addSubview:self.titleGridView];
    [self.titleGridView registerClass:YBookmarkTitleCell.class forCellWithReuseIdentifier:NSStringFromClass(YBookmarkTitleCell.class)];
    [self addSplitLine];
}

- (void)setTopMarkRightView:(UIView *)topMarkRightView
{
    _topMarkRightView = topMarkRightView;
    _topMarkRightView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    CGRect rect = self.frame;
//    CGFloat y = (CGRectGetHeight(rect)-CGRectGetHeight(_topMarkRightView.frame))/2.0;
    _topMarkRightView.frame = CGRectMake(CGRectGetMaxX(rect)-CGRectGetWidth(_topMarkRightView.frame), 0, CGRectGetWidth(_topMarkRightView.frame), CGRectGetHeight(_topMarkRightView.frame)-_topViewLineHeight);
    [self addSubview:_topMarkRightView];
//    self.topViewInset = UIEdgeInsetsMake(0, 0, 0, self.topViewInset.right);
}

- (void)setTopViewBottomLineColor:(UIColor *)topViewBottomLineColor
{
    _topViewBottomLineColor = topViewBottomLineColor;
    _bottomLine.backgroundColor = topViewBottomLineColor;
}

- (void)setTopViewSidelineSize:(CGSize)topViewSidelineSize
{
    _topViewSidelineSize = topViewSidelineSize;
    _splitLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-topViewSidelineSize.height, topViewSidelineSize.width, topViewSidelineSize.height);
}

- (void)setTopViewSidelineColor:(UIColor *)topViewSidelineColor
{
    _topViewSidelineColor = topViewSidelineColor;
    _splitLine.backgroundColor = topViewSidelineColor;
}

- (void)setTopViewInset:(UIEdgeInsets)topViewInset
{
    _topViewInset = topViewInset;
    self.titleGridView.frame = UIEdgeInsetsInsetRect(self.bounds, topViewInset);
}

- (void)setTopViewLineHeight:(CGFloat)topViewLineHeight
{
    _topViewLineHeight = topViewLineHeight;
    self.bottomLine.frame = CGRectMake(0, CGRectGetHeight(self.frame)-topViewLineHeight, CGRectGetWidth(self.bounds), topViewLineHeight);
//    self.topViewSidelineSize = _topViewSidelineSize;
}

- (void)addSplitLine
{
    [self.titleGridView addSubview:self.splitLine];
}

- (void)setTopMarkInset:(UIEdgeInsets)topMarkInset
{
    _topMarkInset = topMarkInset;
    self.titleGridView.contentInset = topMarkInset;
}

- (void)setActualTitleCell:(NSString *)actualTitleCell
{
    _actualTitleCell = actualTitleCell;
    if (actualTitleCell.length) {
        [self.titleGridView registerClass:NSClassFromString(actualTitleCell) forCellWithReuseIdentifier:NSStringFromClass(YBookmarkTitleCell.class)];
    }
}

- (void)reloadData
{
    [self.titleGridView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self configCurrentIndex:self.currentIndex];
        [self splitLineToIndex:self.currentIndex];
    });
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView * v in self.subviews) {
        if ([v isKindOfClass:[UICollectionView class]]) {
            v.backgroundColor = [UIColor clearColor];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * title = [self.dataArray objectAtIndex:indexPath.item];
    CGFloat sw = [self _widthWithString:title font:self.titleSelectFont];
    CGFloat w = [self.delegate bookmarkTopView:self title:title width:sw];
    return CGSizeMake(w, CGRectGetHeight(self.bounds));
}

- (CGFloat)_widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.bounds)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBookmarkTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YBookmarkTitleCell.class) forIndexPath:indexPath];
    NSString * title = [self.dataArray objectAtIndex:indexPath.item];
    cell.titleLabelFont = self.titleLabelFont;
    cell.titleSelectFont = self.titleSelectFont;
    cell.titleLabel.text = title;
    cell.titleColor = self.titleColor;
    cell.titleSelectColor = self.titleSelectColor;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookmarkTopView:titleCell:index:)]) {
        [self.delegate bookmarkTopView:self titleCell:cell index:indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self scrollToIndex:indexPath.item];
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookmarkTopViewCurrentIndex:)]) {
        [self.delegate bookmarkTopViewCurrentIndex:indexPath.item];
    }
}

- (void)scrollToIndex:(CGFloat)index
{
//    NSInteger i = floorf(index);
    NSInteger i = roundf(index);
    self.currentIndex = i;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex == currentIndex) {
        return;
    }
    _currentIndex = currentIndex;
    [self configCurrentIndex:currentIndex];
    
}

- (void)configCurrentIndex:(NSInteger)index
{
    if (index >= self.dataArray.count || index <0) {
        return;
    }
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        [weakSelf.titleGridView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    } completion:^(BOOL finished) {
        [weakSelf.titleGridView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [weakSelf splitLineToIndex:indexPath.item];
    }];
    
//    [self.titleGridView performBatchUpdates:^{
//        [self.titleGridView reloadItemsAtIndexPaths:@[indexPath]];
//    } completion:^(BOOL finished) {
//        [self.titleGridView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//        [self splitLineToIndex:indexPath.item];
//    }];
}

- (void)splitLineToIndex:(CGFloat)index
{
    NSInteger toIndex = _currentIndex;
    if (index > _currentIndex) {
        toIndex = _currentIndex + 1;
    }else if(index < _currentIndex){
        toIndex = _currentIndex - 1;
    }
    if (toIndex < 0 || toIndex >= self.dataArray.count) {
        return;
    }
    UICollectionViewCell * cell = [self.titleGridView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]];
    CGPoint p = self.splitLine.center;
    if (self.topViewSidelineSize.width == 0) {
        CGRect rect = self.splitLine.frame;
        CGFloat cellW = CGRectGetWidth(cell.bounds);
        CGFloat w = cellW - self.titleSpacingSize.width*2;
        rect.size.width = w;
        self.splitLine.frame = rect;
    }else if ([cell isKindOfClass:[YBookmarkTitleCell class]]) {
        CGRect rect = self.splitLine.frame;
        YBookmarkTitleCell * tempCell = (YBookmarkTitleCell*)cell;
        rect.size.width = [self currentWidthWithFont:tempCell.titleSelectFont text:tempCell.titleLabel.text];
        self.splitLine.frame = rect;
    }
//    [UIView animateWithDuration:0.1 animations:^{
        self.splitLine.center = CGPointMake(CGRectGetMidX(cell.frame), p.y);
//    }];
}

- (void)setShadowImage:(UIImage *)shadowImage
{
    self.clipsToBounds = NO;
}

- (void)dropShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.clipsToBounds = NO;
}

- (CGFloat)currentWidthWithFont:(UIFont *)font text:(NSString*)text
{
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, font.pointSize) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size.width + 20;
}
#pragma mark - - - 颜色渐变方法抽取
//- (void)_isTitleGradientEffectWithProgress:(CGFloat)progress originalBtn:(UIButton *)originalBtn targetBtn:(UIButton *)targetBtn {
//    // 获取 targetProgress
//    CGFloat targetProgress = progress;
//    // 获取 originalProgress
//    CGFloat originalProgress = 1 - targetProgress;
//
//    CGFloat r = self.endR - self.startR;
//    CGFloat g = self.endG - self.startG;
//    CGFloat b = self.endB - self.startB;
//    UIColor *originalColor = [UIColor colorWithRed:self.startR +  r * originalProgress  green:self.startG +  g * originalProgress  blue:self.startB +  b * originalProgress alpha:1];
//    UIColor *targetColor = [UIColor colorWithRed:self.startR + r * targetProgress green:self.startG + g * targetProgress blue:self.startB + b * targetProgress alpha:1];
//
//    // 设置文字颜色渐变
//    originalBtn.titleLabel.textColor = originalColor;
//    targetBtn.titleLabel.textColor = targetColor;
//}

- (UICollectionView *)titleGridView
{
    if (!_titleGridView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0.0;
        flow.minimumInteritemSpacing = 0.0;
//        flow.estimatedItemSize = CGSizeMake(100, 40);
//        flow.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleGridView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
        _titleGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _titleGridView.showsHorizontalScrollIndicator = NO;
        _titleGridView.pagingEnabled = NO;
        _titleGridView.scrollsToTop = NO;
        _titleGridView.contentMode = UIViewContentModeTop;
        _titleGridView.backgroundColor = [UIColor clearColor];
        _titleGridView.delegate = self;
        _titleGridView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _titleGridView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        //        [_contentGridView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew context:nil];
    }
    return _titleGridView;
}

-(UIView *)splitLine
{
    if (!_splitLine){
        _splitLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-2, 50, 2)];
        _splitLine.backgroundColor = [UIColor redColor];
        _splitLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
    return _splitLine;
}

-(UIView *)bottomLine
{
    if (!_bottomLine){
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-0.5, CGRectGetWidth(self.bounds), 0.5)];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLine;
}

- (NSMutableArray *)dataArray
{
    return [self.delegate bookmarkTopViewDataArray];
}

#pragma mark - - - 颜色设置的计算
/// 开始颜色设置
- (void)setupStartColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.startR = components[0];
    self.startG = components[1];
    self.startB = components[2];
}
/// 结束颜色设置
- (void)setupEndColor:(UIColor *)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    self.endR = components[0];
    self.endG = components[1];
    self.endB = components[2];
}

/**
 *  指定颜色，获取颜色的RGB值
 *
 *  @param components RGB数组
 *  @param color      颜色
 */
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, 1);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component] / 255.0f;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
