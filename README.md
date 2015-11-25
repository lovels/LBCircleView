## LBCircleView

### 效果

![image](http://ww1.sinaimg.cn/large/9f1201f5jw1eydkouyyrog208m0e840o.gif)

### 用法

```
circleView = [[LBCircleView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    circleView.center = self.view.center;
    circleView.backgroundColor = [UIColor colorWithRed:255.0/255 green:157.0/255 blue:182.0/255 alpha:1.0];
    [self.view addSubview:circleView];
    circleView.percentColor = [UIColor colorWithRed:76.0/255 green:15.0/255 blue:77.0/255 alpha:1.0];
    [circleView setProgress:0.5 animated:YES];
```