#import "DDYGestureCircle.h"

@interface DDYGestureCircle ()

@property DDYGestureLockConfig *config;

@end

@implementation DDYGestureCircle

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.backgroundColor = self.config.circleOutNormalBackColor;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 上下文旋转
    [self tansformCtx:ctx rect:rect];
    // 画外空心圆
    [self drawOutCircleWithCtx:ctx rect:rect];
    // 画内实心圆
    [self drawInCircleWithCtx:ctx rect:rect];
    // 画三角形
    [self drawTrangleWithCtx:ctx rect:rect];
}

#pragma mark 上下文旋转
- (void)tansformCtx:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat translateXY = rect.size.width*.5f;
    CGContextTranslateCTM(ctx, translateXY, translateXY);
    CGContextRotateCTM(ctx, self.angle);
    CGContextTranslateCTM(ctx, -translateXY, -translateXY);
}

#pragma mark 画外空心圆
- (void)drawOutCircleWithCtx:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat borderW = self.config.circleOutBorderWidth;
    CGRect circleRect = CGRectMake(borderW, borderW, rect.size.width-borderW*2, rect.size.height-borderW*2);
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, circleRect);
    CGContextAddPath(ctx, circlePath);
    [[self outCircleColor] set];
    CGContextSetLineWidth(ctx, borderW);
    CGContextStrokePath(ctx);
    CGPathRelease(circlePath);
}

#pragma mark 画内实心圆
- (void)drawInCircleWithCtx:(CGContextRef)ctx rect:(CGRect)rect {
    CGFloat radio = (self.type == DDYGestureCircleTypeGesture) ? self.config.circleInRadio : 1;
    CGFloat circleX = rect.size.width/2 * (1-radio) + self.config.circleOutBorderWidth;
    CGFloat circleY = rect.size.height/2 * (1-radio) + self.config.circleOutBorderWidth;
    CGFloat circleW = rect.size.width*radio - self.config.circleOutBorderWidth*2;
    CGFloat circleH = rect.size.height*radio - self.config.circleOutBorderWidth*2;
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddEllipseInRect(circlePath, NULL, CGRectMake(circleX, circleY, circleW, circleH));
    [[self inCircleColor] set];
    CGContextAddPath(ctx, circlePath);
    CGContextFillPath(ctx);
    CGPathRelease(circlePath);
}

#pragma mark 画三角形
- (void)drawTrangleWithCtx:(CGContextRef)ctx rect:(CGRect)rect {
    if (self.config.isArrow) {
        CGPoint topPoint = CGPointMake(rect.size.width/2, 10);
        CGMutablePathRef trianglePath = CGPathCreateMutable();
        CGPathMoveToPoint(trianglePath, NULL, topPoint.x, topPoint.y);
        CGPathAddLineToPoint(trianglePath, NULL, topPoint.x - self.config.trangleLength/2, topPoint.y + self.config.trangleLength/2);
        CGPathAddLineToPoint(trianglePath, NULL, topPoint.x + self.config.trangleLength/2, topPoint.y + self.config.trangleLength/2);
        CGContextAddPath(ctx, trianglePath);
        [[self trangleColor] set];
        CGContextFillPath(ctx);
        CGPathRelease(trianglePath);
    }
}

#pragma mark 外圆颜色
- (UIColor *)outCircleColor {
    UIColor *color;
    switch (self.state) {
        case DDYGestureCircleStateNormal:
            color = self.config.circleOutNormalBorderColor;
            break;
        case DDYGestureCircleStateSelected:
            color = self.config.circleOutSelectedBorderColor;
            break;
        case DDYGestureCircleStateError:
            color = self.config.circleOutErrorBorderColor;
            break;
    }
    return color;
}

#pragma mark 内圆颜色
- (UIColor *)inCircleColor {
    UIColor *color;
    switch (self.state) {
        case DDYGestureCircleStateNormal:
            color = self.config.circleInNormalColor;
            break;
        case DDYGestureCircleStateSelected:
            color = self.config.circleInSelectedColor;
            break;
        case DDYGestureCircleStateError:
            color = self.config.circleInErrorColor;
            break;
    }
    return color;
}

#pragma mark 三角颜色
- (UIColor *)trangleColor {
    UIColor *color;
    switch (self.state) {
        case DDYGestureCircleStateNormal:
            color = self.config.trangleNormalColor;
            break;
        case DDYGestureCircleStateSelected:
            color = self.config.trangleSelectedColor;
            break;
        case DDYGestureCircleStateError:
         
            color = self.config.trangleErrorColor;
            break;
    }
    return color;
}

#pragma mark 角度set方法
- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    [self setNeedsDisplay];
}

#pragma mark 状态set方法
- (void)setState:(DDYGestureCircleState)state {
    _state = state;
    [self setNeedsDisplay];
}

@end
