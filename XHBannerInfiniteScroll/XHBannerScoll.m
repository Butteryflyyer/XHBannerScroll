//
//  XHBannerScoll.m
//  XHBannerInfiniteScroll
//
//  Created by 信昊 on 2018/7/31.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "XHBannerScoll.h"

@interface XHBannerScoll()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger _pageCount;
    NSTimer *_Timer;
    TapgestureBlock _tapBlock;
    NSArray *_ImageArray;
    NSInteger _prePageIndex;
}
@end

@implementation XHBannerScoll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initScrollView];
        [self initPageControll];
        
    }
    return self;
}
-(void)initScrollView{  //初始化scrollview
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}
-(void)initPageControll{//初始化pagecontrol

    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50)];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    _pageControl.enabled = YES ;
    [_pageControl setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
    [_pageControl addTarget:self action:@selector(pageControlTouched) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
}
- (void)initTapGesture
{
    // 点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] init];
    [gesture addTarget:self action:@selector(pageClick)];
    [self addGestureRecognizer:gesture];
}

-(void)pageClick{
    if (_tapBlock) {
        _tapBlock(_pageControl.currentPage);
    }
}
-(void)setUpPage:(NSArray *)pageViews block:(TapgestureBlock)block{
    _ImageArray = pageViews;
    _pageCount = pageViews.count;
    if (pageViews.count > 1) {
       _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame));
    }else{
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame)*1, CGRectGetHeight(self.frame));
    }
    
    _pageControl.numberOfPages = _pageCount;
    _tapBlock = block;
    for (int i = 0; i<3; i++) {
        UIImageView *page = [[UIImageView alloc] init];
        page.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        page.tag = 1000 + i;
        [_scrollView addSubview:page];
    }
    UIImageView *leftPage = [_scrollView viewWithTag:1000];
    UIImageView *middlePage = [_scrollView viewWithTag:1001];
    UIImageView *rightPage = [_scrollView viewWithTag:1002];
    
    leftPage.image = _ImageArray.lastObject;  //刚开始   中间的肯定是显示第一张   左边的显示倒数第一张  右边的显示第二张图片
    middlePage.image = _ImageArray.firstObject;
    if (pageViews.count > 1) { //针对如果只有一张图片的情况
    rightPage.image = _ImageArray[1];
    }else{
       rightPage.image = _ImageArray[0];
    }
    _scrollView.contentOffset = CGPointMake(self.frame.size.width,0);//首先显示中间的view
    _pageControl.currentPage = 0;
    _prePageIndex = 0;
    
    if (pageViews.count > 1) {
        [self startTimer]; //开始计时器开始移动
    }
    
}
-(void)startTimer{
    _Timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changePageRight) userInfo:nil repeats:YES];
}
-(void)stopTimer{
    [_Timer invalidate];
    _Timer = nil;
}
-(void)changePageRight{//0  1  2   因为显示中间的view 所以从1开始，再移动要往右移动
     [_scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
     [self resetPageIndex:YES];
}
- (void)changePageLeft
{
    // 往左滑，永远都是滑动到第一页
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self resetPageIndex:NO];
}
#pragma mark - 重新设置索引和页面图片
- (void)resetPageIndex:(BOOL)isRight
{
    if (isRight)//向右滑动
    {
        // 根据之前的page下标来修改
        if (_prePageIndex == _pageCount - 1)
        {
            // 到头了就回到第一个
            _pageControl.currentPage = 0;
        }
        else
        {
            // 这里用_prePageIndex来算，否则点击小圆点条会重复计算了
            _pageControl.currentPage = _prePageIndex + 1;
        }
    }
    else
    {
        if (_prePageIndex == 0)
        {
            _pageControl.currentPage = _pageCount - 1;
        }
        else
        {
            _pageControl.currentPage = _prePageIndex - 1;
        }
    }
    _prePageIndex = _pageControl.currentPage;//记录当前的选中页
}

- (void)resetPageView
{
    // 每次滑动完了之后又重新设置当前显示的page时中间的page
    UIImageView *leftPage = [_scrollView viewWithTag:1000];
    UIImageView *middlePage = [_scrollView viewWithTag:1001];
    UIImageView *rightPage = [_scrollView viewWithTag:1002];
    
    if (_pageControl.currentPage == _pageCount - 1)//如果是到了最后一个，则中间的显示最后一个，左边的显示倒数第二个 右边的显示第一个
    {
        // n- 1 -> n -> 0
        leftPage.image = _ImageArray[_pageControl.currentPage - 1];
        middlePage.image = _ImageArray[_pageControl.currentPage];
        rightPage.image = _ImageArray.firstObject;
        
    }
    else if (_pageControl.currentPage == 0)//如果是第一个  则中间的显示第一个  左边显示倒数第一个  右边显示第二个
    {
        // n -> 0 -> 1
        // 到尾部了，改成从头开始
        leftPage.image = _ImageArray.lastObject;
        middlePage.image = _ImageArray.firstObject;
        rightPage.image = _ImageArray[1];
    }
    else //其他情况
    {
        // x - 1 -> x -> x + 1
        leftPage.image = _ImageArray[_pageControl.currentPage - 1];
        middlePage.image = _ImageArray[_pageControl.currentPage];
        rightPage.image = _ImageArray[_pageControl.currentPage + 1];
    }
    
    // 重新设置偏移量
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
}
#pragma mark - pagecontrol事件
-(void)pageControlTouched
{
    [self stopTimer];
    
    NSInteger curPageIndex = _pageControl.currentPage;
    if (curPageIndex > _prePageIndex)
    {
        // 右滑
        [self changePageRight];
    }
    else
    {
        // 左滑
        [self changePageLeft];
    }
    
    [self startTimer];
}


#pragma mark - scrollview滑动代理
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 先停掉定时器
    [self stopTimer];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 手动拖拽滑动结束后
    if (scrollView.contentOffset.x > self.frame.size.width)
    {
        // 右滑
        [self resetPageIndex:YES];
    }
    else
    {
        // 左滑
        [self resetPageIndex:NO];
    }
    [self resetPageView];
    
    // 开启定时器
    [self startTimer];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 自动滑动结束后重新设置图片
    [self resetPageView];
}


@end
