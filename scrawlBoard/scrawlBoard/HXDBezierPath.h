//
//  HXDBezierPath.h
//  scrawlBoard
//
//  Created by huxuedong on 15/10/14.
//  Copyright © 2015年 huxuedong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXDBezierPath : UIBezierPath

//自定义一个路径，继承贝塞尔路径，并创建一个新的颜色属性
@property (strong, nonatomic) UIColor *lineColor;

@end
