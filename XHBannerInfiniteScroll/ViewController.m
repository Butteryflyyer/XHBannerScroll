//
//  ViewController.m
//  XHBannerInfiniteScroll
//
//  Created by 信昊 on 2018/7/31.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import "ViewController.h"
#import "XHBannerScoll.h"
@interface ViewController ()
{
    XHBannerScoll *_scroll;
    NSArray *_imageArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageArray = @[@"展示1",@"展示2",@"展示3",@"展示4",@"展示5"];
    _scroll = [[XHBannerScoll alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self initData];
    [self.view addSubview:_scroll];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initData{
    NSMutableArray *imagerray = [NSMutableArray array];
    for (int i = 0; i < _imageArray.count; i++)
    {
        // 先用空白页测试
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"展示%d", i + 1]];
        [imagerray addObject:image];
    }
    [_scroll setUpPage:imagerray block:^(NSInteger pageIndex) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
