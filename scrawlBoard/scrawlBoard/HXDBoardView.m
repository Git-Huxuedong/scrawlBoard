//
//  HXDBoardView.m
//  scrawlBoard
//
//  Created by huxuedong on 15/10/14.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import "HXDBoardView.h"
#import "HXDBezierPath.h"

@interface HXDBoardView ()

@property (strong, nonatomic) NSMutableArray *paths;

@end

@implementation HXDBoardView

//懒加载可变路径数组
- (NSMutableArray *)paths {
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

//重写image属性的set方法
- (void)setImage:(UIImage *)image {
    _image = image;
    //将图片添加到路径数组
    //[self.paths addObject:image];
    //重绘
    //[self setNeedsDisplay];
}

- (void)awakeFromNib {
    //设置初始线宽
    self.lineWidth = 1;
    //设置初始颜色
    self.lineColor = [UIColor blackColor];
    //创建通知中心，第一个参数为接收通知的对象为自己，第二个参数为接收到通知执行的方法，第三个参数为接收通知的名称，第四个参数为通知的接收者，设置为nil时表示要发送该通知名称的任何对象都可以发送该通知要传递的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processImage:) name:@"passImage" object:nil];
}

- (void)processImage:(NSNotification *)notification {
    //获取接收到的消息信息
    UIImage *image = notification.userInfo[@"image"];
    //将消息信息中的内容赋值给image属性
    self.image = image;
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//点击就会调用
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取所有触点
    UITouch *touch = [touches anyObject];
    //获取触点的位置
    CGPoint point = [touch locationInView:touch.view];
    //创建一个贝塞尔路径
    HXDBezierPath *path = [[HXDBezierPath alloc] init];
    //设置路径的颜色
    path.lineColor = self.lineColor;
    //判断block方法lineWidthBlock是否实现
    if (self.lineWidthBlock)
        //设置路径的线宽
        path.lineWidth = self.lineWidthBlock();
    //设置起点
    [path moveToPoint:point];
    //将路径添加到路径数组
    [self.paths addObject:path];
}

//手指移动时就会调用
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //获取所有触点
    UITouch *touch = [touches anyObject];
    //获取触点的位置
    CGPoint point = [touch locationInView:self];
    //获取路径数组中最后一个路径与当前触点连线
    [self.paths.lastObject addLineToPoint:point];
    //重绘
    [self setNeedsDisplay];
}

//绘图
- (void)drawRect:(CGRect)rect {
    //遍历路径数组
    for (HXDBezierPath *path in self.paths) {
        //设置路径颜色
        [path.lineColor set];
        //设置路径两端为圆角
        [path setLineCapStyle:kCGLineCapRound];
        //设置路径连接处为圆角
        [path setLineJoinStyle:kCGLineJoinRound];
        //绘制路径
        [path stroke];
    }
}

//清屏
- (void)clear {
    //移除路径数组中全部元素
    [self.paths removeAllObjects];
    //重绘
    [self setNeedsDisplay];
}

//撤销
- (void)undo {
    //移除路径数组中最后一个元祖
    [self.paths removeObject:self.paths.lastObject];
    //重绘
    [self setNeedsDisplay];
}

@end
