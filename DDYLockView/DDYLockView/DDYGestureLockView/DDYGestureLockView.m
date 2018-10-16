#import "DDYGestureLockView.h"

@interface DDYGestureLockView ()

@property DDYGestureLockConfig *config;
/** 当前点位 */
@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, strong) NSMutableArray <DDYGestureCircle *>* selectedArray;

@end

@implementation DDYGestureLockView

- (NSMutableArray<DDYGestureCircle *> *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config {
    if (self = [super init]) {
        [self setConfig:config];
        [self setBackgroundColor:self.config.backgroundColor];
        [self addCircleView];
    }
    return self;
}

- (void)addCircleView {
    for (int i = 0; i < 9; i++) {
        DDYGestureCircle *circle = [[DDYGestureCircle alloc] initWithConfig:self.config];
        circle.tag = i + 1;
        [self addSubview:circle];
    }
}

#pragma mark 布局子控件
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemViewWH = self.config.circleOutRadius * 2;
    CGFloat itemMargin = (self.bounds.size.width - 3*itemViewWH) / 3.f;
    // 九宫格
    [self.subviews enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx % 3;
        NSUInteger col = idx / 3;
        CGFloat x = itemMargin*row + row*itemViewWH + itemMargin/2;
        CGFloat y = itemMargin*col + col*itemViewWH + itemMargin/2;
        circle.tag = idx + 1;
        circle.frame = CGRectMake(x, y, itemViewWH, itemViewWH);
    }];
}

#pragma mark - touch began / touch moved / touch end
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self resetGesture]; // 每次开始先手势重置
    [self setCurrentPoint:CGPointZero];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.subviews enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            circle.state = DDYGestureCircleStateSelected;
            [self.selectedArray addObject:circle];
        }
    }];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setCurrentPoint:CGPointZero];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.subviews enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(circle.frame, point)) {
            if (![self.selectedArray containsObject:circle]) {
                circle.state = DDYGestureCircleStateSelected;
                [self.selectedArray addObject:circle];
                // move过程中连线(包含跳跃连线的处理)
                [self calculateAngleAndConnectJumpedCircle];
            }
        } else {
            self.currentPoint = point;
        }
    }];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.selectedArray.count && self.gestureBlock) {
        NSMutableString *gestureStr = [NSMutableString string];
        for (DDYGestureCircle *circle in self.selectedArray) {
            [gestureStr appendFormat:@"%@", @(circle.tag)];
        }
        self.gestureBlock(self.selectedArray, gestureStr);
    }
    // 重置
    if ([self.selectedArray firstObject].state == DDYGestureCircleStateError) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.config.displayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resetGesture];
        });
    } else {
        [self resetGesture];
    }
}

#pragma mark - 私有操作方法
#pragma mark 手势清空重置操作
- (void)resetGesture {
    @synchronized (self) {
        // 手势完毕,选中的圆回归普通状态
        [self changeCirclesWithSate:DDYGestureCircleStateNormal];
        // 清空保存选中的数组
        [self.selectedArray removeAllObjects];
    }
}

#pragma mark 改变选中数组子控件状态
- (void)changeCirclesWithSate:(DDYGestureCircleState)state {
    [self.selectedArray enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
        circle.state = state;
        if (state == DDYGestureCircleStateNormal) circle.angle = 0; // 清空方向
    }];
    [self setNeedsDisplay];
}

#pragma mark 每添加一个圆计算一次方向,同时处理跳跃连线
- (void)calculateAngleAndConnectJumpedCircle {
    if (self.selectedArray && self.selectedArray.count>1) {
        // 最后一个对象
        DDYGestureCircle *last1 = [self.selectedArray lastObject];
        // 倒数第二个对象
        DDYGestureCircle *last2 = self.selectedArray[self.selectedArray.count-2];
        // 计算角度(反正切)
        last2.angle = atan2(last1.center.y-last2.center.y, last1.center.x-last2.center.x) + M_PI_2;
        // 跳跃连线问题
        DDYGestureCircle *jumpedCircle = [self selectedCircleContainPoint:[self centerPointWithPoint1:last1.center point2:last2.center]];
        if (jumpedCircle && ![self.selectedArray containsObject:jumpedCircle]) {
            // 把跳跃的圆添加到已选择圆的数组(插入到倒数第二个)
            [self.selectedArray insertObject:jumpedCircle atIndex:self.selectedArray.count-1];
        }
    }
}

#pragma mark 提供两个点返回他们中点
- (CGPoint)centerPointWithPoint1:(CGPoint)point1 point2:(CGPoint)point2 {
    CGFloat x1 = fmax(point1.x, point2.x);
    CGFloat x2 = fmin(point1.x, point2.x);
    CGFloat y1 = fmax(point1.y, point2.y);
    CGFloat y2 = fmin(point1.y, point2.y);
    return CGPointMake((x1+x2)/2, (y1+y2)/2);
}

#pragma mark 判断点是否被圆包含(包含返回圆否则返回nil)
- (DDYGestureCircle *)selectedCircleContainPoint:(CGPoint)point {
    DDYGestureCircle *centerCircle = nil;
    for (DDYGestureCircle *circle in self.subviews) {
        if (CGRectContainsPoint(circle.frame, point)) {
            centerCircle = circle;
        }
    }
    if (centerCircle && ![self.selectedArray containsObject:centerCircle]) {
        // 跳跃的点角度和已选择的倒数第二个角度一致
        centerCircle.angle = [self.selectedArray[self.selectedArray.count-2] angle];
    }
    return centerCircle;
}

- (void)drawRect:(CGRect)rect {
    // 没有任何选中则return
    if (self.selectedArray.count) {
        DDYGestureCircleState tempState = [self.selectedArray firstObject].state;
        UIColor *lineColor = tempState==DDYGestureCircleStateError ? self.config.lineErrorColor : self.config.lineSelectedColor;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextAddRect(ctx, rect);
        [self.subviews enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
            CGContextAddEllipseInRect(ctx, circle.frame);
        }];
        CGContextEOClip(ctx);
        
        for (int i = 0; i<self.selectedArray.count; i++) {
            DDYGestureCircle *circle = self.selectedArray[i];
            i==0 ? CGContextMoveToPoint(ctx, circle.center.x, circle.center.y) : CGContextAddLineToPoint(ctx, circle.center.x, circle.center.y);
        }
        
        // 连接最后一个按钮到手指当前触摸点
        if (!CGPointEqualToPoint(self.currentPoint, CGPointZero)) {
            [self.subviews enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
                if (tempState==DDYGestureCircleStateError) {
                    // 错误状态下不连接到当前点
                } else {
                    CGContextAddLineToPoint(ctx, self.currentPoint.x, self.currentPoint.y);
                }
            }];
        }
        
        CGContextSetLineCap(ctx, kCGLineCapRound);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextSetLineWidth(ctx, self.config.lineWidth);
        [lineColor set];
        CGContextStrokePath(ctx);
    }
}

@end
