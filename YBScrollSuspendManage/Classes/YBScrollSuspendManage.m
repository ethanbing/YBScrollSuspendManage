//
//  YBScrollRankManage.m
//  Cbox
//
//  Created by yinbing on 2018/1/17.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import "YBScrollSuspendManage.h"

@interface YBScrollSuspendManage ()<UIScrollViewDelegate>


@end

@implementation YBScrollSuspendManage

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView subScrollView:(UIScrollView *)subScrollView forHeaderMaxY:(CGFloat)maxY
{
    [self subHandleIsCanScrollView:subScrollView];
    if (!subScrollView.yb_isCanScroll) {
        //如父视图自己不能滚动,那么就固定在固定位置  悬浮
        [scrollView setContentOffset:CGPointMake(0, maxY)];
    }
}

- (void)subScrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        //子视图的滚动已经到头了;父视图即将开始滚动
        if (![self.delegate respondsToSelector:@selector(mainScrollIsTopForScrollView:)]) {
            NSLog(@"您必须在主控制器现实此代理方法 mainScrollIsTopForScrollView:");
            return;
        }
        scrollView.yb_isCanScroll = YES;
        BOOL outCanScroll = [self.delegate mainScrollIsTopForScrollView:scrollView];
        if (outCanScroll) {
            [scrollView setContentOffset:CGPointZero];
        }
    }else{
        [self subHandleIsCanScrollView:scrollView];
    }
}

- (void)subHandleIsCanScrollView:(UIScrollView *)subScrollView
{
    if (![self.delegate respondsToSelector:@selector(enableSuspendForSubScroll:)]) {
        NSLog(@"您必须在主控制器现实此代理方法 enableSuspendForSubScroll:");
        return;
    }
    BOOL isSuspend = [self.delegate enableSuspendForSubScroll:subScrollView];
    BOOL canScroll = subScrollView.yb_isCanScroll;
    if (canScroll && !isSuspend) {
        [subScrollView setContentOffset:CGPointZero];
    }else{
        //父视图到头:那么设置父视图不再滚动
        subScrollView.yb_isCanScroll = NO;
    }
}

@end

#import <objc/runtime.h>

@implementation UIViewController (YBScrollSuspendManage)
@dynamic yb_suspendManage;

- (void)setYb_suspendManage:(YBScrollSuspendManage *)yb_suspendManage
{
    objc_setAssociatedObject(self, @selector(yb_suspendManage), yb_suspendManage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YBScrollSuspendManage *)yb_suspendManage
{
    YBScrollSuspendManage * objc = objc_getAssociatedObject(self, @selector(yb_suspendManage));
    return objc;
}

@end

@implementation UIScrollView (YBScrollSuspendManage)
@dynamic yb_enableGestureScroll,yb_isCanScroll;

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.yb_enableGestureScroll;
}

- (void)setYb_enableGestureScroll:(BOOL)yb_enableGestureScroll
{
    objc_setAssociatedObject(self, @selector(yb_enableGestureScroll), @(yb_enableGestureScroll), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.yb_isCanScroll = YES;
}

- (BOOL)yb_enableGestureScroll
{
    NSNumber * objc = objc_getAssociatedObject(self, @selector(yb_enableGestureScroll));
    return [objc boolValue];
}

- (void)setYb_isCanScroll:(BOOL)yb_isCanScroll
{
    objc_setAssociatedObject(self, @selector(yb_isCanScroll), [NSNumber numberWithBool:yb_isCanScroll], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yb_isCanScroll
{
    NSNumber * objc = objc_getAssociatedObject(self, @selector(yb_isCanScroll));
    return [objc boolValue];
}

@end
