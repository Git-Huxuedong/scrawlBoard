//
//  ViewController.m
//  scrawlBoard
//
//  Created by huxuedong on 15/10/14.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import "ViewController.h"
#import "HXDBoardView.h"
#import "HXDGestureView.h"
#import "MBProgressHUD+MJ.h"

@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet HXDBoardView *boardView;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化线宽，调用block设置起始的线宽为slider的初始值1
    [self.boardView setLineWidthBlock:^CGFloat{
        return self.lineWidthSlider.value;
    }];
}

//设置画笔颜色
- (IBAction)colorButton:(UIButton *)sender {
    self.boardView.lineColor = sender.backgroundColor;
}

//清屏
- (IBAction)clearAction {
    [self.boardView clear];
}

//撤销
- (IBAction)undoAction {
    [self.boardView undo];
}

//橡皮擦
- (IBAction)eraserAction {
    self.boardView.lineColor = [UIColor whiteColor];
}

//保存
- (IBAction)saveAction {
    //开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.boardView.bounds.size, NO, 0);
    //设置当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //截屏
    [self.boardView.layer renderInContext:ctx];
    //获取当前图片上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图片上下文
    UIGraphicsEndImageContext();
    //保存图片到相册中
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//保存图片调用的方法，用于判断是否保存成功
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error)
        [MBProgressHUD showError:@"保存失败！"];
    else
        [MBProgressHUD showSuccess:@"保存成功！"];
}

//图片
- (IBAction)pictureAction {
    //创建图片选择控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //图片选择器的数据源为相册
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //设置图片选择控制器的代理为主控制器
    picker.delegate = self;
    //modal方法跳转控制器
    [self presentViewController:picker animated:YES completion:nil];
}

//图片选择器选择一张图片的时候就会调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //设置选择图片的类型为原图
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //创建处理手势的视图
    HXDGestureView *gestureView = [[HXDGestureView alloc] initWithFrame:self.boardView.bounds];
    //把选择的图片传给处理手势视图的图片属性
    gestureView.image = image;
    //将图片处理视图添加到画图板
    [self.boardView addSubview:gestureView];
    //用modal方法回退控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
