//
//  XHBannerScoll.h
//  XHBannerInfiniteScroll
//
//  Created by 信昊 on 2018/7/31.
//  Copyright © 2018年 信昊. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义block用于外部点击回调
typedef void (^TapgestureBlock)(NSInteger pageIndex);

@interface XHBannerScoll : UIView

-(void)setUpPage:(NSArray *)pageViews block:(TapgestureBlock)block;

@end
