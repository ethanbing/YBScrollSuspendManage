//
//  YBViewController.m
//  YBScrollSuspendManage
//
//  Created by 380711712@qq.com on 11/24/2018.
//  Copyright (c) 2018 380711712@qq.com. All rights reserved.
//

#import "YBViewController.h"
#import "YBookmarkView.h"
#import "YBFirstViewController.h"
#import "YBSecondViewController.h"
#import "YBThirdViewController.h"
#import "YBMoreViewController.h"
#import "YBGridViewController.h"

@interface YBViewController ()<UIScrollViewDelegate,YBookMarkViewDataSource,YBookMarkViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIImageView * headerView;
@property (nonatomic, strong) YBookmarkView * bookmarkView;

@end

@implementation YBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"YBScrollSuspendManage Demo";
    
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.headerView];
    [self.mainScrollView addSubview:self.bookmarkView];
    
    self.mainScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), CGRectGetMaxY(self.bookmarkView.frame));
    
    [self.bookmarkView reloadData];
}

- (NSInteger)numberOfItemInBookMarkView:(YBookmarkView *)bookMarkView
{
    return 15;
}

- (NSString *)bookMarkView:(YBookmarkView *)bookMarkView titleAtIndex:(NSInteger)index
{
    return [NSString stringWithFormat:@"标签%d",(int)index+1];
}

- (UIViewController *)bookMarkView:(YBookmarkView *)bookMarkView viewAtIndex:(NSInteger)index viewRect:(CGRect)viewRect
{
    switch (index % 3) {
        case 1:
        {
            YBGridViewController * gridVC = [YBGridViewController new];
            gridVC.index = index+1;
            gridVC.yb_suspendManage = self.suspendManage;
            return gridVC;
        }
            break;
        case 2:
        {
            YBMoreViewController * moreVC = [YBMoreViewController new];
            moreVC.index = index+1;
            return moreVC;
        }
            break;
            
        default:{
            YBFirstViewController * vc = [YBFirstViewController new];
            vc.index = index+1;
            vc.yb_suspendManage = self.suspendManage;
            return vc;
        }
            break;
    }
    return [UIViewController new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    YBBaseTabelViewController * tabelViewController = [self.bookmarkView currentViewController];
    if ([tabelViewController isKindOfClass:YBBaseTabelViewController.class]) {
        //需要悬浮滚动的控制器
        [self.suspendManage mainScrollViewDidScroll:scrollView subScrollView:tabelViewController.tableView forHeaderMaxY:200];
    }else if ([tabelViewController isKindOfClass:YBBaseCollectionController.class]){
        YBBaseCollectionController * collectionVC = [self.bookmarkView currentViewController];;
        [self.suspendManage mainScrollViewDidScroll:scrollView subScrollView:collectionVC.collectionView forHeaderMaxY:200];
    }
}

#pragma mark - YBScrollSuspendManageDelegate

- (BOOL)enableSuspendForSubScroll:(UIScrollView *)subScrollView
{
    CGRect rect = [self.bookmarkView convertRect:self.bookmarkView.bounds toView:self.view];
    if (rect.origin.y <= 0) {
        //需要悬浮
        return YES;
    }
    return NO;
}

//子控制器需要下拉刷新 需要实现此代理方法
- (BOOL)mainScrollIsTopForScrollView:(UIScrollView *)scrollView
{
    if (self.mainScrollView.contentOffset.y >= 0) {
        return YES;
    }
    return NO;
}

#pragma mark - YBookMarkViewDelegate
- (void)bookMarkView:(YBookmarkView *)bookMarkView didSelectTitleAtIndex:(NSInteger)index
{
    NSLog(@"点击了标题");
}

- (void)bookMarkView:(YBookmarkView *)bookMarkView didScrollToIndex:(NSInteger)index
{
    NSLog(@"滚动到  第 %d 个标签页",(int)index);
}

- (void)bookMarkView:(YBookmarkView *)bookMarkView willDisplayingVC:(__kindof UIViewController *)vc index:(NSInteger)index
{
    NSLog(@"第 %d 标签页将要显示",(int)index);
}

- (void)bookMarkView:(YBookmarkView *)bookMarkView didEndDisplayingVC:(__kindof UIViewController *)vc index:(NSInteger)index
{
    NSLog(@"第 %d 标签页结束显示，就是页面不显示了",(int)index);
}

- (YBookmarkView *)bookmarkView
{
    if (!_bookmarkView) {
        CGFloat y = CGRectGetMaxY(self.headerView.frame);
        _bookmarkView = [[YBookmarkView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _bookmarkView.dataSource = self;
        _bookmarkView.delegate = self;
        _bookmarkView.topMarkHeight = 50;
        _bookmarkView.titleSelectFont = [UIFont systemFontOfSize:17];
        //        _bookmarkView.fixedTitleWidth = 100; //如果标题是固定宽度设置
        //还有很多参数可以设置，自己体会吧 😊
    }
    return _bookmarkView;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _mainScrollView.delegate = self;
        _mainScrollView.bounces = NO;
    }
    return _mainScrollView;
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 200)];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.image = [UIImage imageNamed:@"car.jpg"];
    }
    return _headerView;
}

- (YBScrollSuspendManage *)suspendManage
{
    if (!_suspendManage) {
        _suspendManage = [YBScrollSuspendManage new];
        _suspendManage.delegate = self;
    }
    return _suspendManage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
