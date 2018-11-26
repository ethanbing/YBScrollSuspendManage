//
//  YBBaseTabelViewController.h
//  YBookmarkView_Example
//
//  Created by htbing on 2018/11/23.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBScrollSuspendManage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YBBaseTabelViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger index;

- (void)configData;

@end

NS_ASSUME_NONNULL_END
