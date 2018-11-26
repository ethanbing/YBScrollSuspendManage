//
//  YBBaseCollectionController.h
//  YBScrollSuspendManage_Example
//
//  Created by htbing on 2018/11/26.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBScrollSuspendManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBBaseCollectionController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

- (void)registerCell;

- (void)configData;

@end

NS_ASSUME_NONNULL_END
