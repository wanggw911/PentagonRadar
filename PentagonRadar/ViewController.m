//
//  ViewController.m
//  PentagonRadar
//
//  Created by wangguowen on 2018/1/16.
//  Copyright © 2018年 GuowenWang. All rights reserved.
//

#import "ViewController.h"

#import "PentagonRadar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
    
    /**
     五边形雷达图，参考实现：
     作者：hbblzjy
     链接：http://blog.csdn.net/hbblzjy/article/details/51719773
     */
    PentagonRadar *radarView = [[PentagonRadar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    radarView.centerPoint = CGPointMake(width/2.0, height/2.0);
    [radarView drawPentagonRadar];
    [self.view addSubview:radarView];
}

@end
