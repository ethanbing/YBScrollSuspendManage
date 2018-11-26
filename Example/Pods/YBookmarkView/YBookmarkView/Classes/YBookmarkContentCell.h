//
//  YBookmarkViewCell.h
//  YBookmarkView
//
//  Created by yinbing on 2018/6/14.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YBookmarkContentCell : UICollectionViewCell

//@property (nonatomic, strong, readonly) UIViewController *cellVC;
@property (nonatomic, weak) UIViewController *topVC;

- (void)updateDataForVC:(UIViewController *)vc;

@end

@interface YBookmarkTitleCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;
/** *  标题颜色*/
@property (nonatomic) UIColor * titleColor;
/** *  标题选中颜色*/
@property (nonatomic) UIColor * titleSelectColor;

@property (nonatomic) UIColor * topViewSidelineColor;

@property (nonatomic, strong) UIFont * titleLabelFont;
@property (nonatomic, strong) UIFont * titleSelectFont;

@end
