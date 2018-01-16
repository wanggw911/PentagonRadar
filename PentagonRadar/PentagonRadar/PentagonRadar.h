//
//  PentagonRadar.h
//  ChartDemo
//
//  Created by wangguowen on 2018/1/16.
//  Copyright © 2018年 GuowenWang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 五边形雷达图，参考实现：
 作者：hbblzjy
 链接：http://blog.csdn.net/hbblzjy/article/details/51719773
 */
@interface PentagonRadar : UIView

#pragma mark - 基础设置
@property (nonatomic, assign) CGPoint centerPoint; /** 雷达图中心点 */
@property (nonatomic, strong) NSArray *segmentLengths; /** 雷达图向外辐射的波段长度：辐射波默认4段，每段长度：@[@12, @22, @30, @30] */
@property (nonatomic, strong) UIColor *lineColor; /** 雷达图线的颜色，默认：[[UIColor whiteColor] colorWithAlphaComponent:0.1] */
@property (nonatomic, strong) UIColor *radarBGColor; /** 雷达图背景颜色，默认：[UIColor redColor] */
@property (nonatomic, strong) UIColor *radarFillColor; /** 雷达填充颜色，会有叠加效果，默认：[[UIColor whiteColor] colorWithAlphaComponent:0.3] */
@property (nonatomic, strong) UIColor *scoreFillColor; /** 得分填充颜色，默认：[[UIColor yellowColor] colorWithAlphaComponent:0.5] */
@property (nonatomic, assign) CGFloat duration; /** 动画时间 */
@property (nonatomic, assign) CGFloat totalScores; /** 中间显示的总分数 */
/**
 每个顶点(vertex)的分数：
 顺序：从正上方的顶点，顺时针方法转动设置
 默认：@[@4, @3, @2, @4, @3]
 大小：0-4：0-1、1-2、2-3、3-4
 */
@property (nonatomic, strong) NSArray *scores;
/**
 每个顶点的文字标识：
 */
@property (nonatomic, strong) NSArray *titles;
/**
 每个顶点的图片标识：
 */
@property (nonatomic, strong) NSArray *icons;

#pragma mark -

- (void)drawPentagonRadar;

@end
