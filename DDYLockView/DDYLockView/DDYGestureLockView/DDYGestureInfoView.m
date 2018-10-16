#import "DDYGestureInfoView.h"

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
        circle.type = DDYGestureCircleTypeInfo;
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

- (void)changeCirclesWithSelectedArray:(NSArray *)selectedArray {
    if (!selectedArray || !selectedArray.count) {
        [self.subviews enumerateObjectsUsingBlock:^(DDYGestureCircle *circle, NSUInteger idx, BOOL *stop) {
            circle.state = DDYGestureCircleStateNormal;
        }];
        return;
    }
    for (DDYGestureCircle *selectedCircle in selectedArray) {
        for (DDYGestureCircle *infoCircle in self.subviews) {
            if (infoCircle.tag == selectedCircle.tag) {
                infoCircle.state = DDYGestureCircleStateSelected;
            }
        }
    }
}

@end
