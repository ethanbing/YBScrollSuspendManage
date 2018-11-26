//
//  YBMoreViewController.m
//  YBookmarkView_Example
//
//  Created by htbing on 2018/11/23.
//  Copyright © 2018 380711712@qq.com. All rights reserved.
//

#import "YBMoreViewController.h"

@interface YBMoreViewController ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation YBMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupContent];
}

- (void)setupContent
{
    self.view.backgroundColor = [UIColor colorWithRed:self.arandom green:self.arandom blue:self.arandom alpha:1];
    [self.view addSubview:self.label];
    self.label.text = [NSString stringWithFormat:@"第 %d 页面",(int)self.index];
}

- (CGFloat)arandom
{
    return (arc4random() % 256) / 255.0;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100)];
        _label.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)-100);
        _label.font = [UIFont systemFontOfSize:30];
        _label.textColor  = [UIColor greenColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
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
