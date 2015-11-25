//
//  LBCircleView.h
//  LBCircleView
//
//  Created by luobbe on 15/11/23.
//  Copyright © 2015年 luobbe. All rights reserved.
//

#import <UIKit/UIKit.h>

//环形画笔的宽度
#define ChartWidth 3
//环形开始的位置
#define ChartStart  M_PI*5/6
//环形结束的位置
#define ChartEnd    M_PI/6

#define BackGroundColor  [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] //环形背景默认颜色
#define ProgressColor [UIColor orangeColor] //

@interface LBCircleView : UIView

@property (nonatomic, strong) UIColor *percentColor;

/**set before call setProgress: or useless    Default is ProgressColor */
@property (nonatomic, strong) UIColor *circleColor;

- (void)setProgress:(double)value animated:(BOOL)animate;

@end

@interface UILabel (LBAnimation)

//数字滚动
- (void)scrollNumFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue during:(CGFloat)time;

@end