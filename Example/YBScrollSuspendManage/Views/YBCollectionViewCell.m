//
//  YBCollectionViewCell.m
//  YBScrollSuspendManage_Example
//
//  Created by htbing on 2018/11/26.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import "YBCollectionViewCell.h"

@interface YBCollectionViewCell()

@end


@implementation YBCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContent];
    }
    return self;
}

- (void)setupContent
{
    [self addSubview:self.titleLabel];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor colorWithRed:self.arandom green:self.arandom blue:self.arandom alpha:1];
        _titleLabel.textColor = [UIColor colorWithRed:self.arandom green:self.arandom blue:self.arandom alpha:1];
    }
    return _titleLabel;
}

- (CGFloat)arandom
{
    return (arc4random() % 256) / 255.0;
}

@end
