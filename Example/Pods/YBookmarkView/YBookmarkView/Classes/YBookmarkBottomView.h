//
//  YBookmarkBottomView.h
//  YBookmarkView
//
//  Created by yinbing on 2018/6/15.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YBookmarkBottomView;
@protocol YBookmarkBottomViewDelegate <NSObject>

- (__kindof UIViewController *)bookmarkBottomViewVCForIndex:(NSInteger)index;
- (__kindof UIViewController *)bookmarkBottomViewTopVC;
- (NSMutableArray *)bookmarkBottomViewDataArray;
- (void)bookmarkBottomViewCurrentIndex:(CGFloat)index;

//** bottomMark 将要显示vc*/
- (void)bookmarkBottom:(YBookmarkBottomView *)bookmarkBottom willDisplayingVC:(UIViewController *)vc index:(NSInteger)index;
//** bottomMark 结束显示vc*/
- (void)bookmarkBottom:(YBookmarkBottomView *)bookmarkBottom didEndDisplayingVC:(UIViewController *)vc index:(NSInteger)index;

@end

@interface YBookmarkBottomView : UIView

@property (nonatomic, weak) id <YBookmarkBottomViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView * contentGridView;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)reloadData;

- (void)scrollToIndex:(CGFloat)index;

@end
