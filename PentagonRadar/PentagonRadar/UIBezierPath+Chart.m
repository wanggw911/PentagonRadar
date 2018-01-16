//
//  UIBezierPath+Chart.m
//  ChartDemo
//
//  Created by wangguowen on 2018/1/15.
//  Copyright © 2018年 GuowenWang. All rights reserved.
//

#import "UIBezierPath+Chart.h"

@implementation UIBezierPath (Chart)

#pragma mark - 倒五边形⬟

/*
 第一个方法是用来画各顶点不规律的五边形的，
 而第二个方法是用来画那几个背景五边形，两个方法中的length都指的的中心点到各顶点的距离,
 第三个方法则是用来将距离转换成具体坐标。
 */
+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center Length:(double)length
{
    NSArray *lengths = [NSArray arrayWithObjects:@(length), @(length), @(length), @(length), @(length), nil];
    return [self drawPentagonWithCenter:center LengthArray:lengths];
}

+ (CGPathRef)drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths
{
    NSArray *coordinates = [self converCoordinateFromLength:lengths Center:center];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    for (int i = 0; i < [coordinates count]; i++) {
        CGPoint point = [[coordinates objectAtIndex:i] CGPointValue];
        if (i == 0) {
            [bezierPath moveToPoint:point];
        } else {
            [bezierPath addLineToPoint:point];
        }
    }
    [bezierPath closePath];
    return bezierPath.CGPath;
}

+ (NSArray *)converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center
{
    //这个是倒五边形⬟，角在下面👇
    //NSArray *colorArray = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor blackColor], [UIColor grayColor]];
    NSMutableArray *coordinateArray = [NSMutableArray array];
    for (int i = 0; i < [lengthArray count] ; i++) {
        double length = [[lengthArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointZero;
        if (i == 0) {
            //左上角
            point =  CGPointMake(center.x - length * sin(M_PI / 5.0),
                                 center.y - length * cos(M_PI / 5.0));
        } else if (i == 1) {
            //右上角
            point = CGPointMake(center.x + length * sin(M_PI / 5.0),
                                center.y - length * cos(M_PI / 5.0));
        } else if (i == 2) {
            //右下角
            point = CGPointMake(center.x + length * cos(M_PI / 10.0),
                                center.y + length * sin(M_PI / 10.0));
        } else if (i == 3) {
            //正下角
            point = CGPointMake(center.x,
                                center.y +length);
        } else {
            //左下角
            point = CGPointMake(center.x - length * cos(M_PI / 10.0),
                                center.y + length * sin(M_PI / 10.0));
        }
        [coordinateArray addObject:[NSValue valueWithCGPoint:point]];
    }
    return coordinateArray;
}

#pragma mark - 升级版：正五边形⬟

+ (CGPathRef)gw_drawPentagonWithCenter:(CGPoint)center Length:(double)length
{
    NSArray *lengths = [NSArray arrayWithObjects:@(length), @(length), @(length), @(length), @(length), nil];
    return [self gw_drawPentagonWithCenter:center LengthArray:lengths];
}

+ (CGPathRef)gw_drawPentagonWithCenter:(CGPoint)center LengthArray:(NSArray *)lengths
{
    NSArray *coordinates = [self gw_converCoordinateFromLength:lengths Center:center];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    for (int i = 0; i < [coordinates count]; i++) {
        CGPoint point = [[coordinates objectAtIndex:i] CGPointValue];
        if (i == 0) {
            [bezierPath moveToPoint:point];
        } else {
            [bezierPath addLineToPoint:point];
        }
    }
    [bezierPath closePath];
    return bezierPath.CGPath;
}

+ (NSArray *)gw_converCoordinateFromLength:(NSArray *)lengthArray Center:(CGPoint)center
{
    NSMutableArray *coordinateArray = [NSMutableArray array];
    for (int i = 0; i < [lengthArray count] ; i++) {
        double length = [[lengthArray objectAtIndex:i] doubleValue];
        CGPoint point = CGPointZero;
        if (i == 0) {
            //正上角
            point = CGPointMake(center.x,
                                center.y - length);
        } else if (i == 1) {
            //右上角
            point = CGPointMake(center.x + length * cos(M_PI / 10.0),
                                center.y - length * sin(M_PI / 10.0));
            
        } else if (i == 2) {
            //右下角
            point = CGPointMake(center.x + length * sin(M_PI / 5.0),
                                center.y + length * cos(M_PI / 5.0));
        } else if (i == 3) {
            //左下角
            point =  CGPointMake(center.x - length * sin(M_PI / 5.0),
                                 center.y + length * cos(M_PI / 5.0));
        } else {
            //左上角
            point = CGPointMake(center.x - length * cos(M_PI / 10.0),
                                center.y - length * sin(M_PI / 10.0));
        }
        [coordinateArray addObject:[NSValue valueWithCGPoint:point]];
    }
    return coordinateArray;
}

#pragma mark - 绘制中心点到五个顶点之间的白线

+ (NSArray *)line_getPentagonPoint:(CGPoint)center Length:(double)length
{
    NSArray *lengths = [NSArray arrayWithObjects:@(length), @(length), @(length), @(length), @(length), nil];
    NSArray *coordinates = [self gw_converCoordinateFromLength:lengths Center:center];
    return coordinates;
}

@end
