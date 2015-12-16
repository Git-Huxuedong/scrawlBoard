//
//  HXDBoardView.h
//  scrawlBoard
//
//  Created by huxuedong on 15/10/14.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXDBoardView : UIView

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;
//创建一个设置线宽的block代码块属性，方法名为lineWidthBlock，返回值为CGFloat，没有参数
@property (copy, nonatomic) CGFloat (^lineWidthBlock)();
@property (strong, nonatomic) UIImage *image;

- (void)clear;
- (void)undo;

@end
