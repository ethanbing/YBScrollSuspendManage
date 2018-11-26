//
//  YBFirstViewController.m
//  YBookmarkView_Example
//
//  Created by htbing on 2018/11/23.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import "YBFirstViewController.h"

@interface YBFirstViewController ()

@end

@implementation YBFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)configData
{
    [self.dataArray removeAllObjects];
    for (int i=0; i<20; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"第%d个页面 第%d行",(int)self.index, i+1]];
    }
    [self.tableView reloadData];
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
