//
//  YBookmarkBottomView.m
//  YBookmarkView
//
//  Created by yinbing on 2018/6/15.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import "YBookmarkBottomView.h"
#import "YBookmarkContentCell.h"

@interface YBookmarkBottomView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString * bookmarkBottomCellIdentifier;

@end

@implementation YBookmarkBottomView

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
    [self addSubview:self.contentGridView];
    [self.contentGridView registerClass:YBookmarkContentCell.class forCellWithReuseIdentifier:self.bookmarkBottomCellIdentifier];
}

- (NSString *)bookmarkBottomCellIdentifier
{
    if (!_bookmarkBottomCellIdentifier) {
        NSString * cellName = NSStringFromClass(YBookmarkContentCell.class);
        NSInteger time = [NSDate date].timeIntervalSince1970;
        _bookmarkBottomCellIdentifier = [NSString stringWithFormat:@"%@%d",cellName,(int)time];
    }
    return _bookmarkBottomCellIdentifier;
}

- (void)reloadData
{
    [self.contentGridView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBookmarkContentCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.bookmarkBottomCellIdentifier forIndexPath:indexPath];
    UIViewController * vc = [self.dataArray objectAtIndex:indexPath.item];
    if (![vc isKindOfClass:[UIViewController class]]) {
        vc = [self.delegate bookmarkBottomViewVCForIndex:indexPath.item];
        [self.dataArray replaceObjectAtIndex:indexPath.item withObject:vc];
    }
    cell.topVC = [self.delegate bookmarkBottomViewTopVC];
    [cell updateDataForVC:vc];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(YBookmarkContentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.dataArray objectAtIndex:indexPath.item];
//    [cell updateDataForVC:vc];
    [self.delegate bookmarkBottom:self willDisplayingVC:vc index:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController * vc = [self.dataArray objectAtIndex:indexPath.item];
    [self.delegate bookmarkBottom:self didEndDisplayingVC:vc index:indexPath.item];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
//    NSLog(@"bottom滚动----%f",index);
    [self delegateScrollCurrentIndex:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    self.currentIndex = index;
}

- (void)scrollToIndex:(CGFloat)index
{
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
    [self.contentGridView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)delegateScrollCurrentIndex:(CGFloat)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookmarkBottomViewCurrentIndex:)]) {
        [self.delegate bookmarkBottomViewCurrentIndex:index];
    }
}

- (UICollectionView *)contentGridView
{
    if (!_contentGridView) {
        UICollectionViewFlowLayout * flow = [[UICollectionViewFlowLayout alloc] init];
        flow.minimumLineSpacing = 0.0;
        flow.minimumInteritemSpacing = 0.0;
        flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _contentGridView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
        _contentGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentGridView.showsHorizontalScrollIndicator = NO;
        _contentGridView.pagingEnabled = YES;
        _contentGridView.scrollsToTop = NO;
        _contentGridView.directionalLockEnabled = YES;
        _contentGridView.contentMode = UIViewContentModeTop;
        _contentGridView.backgroundColor = [UIColor whiteColor];
        _contentGridView.delegate = self;
        _contentGridView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _contentGridView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _contentGridView;
}

- (NSMutableArray *)dataArray
{
    return [self.delegate bookmarkBottomViewDataArray];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
