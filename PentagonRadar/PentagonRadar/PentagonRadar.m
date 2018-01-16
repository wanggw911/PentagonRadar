//
//  PentagonRadar.m
//  ChartDemo
//
//  Created by wangguowen on 2018/1/16.
//  Copyright © 2018年 GuowenWang. All rights reserved.
//

#import "PentagonRadar.h"
#import "UIBezierPath+Chart.h"

#define kDefaultScores          @[@4, @3.5, @2.5, @4, @3.2]
#define kDefaultLineColor       [[UIColor whiteColor] colorWithAlphaComponent:0.1]
#define kDefaultFillColor       [[UIColor whiteColor] colorWithAlphaComponent:0.2]
#define kDefaultScoreFillColor  [[UIColor yellowColor] colorWithAlphaComponent:0.5]

@interface PentagonRadar ()
@property (nonatomic, strong) UILabel *centerTextLabel;
@property (nonatomic, strong) NSTimer *numberChangeTimer;
@property (nonatomic, assign) CGFloat numberPercent;
@end

@implementation PentagonRadar

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    if ([[NSValue valueWithCGRect:self.frame] isEqualToValue:[NSValue valueWithCGRect:CGRectZero]]) {
        //默认Frame
        self.frame = CGRectMake(0, 0, screenWidth, 400);
    }
    self.centerPoint = CGPointMake(screenWidth/2, 220);
    self.radarBGColor = [UIColor redColor];
    self.lineColor = kDefaultLineColor;
    self.radarFillColor = kDefaultFillColor;
    self.scoreFillColor = kDefaultScoreFillColor;
    
    self.duration = 1.0;
    self.totalScores = 78.93;
    self.scores = kDefaultScores;
    self.titles = @[@"项目一", @"项目二", @"项目三", @"项目四", @"项目五"];
    self.icons = @[@"", @"", @"", @"", @""];
}

#pragma mark -

- (void)drawPentagonRadar {
    self.backgroundColor = self.radarBGColor;
    
    //绘制五边形边框
    [self drawPentagonFrame];
    //绘制中心点到五个顶点之间的白线
    [self drawPointToPointLines];
    //绘制得分区域
    [self drawScorePentagonView];
    //中心点添加文字
    [self addCenterText];
    //添加五个顶点图片文字
    [self addVertexTextAndIcons];
}

#pragma mark - 绘制五边形边框

- (void)drawPentagonFrame {
    [self drawPentagonFrameWith:@[@4, @4, @4, @4, @4]];
    [self drawPentagonFrameWith:@[@3, @3, @3, @3, @3]];
    [self drawPentagonFrameWith:@[@2, @2, @2, @2, @2]];
    [self drawPentagonFrameWith:@[@1, @1, @1, @1, @1]];
}

- (void)drawPentagonFrameWith:(NSArray *)scoresArray {
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = self.radarFillColor.CGColor;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = self.lineColor.CGColor;
    NSArray *lengthsArray = [self convertLengthsFromScore:scoresArray];
    shapeLayer.path = [UIBezierPath gw_drawPentagonWithCenter:self.centerPoint LengthArray:lengthsArray];
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - 绘制中心点到五个顶点之间的白线

- (void)drawPointToPointLines {
    NSArray *scoresArray = @[@5, @5, @5, @5, @5];
    NSArray *lengthsArray = [self convertLengthsFromScore:scoresArray];
    double lenth = [lengthsArray[0] doubleValue];
    NSArray *pointsArray = [UIBezierPath line_getPentagonPoint:self.centerPoint Length:lenth];
    
    
    for (int i = 0; i < [pointsArray count]; i++) {
        CGPoint point = [[pointsArray objectAtIndex:i] CGPointValue];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint:self.centerPoint];
        [bezierPath addLineToPoint:point];
        [bezierPath closePath];
        
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.lineWidth = 1;
        shapeLayer.strokeColor = self.lineColor.CGColor;
        shapeLayer.path = bezierPath.CGPath;
        [self.layer addSublayer:shapeLayer];
    }
}

#pragma mark - 描绘中间得分阴影层

- (void)drawScorePentagonView {
    NSArray *scoresArray = (self.scores.count == 4) ? self.scores : kDefaultScores;

    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = self.scoreFillColor.CGColor;
    shapeLayer.lineWidth = 0;
    shapeLayer.strokeColor = [[UIColor clearColor] CGColor];
    
    NSArray *lengthsArray = [self convertLengthsFromScore:scoresArray];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (id)[UIBezierPath gw_drawPentagonWithCenter:self.centerPoint Length:0];
    pathAnimation.toValue = (id)[UIBezierPath gw_drawPentagonWithCenter:self.centerPoint LengthArray:lengthsArray];
    pathAnimation.duration = self.duration;
    pathAnimation.autoreverses = NO;
    pathAnimation.repeatCount = 0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [shapeLayer addAnimation:pathAnimation forKey:@"scale"];
    shapeLayer.path = [UIBezierPath gw_drawPentagonWithCenter:self.centerPoint LengthArray:lengthsArray];
    [self.layer addSublayer:shapeLayer];
}

