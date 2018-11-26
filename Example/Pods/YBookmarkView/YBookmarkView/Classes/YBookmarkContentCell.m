//
//  YBookmarkViewCell.m
//  YBookmarkView
//
//  Created by yinbing on 2018/6/14.
//  Copyright © 2018年 yinbing. All rights reserved.
//

#import "YBookmarkContentCell.h"

@implementation YBookmarkContentCell

- (void)updateDataForVC:(UIViewController *)vc
{
    [self.contentView addSubview:vc.view];
    [self.topVC addChildViewController:vc];
    _topVC = vc;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_topVC) {
        [_topVC removeFromParentViewController];
    }
}

@end

@implementation YBookmarkTitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    _titleLabel.textColor = titleColor;
}

- (void)setTitleLabelFont:(UIFont *)titleLabelFont
{
    _titleLabelFont = titleLabelFont;
    _titleLabel.font = titleLabelFont;
}

- (CGFloat)scaleFont
{
    return self.titleSelectFont.xHeight / self.titleLabelFont.xHeight;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    CGFloat scale = [self scaleFont];
//    Weak_Self
    if (selected) {
        self.titleLabel.textColor = self.titleSelectColor;
//        _titleLabel.font = self.titleSelectFont;
        if (scale == 1) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.titleLabel.transform = CGAffineTransformMakeScale(scale, scale);
        }];
    }else{
        self.titleLabel.textColor = self.titleColor;
//        _titleLabel.font = self.titleLabelFont;
        if (scale == 1) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.titleLabel.transform = CGAffineTransformIdentity;
        }];
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _titleLabel;
}

@end
