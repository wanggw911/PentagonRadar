//
//  UIBezierPath+Chart.h
//  ChartDemo
//
//  Created by wangguowen on 2018/1/15.
//  Copyright © 2018年 GuowenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (Chart)

#pragma mark - 倒五边形⬟

+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center Length:(double)length;
+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths;
+ (NSArray *)converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center;

#pragma mark - 正五边形⬟

+ (CGPathRef)gw_drawPentagonWithCenter:(CGPoint)center Length:(double)length;
+ (CGPathRef)gw_drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths;
+ (NSArray *)gw_converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center;

#pragma mark - 绘制中心点到五个顶点之间的白线

+ (NSArray *)line_getPentagonPoint:(CGPoint)center Length:(double)length;

@end