#pragma mark - 添加中心点显示的文字

- (void)addCenterText {
    [self addSubview:self.centerTextLabel];
    
    self.numberPercent = 0.00;
    self.numberChangeTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(numberAnimation) userInfo:nil repeats:YES];
}

- (void)numberAnimation {
    if (!self.totalScores) {
        [self.numberChangeTimer invalidate];
        self.numberChangeTimer = nil;
        return;
    }
    
    self.numberPercent += (self.totalScores / (self.duration * 10.f));
    if (self.numberPercent >= self.totalScores) {
        [self.numberChangeTimer invalidate];
        self.numberChangeTimer = nil;
        self.numberPercent = self.totalScores;
    }
    self.centerTextLabel.text = [NSString stringWithFormat:@"%.2f", self.numberPercent];
}

#pragma mark - 添加五个顶点图片文字

- (void)addVertexTextAndIcons {
    NSArray *scoresArray = @[@5, @5, @5, @5, @5];
    NSArray *lengthsArray = [self convertLengthsFromScore:scoresArray];
    double lenth = [lengthsArray[0] doubleValue];
    NSArray *pointsArray = [UIBezierPath line_getPentagonPoint:self.centerPoint Length:lenth];
    
    /*
     通过 offset 数组来校正 image 中心点的位置：
     */
    NSArray *offsetArray = @[[NSValue valueWithCGSize:CGSizeMake(0, -45)],      //正上角
                             [NSValue valueWithCGSize:CGSizeMake(40, -10)],     //右上角
                             [NSValue valueWithCGSize:CGSizeMake(40, 10)],      //右下角
                             [NSValue valueWithCGSize:CGSizeMake(-40, 10)],     //左下角
                             [NSValue valueWithCGSize:CGSizeMake(-40, -10)]];   //左上角
    for (int i = 0; i < [pointsArray count]; i++) {
        CGPoint offset = [[offsetArray objectAtIndex:i] CGPointValue];
        CGPoint point = [[pointsArray objectAtIndex:i] CGPointValue];
        
        
        NSString *imageName = self.icons[i];
        UIImageView *imageView = [self imageViewOfIcon];
        imageView.center = CGPointMake(point.x + offset.x,
                                       point.y + offset.y);
        imageView.image = [UIImage imageNamed:imageName];
        imageView.backgroundColor = imageName.length > 0 ? [UIColor clearColor] : [UIColor whiteColor];
        [self addSubview:imageView];
        
        
        UILabel *textLabel = [self labelOfTitle];
        textLabel.center = CGPointMake(imageView.center.x,
                                   imageView.center.y + 30);
        textLabel.text = self.titles[i];
        [self addSubview:textLabel];
    }
}

#pragma mark - 分数转换

- (NSArray *)convertLengthsFromScore:(NSArray *)scoreArray {
    NSMutableArray *lengthArray = [NSMutableArray array];
    for (int i = 0; i < [scoreArray count]; i++) {
        double score = [[scoreArray objectAtIndex:i] doubleValue];
        [lengthArray addObject:[self convertLengthFromScore:score]];
    }
    return lengthArray;
}

- (NSNumber *)convertLengthFromScore:(double)score {
    if (score >= 4) {
        return @(12 + 22 + 30 + 30);
    } else if (score >= 3){
        return @(12 + 22 + 30 + 30 * (score - 3));
    } else if (score >= 2) {
        return @(12 + 22 + 30 * (score - 2));
    } else if (score >= 1) {
        return @(12 + 22 * (score - 1));
    } else  {
        return @(12 * score);
    }
}

#pragma mark - Getter

- (UILabel *)centerTextLabel {
    if (!_centerTextLabel) {
        _centerTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        _centerTextLabel.center = self.centerPoint;
        _centerTextLabel.backgroundColor = [UIColor clearColor];
        _centerTextLabel.font = [UIFont boldSystemFontOfSize:25];
        _centerTextLabel.text = @"00.00";
        _centerTextLabel.textColor = [UIColor whiteColor];
        _centerTextLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerTextLabel;
}

- (UIImageView *)imageViewOfIcon {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    imageView.backgroundColor = [UIColor whiteColor];
    return imageView;
}

- (UILabel *)labelOfTitle {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end
