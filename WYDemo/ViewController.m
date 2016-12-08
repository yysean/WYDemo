//
//  ViewController.m
//  WYDemo
//
//  Created by 杨森 on 2016/12/8.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "ViewController.h"
#import "WYNewsViewController.h"
#import "TitleLable.h"
@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) NSArray *arrayLists;//新闻数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleScrollView.showsHorizontalScrollIndicator = NO;
    _titleScrollView.showsVerticalScrollIndicator = NO;
    _titleScrollView.scrollsToTop = NO;
    _newsScrollView.scrollsToTop = NO;
    
    _newsScrollView.delegate = self;
    
    [self addController];
    [self addLable];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    _newsScrollView.contentSize = CGSizeMake(contentX, 0);
    _newsScrollView.pagingEnabled = YES;
    
    // 添加默认控制器
    WYNewsViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = _newsScrollView.bounds;
    [_newsScrollView addSubview:vc.view];
    TitleLable *lable = [_titleScrollView.subviews firstObject];
    lable.scale = 1.0;
    _newsScrollView.showsHorizontalScrollIndicator = NO;

}

/** 添加子控制器 */
- (void)addController
{
    for (int i=0 ; i<self.arrayLists.count ;i++){
        WYNewsViewController *news = [[WYNewsViewController alloc]init];;
        news.content = _arrayLists[i];
        [self addChildViewController:news];
    }
}
/** 添加标题栏 */
- (void)addLable
{
    for (int i = 0; i < _arrayLists.count; i++) {
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        TitleLable *lbl1 = [[TitleLable alloc]init];
        lbl1.text =_arrayLists[i];
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [_titleScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    _titleScrollView.contentSize = CGSizeMake(70 * _arrayLists.count, 0);
    
}
/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    TitleLable *titlelable = (TitleLable *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag *_newsScrollView.frame.size.width;
    
    CGFloat offsetY = _newsScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [_newsScrollView setContentOffset:offset animated:YES];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / _newsScrollView.frame.size.width;
    
    // 滚动标题栏
    TitleLable *titleLable = (TitleLable *)_titleScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - _titleScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = _titleScrollView.contentSize.width -_titleScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, _titleScrollView.contentOffset.y);
    [_titleScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    WYNewsViewController *newsVc = self.childViewControllers[index];
    
    [_titleScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            TitleLable *temlabel = _titleScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (newsVc.view.superview)
    return;
    
    newsVc.view.frame = scrollView.bounds;
    [_newsScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    TitleLable *labelLeft = _titleScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < _titleScrollView.subviews.count) {
        TitleLable *labelRight =_titleScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}
- (NSArray *)arrayLists
{
    if (_arrayLists == nil) {
        _arrayLists = @[@"头条",@"手机",@"移动互联",@"娱乐",@"时尚",@"电影",@"NBA"];
    }
    return _arrayLists;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
