//
//  YBScrollRankManage.h
//  Cbox
//
//  Created by yinbing on 2018/1/17.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YBScrollSuspendManageDelegate <NSObject>

@required
/** 是否激活悬浮 */
- (BOOL)enableSuspendForSubScroll:(UIScrollView *)subScrollView;

@optional
/** 主scrollView是否可以滚动  滚动到头就是YES 否则就是NO  */
- (BOOL)mainScrollIsTopForScrollView:(UIScrollView *)scrollView;

@end

@interface YBScrollSuspendManage : NSObject

@property (nonatomic, weak) id <YBScrollSuspendManageDelegate> delegate;


/**
 主控制器的scroll代理 ScrollViewDidScroll 里调用, 必须调用

 @param scrollView 主scrollView
 @param subScrollView 子ScrollView
 @param maxY 悬浮位置顶部的大小
 */
- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView subScrollView:(UIScrollView *)subScrollView forHeaderMaxY:(CGFloat)maxY;

/**
 子控制器的scroll代理 ScrollViewDidScroll 里调用  必须调用

 @param scrollView 子scrollView
 */
- (void)subScrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface UIViewController (YBScrollSuspendManage)

@property (nonatomic, strong) YBScrollSuspendManage * yb_suspendManage;

@end

@interface UIScrollView (YBScrollSuspendManage)

/**
 激活多手势
 */
@property (nonatomic, assign) BOOL yb_enableGestureScroll;
/**
 是否可以滚动属性
 */
@property (nonatomic,assign) BOOL yb_isCanScroll;

@end
