#import "DDYGestureInfoView.h"
#import "DDYGestureCircle.h"

@interface DDYGestureInfoView ()

@property DDYGestureLockConfig *config;

@end

@implementation DDYGestureInfoView

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

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat itemViewWH = self.config.circleInfoRadius * 2;
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

@end
