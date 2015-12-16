//
//  HXDGestureView.m
//  scrawlBoard
//
//  Created by huxuedong on 15/10/14.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import "HXDGestureView.h"

@interface HXDGestureView () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation HXDGestureView

//设置可以同时执行多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

//重写image属性方法，将image赋值给imageView的image属性
- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

//重写initWithFrame方法，当创建视图的时候调用
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //清除处理手势视图的背景颜色
        self.backgroundColor = [UIColor clearColor];
        [self addImageView];
        [self addGesture];
    }
    return self;
}

//添加图片
- (void)addImageView {
    //创建图片视图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    //设置图片视图可交互
    imageView.userInteractionEnabled = YES;
    //将图片视图赋值给的处理手势视图的imageView属性
    self.imageView = imageView;
    //将图片视图添加到处理手势视图
    [self addSubview:imageView];
}

//添加手势
- (void)addGesture {
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    //将长按手势添加到imageView属性
    [self.imageView addGestureRecognizer:longPress];
    //旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    //将旋转手势添加到imageView属性
    [self.imageView addGestureRecognizer:rotation];
    //缩放
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    //将缩放手势添加到imageView属性
    [self.imageView addGestureRecognizer:pinch];
    //平移
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    //将平移手势添加到imageView属性
    [self.imageView addGestureRecognizer:pan];
}

//长按的时候执行的方法（长按方法默认会调用两次，开始和最后各一次）
- (void)longPress:(UILongPressGestureRecognizer *)longPress {
    //判断长按的状态是否是开始状态
    if (longPress.state == UIGestureRecognizerStateBegan) {
        //设置动画
        [UIView animateWithDuration:0.5 animations:^{
            //设置图片视图为不可见
            self.imageView.alpha = 0;
        } completion:^(BOOL finished) {
            //设置动画
            [UIView animateWithDuration:0.5 animations:^{
                //设置图片视图为可见
                self.imageView.alpha = 1;
            } completion:^(BOOL finished) {
                //开启图片上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                //获取当前上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                //截屏
                [self.layer renderInContext:ctx];
                //获取当前图片上下文的图片
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                //关闭图片上下文
                UIGraphicsEndImageContext();
                //创建字典集合
                NSDictionary *dict = @{@"image" : image};
                //创建通知中心，第一个参数为通知的名称，第二个参数为通知发布者，设置为nil时表示要接收该通知名称的任何对象都可以接收该通知，第三个参数为要传递的信息，通知发布者传递给通知接受者的信息，把图片传递给画图板视图
                [[NSNotificationCenter defaultCenter] postNotificationName:@"passImage" object:nil userInfo:dict];
                //将图片视图从父控件（处理手势视图）中移除
                [self removeFromSuperview];
            }];
        }];
    }
}

//旋转时执行的方法
- (void)rotation:(UIRotationGestureRecognizer *)rotation {
    //旋转，rotation.rotation为旋转的角度
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, rotation.rotation);
    //将累加的旋转角度清零
    rotation.rotation = 0;
}

//缩放时执行的方法
- (void)pinch:(UIPinchGestureRecognizer *)pinch {
    //缩放，pinch.scale为手指捏合的比例程度
    self.imageView.transform = CGAffineTransformScale(self.imageView.transform, pinch.scale, pinch.scale);
    //每次缩放完成后设置缩放倍数为1
    pinch.scale = 1;
}

//移动时执行的方法
- (void)pan:(UIPanGestureRecognizer *)pan {
    //获取x,y轴移动的距离
    CGPoint translate = [pan translationInView:self.imageView];
    //移动
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, translate.x, translate.y);
    //将移动的距离清零
    [pan setTranslation:CGPointZero inView:self.imageView];
}

@end
