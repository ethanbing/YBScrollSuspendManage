//
//  YBBaseTabelViewController.m
//  YBookmarkView_Example
//
//  Created by htbing on 2018/11/23.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import "YBBaseTabelViewController.h"

@interface YBBaseTabelViewController ()

@end

@implementation YBBaseTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupContent];
    [self configData];
}

- (void)setupContent
{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
}

- (void)configData
{
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    NSString * str = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.yb_suspendManage subScrollViewDidScroll:scrollView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        //激活多手势
        _tableView.yb_enableGestureScroll = YES;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
