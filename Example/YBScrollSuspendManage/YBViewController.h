//
//  YBViewController.h
//  YBScrollSuspendManage
//
//  Created by 380711712@qq.com on 11/24/2018.
//  Copyright (c) 2018 380711712@qq.com. All rights reserved.
//

@import UIKit;
#import "YBScrollSuspendManage.h"

@interface YBViewController : UIViewController<YBScrollSuspendManageDelegate>

@property (nonatomic, strong) YBScrollSuspendManage *suspendManage;

@end
