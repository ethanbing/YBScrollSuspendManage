# YBScrollSuspendManage

[![CI Status](https://img.shields.io/travis/380711712@qq.com/YBScrollSuspendManage.svg?style=flat)](https://travis-ci.org/380711712@qq.com/YBScrollSuspendManage)
[![Version](https://img.shields.io/cocoapods/v/YBScrollSuspendManage.svg?style=flat)](https://cocoapods.org/pods/YBScrollSuspendManage)
[![License](https://img.shields.io/cocoapods/l/YBScrollSuspendManage.svg?style=flat)](https://cocoapods.org/pods/YBScrollSuspendManage)
[![Platform](https://img.shields.io/cocoapods/p/YBScrollSuspendManage.svg?style=flat)](https://cocoapods.org/pods/YBScrollSuspendManage)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YBScrollSuspendManage is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YBScrollSuspendManage'
```

## Usage

### 说明：适用于页面嵌套滚动，并且滚动到某个位置可以悬停滚动

#### 1、主控制器初始化YBScrollSuspendManage

```objective-c
- (YBScrollSuspendManage *)suspendManage
{
    if (!_suspendManage) {
        _suspendManage = [YBScrollSuspendManage new];
        _suspendManage.delegate = self;
    }
    return _suspendManage;
}
```

#### 2、在初始化子控制器时，把suspendManage传给子控制器

```objective-c
YBGridViewController * gridVC = [YBGridViewController new];
gridVC.yb_suspendManage = self.suspendManage;
```

#### 3、在主控制器的scrollViewDidScroll：代理方法调用

```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    YBBaseTabelViewController * tabelViewController = [self.bookmarkView currentViewController];
    //需要悬浮滚动的控制器
    [self.suspendManage mainScrollViewDidScroll:scrollView subScrollView:tabelViewController.tableView forHeaderMaxY:200];
}
```

#### 4、子控制器的ScrollView激活多手势

```objective-c
//激活多手势
_tableView.yb_enableGestureScroll = YES;
```

#### 5、在子控制器的scrollViewDidScroll：代理方法调用

```objective-c
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.yb_suspendManage subScrollViewDidScroll:scrollView];
}
```

#### 6、在主控制器实现代理方法，就是计算悬停位置，返回 YES or NO

```objective-c
#pragma mark - YBScrollSuspendManageDelegate
- (BOOL)enableSuspendForSubScroll:(UIScrollView *)subScrollView
{
    CGRect rect = [self.bookmarkView convertRect:self.bookmarkView.bounds toView:self.view];
    if (rect.origin.y <= 0) {
        //需要悬浮
        return YES;
    }
    return NO;
}
```

#### 然后…然后效果就出来啦🙂

## Author

Ethanbing, 380711712@qq.com

## License

YBScrollSuspendManage is available under the MIT license. See the LICENSE file for more info.
