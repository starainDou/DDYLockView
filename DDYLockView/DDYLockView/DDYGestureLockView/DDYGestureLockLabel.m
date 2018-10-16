#import "DDYGestureLockLabel.h"

@interface DDYGestureLockLabel ()

@property (nonatomic, strong) DDYGestureLockConfig *config;

@end

@implementation DDYGestureLockLabel

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config {
    if (self = [super init]) {
        self.config = config;
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

#pragma mark - tipLabel不同提示
#pragma mark 普通提示
- (void)showNormalMessage:(NSString *)message {
    self.text = message;
    self.textColor = self.config.textNormalColor;
}

#pragma mark 摇动警示
- (void)showWarningAndShakeMessage:(NSString *)message {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.values = @[@(-5),@(0),@(5),@(0),@(-5),@(0),@(5),@(0)];
    animation.duration = 0.3f;
    animation.repeatCount = 2;
    animation.removedOnCompletion = YES;
    [self setText:message];
    [self setTextColor:self.config.textErrorColor];
    [self.layer addAnimation:animation forKey:@"shake"];
}

@end
