//
//  YBGridViewController.m
//  YBScrollSuspendManage_Example
//
//  Created by htbing on 2018/11/26.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import "YBGridViewController.h"
#import "YBCollectionViewCell.h"

@interface YBGridViewController ()

@end

@implementation YBGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)registerCell
{
    [self.collectionView registerClass:YBCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(YBCollectionViewCell.class)];
}

- (void)configData
{
    for (int i=0; i<20; i++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"第%d item",i+1]];
    }
    [self.collectionView reloadData];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YBCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(YBCollectionViewCell.class) forIndexPath:indexPath];
    cell.titleLabel.text = self.dataArray[indexPath.item];
    return cell;
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
