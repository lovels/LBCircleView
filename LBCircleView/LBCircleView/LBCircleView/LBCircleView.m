//
//  LBCircleView.m
//  LBCircleView
//
//  Created by luobbe on 15/11/23.
//  Copyright © 2015年 luobbe. All rights reserved.
//

#import "LBCircleView.h"

@interface LBCircleView()
{
    CAShapeLayer *circleLayer;
    CAShapeLayer *bgCircleLayer;
    CGFloat radius;       //环形进度的半径
    CGPoint center;       //环形中心点
    double progress;      //进度的比例
    BOOL animated;
    CGFloat radian;
}

@property (nonatomic, strong) UILabel *percentLB;
@property (nonatomic, strong) UILabel *progressLB;
@property (nonatomic, strong) UILabel *subTitleLB;

@end

@implementation LBCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        _circleColor = ProgressColor;
        [self addSubview:self.percentLB];
        //计算最大的percentLB尺寸
        self.percentLB.text = [NSString stringWithFormat:@"%.0f%%",1.0*100];
        [self.percentLB sizeToFit];
        self.percentLB.text = @"0%";
        //
        [self configuration];
        //
        [self initBackgroundView];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setProgress:(double)value animated:(BOOL)animate
{
    NSAssert([self validateValue:value], @"value是包含0、1之间的数值");
    progress = value;
    animated = animate;
    radian = value * (2* M_PI - fabs(ChartStart - ChartEnd));
    self.percentLB.text = [NSString stringWithFormat:@"%.0f%%",progress*100];
    self.percentLB.center = [self percentCenter];
    //圆环
    [self creatCircleLayer];
}

//检查传过来的百分比 是否合法
- (BOOL)validateValue:(double)value
{
    if (value>= 0 && value <=1)
        return YES;
    
    return NO;
}

//设置
- (void)configuration
{
    //半径
    radius = CGRectGetWidth(self.frame)/2.0 - CGRectGetWidth(self.percentLB.frame);
    //中心点
    center = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetWidth(self.frame)/2.0);
}

//创建背景
- (void)initBackgroundView
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:ChartStart endAngle:ChartEnd clockwise:YES];
    bgCircleLayer = [CAShapeLayer layer];
    bgCircleLayer.path = path.CGPath;
    bgCircleLayer.fillColor = [UIColor clearColor].CGColor;
    bgCircleLayer.strokeColor = BackGroundColor.CGColor;
    bgCircleLayer.lineWidth = ChartWidth;
    [self.layer addSublayer:bgCircleLayer];
}

//进度圆环
- (void)creatCircleLayer
{
    if (circleLayer != nil) {
        [circleLayer removeFromSuperlayer];
    }
    UIBezierPath *path  = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius startAngle:ChartStart endAngle:ChartStart + radian clockwise:YES];
    circleLayer = [CAShapeLayer layer];
    circleLayer.path = path.CGPath;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = _circleColor.CGColor;
    circleLayer.lineWidth = ChartWidth-0.3;
    [self.layer addSublayer:circleLayer];
    if (animated) {
        [self circleAnimation:circleLayer];
        [self percentAnimate:self.percentLB.layer];
        [self.percentLB scrollNumFromValue:0 toValue:progress*100 during:2];
    }
}

#pragma mark ----animations
- (void)circleAnimation:(CALayer*)layer
{
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basic.duration = 2;
    basic.fromValue = @(0);
    basic.toValue = @(1);
    [layer addAnimation:basic forKey:@"StrokeEndKey"];
}

- (void)percentAnimate:(CALayer*)layer
{
    CGFloat R = CGRectGetWidth(self.frame)/2.0-CGRectGetWidth(self.percentLB.frame)/2.0;
    CGPoint centerP = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetWidth(self.frame)/2.0);
    
    UIBezierPath *path=[UIBezierPath bezierPath];
    //这段圆弧的中心，半径，开始角度，结束角度，是否顺时针方向。
    [path addArcWithCenter:centerP radius:R startAngle:ChartStart endAngle:ChartStart + radian clockwise:YES];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.duration = 2.0;
    animation.path = path.CGPath;
    animation.calculationMode = kCAAnimationPaced;
    [layer addAnimation:animation forKey:@"PercentPosition"];
    
}

//百分比的最终的中心位置
- (CGPoint)percentCenter
{
    CGFloat R = CGRectGetWidth(self.frame)/2.0-CGRectGetWidth(self.percentLB.frame)/2.0;
    CGPoint centerP = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetWidth(self.frame)/2.0);
    CGFloat x = centerP.x + R * cos(radian + ChartStart);
    CGFloat y = centerP.y + R * sin(radian + ChartStart);
    return CGPointMake(x, y);
}

- (UILabel *)percentLB
{
    if (_percentLB == nil) {
        //
        _percentLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _percentLB.font = [UIFont systemFontOfSize:10];
        _percentLB.backgroundColor = [UIColor clearColor];
        _percentLB.textAlignment = NSTextAlignmentCenter;
    }
    return _percentLB;
}

- (void)setPercentColor:(UIColor *)percentColor
{
    self.percentLB.textColor = percentColor;
}

@end

@implementation UILabel (LBAnimation)

- (void)scrollNumFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue during:(CGFloat)time
{
    //默认60次动画
    self.text = [NSString stringWithFormat:@"%.0f%%",fromValue];
    __block int count = 30; //循环的次数
    CGFloat increase = (toValue - fromValue)/count;
    CGFloat perTime = time * 1.0 / count;
    
    __block float currentNum = fromValue;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),perTime*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //计算每次递增
        if(count <= 0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.text = [NSString stringWithFormat:@"%.0f%%",toValue];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (currentNum >= toValue) {
                    count = 0;
                }else{
                    currentNum = currentNum + increase;
                    self.text = [NSString stringWithFormat:@"%.0f%%",currentNum];
                }
            });
            count --;
        }
    });
    dispatch_resume(_timer);
    
}

@end
