//
//  ViewController.m
//  LBCircleView
//
//  Created by luobbe on 15/11/23.
//  Copyright © 2015年 luobbe. All rights reserved.
//

#import "ViewController.h"
#import "LBCircleView.h"

@interface ViewController ()
{
    LBCircleView *circleView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    circleView = [[LBCircleView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    circleView.center = self.view.center;
    circleView.backgroundColor = [UIColor colorWithRed:255.0/255 green:157.0/255 blue:182.0/255 alpha:1.0];
    [self.view addSubview:circleView];
    circleView.percentColor = [UIColor colorWithRed:76.0/255 green:15.0/255 blue:77.0/255 alpha:1.0];
    
    [circleView setProgress:0.5 animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [circleView setProgress:(arc4random()%100/100.0) animated:YES];
    
}

@end
