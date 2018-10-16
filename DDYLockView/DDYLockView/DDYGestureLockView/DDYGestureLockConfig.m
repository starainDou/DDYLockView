#import "DDYGestureLockConfig.h"

static inline UIColor *lockViewRGBA(float r, float g, float b, float a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}
#define DDYRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@implementation DDYGestureLockConfig

+ (instancetype)config {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = lockViewRGBA(255., 255., 255., 1);
        
        self.circleOutNormalBackColor = [UIColor clearColor];
        self.circleOutSelectedBackColor = lockViewRGBA(35., 180., 250., 0.5);
        self.circleOutErrorBackColor = lockViewRGBA(250., 80., 90., 0.5);
        
        self.circleOutNormalBorderColor = lockViewRGBA(150., 150., 150., 1);
        self.circleOutSelectedBorderColor = lockViewRGBA(35., 180., 250., 1);
        self.circleOutErrorBorderColor = lockViewRGBA(250., 80., 90., 1);
        
        self.circleInNormalColor = [UIColor clearColor];
        self.circleInSelectedColor = lockViewRGBA(35., 180., 250., 1);
        self.circleInErrorColor = lockViewRGBA(250., 80., 90., 1);
        
        self.trangleNormalColor = [UIColor clearColor];
        self.trangleSelectedColor = lockViewRGBA(35., 180., 250., 1);
        self.trangleErrorColor = lockViewRGBA(250., 80., 90., 1);
        
        self.lineSelectedColor = lockViewRGBA(35., 180., 250., 1);
        self.lineErrorColor = lockViewRGBA(250., 80., 90., 1);
        
        self.textNormalColor = lockViewRGBA(150., 150., 150., 1);
        self.textErrorColor = lockViewRGBA(250., 80., 90., 1);
        
        self.circleOutRadius = 30.;
        self.circleOutBorderWidth = 1.;
        self.circleInRadio = 0.4;
        self.trangleLength = 10;
        self.lineWidth = 1.5;
        self.circleLeastNumber = 4;
        self.displayTime = 1.;
        self.circleInfoRadius = 5.;
        self.lockViewMargin = 30.;
        self.isArrow = YES;
    }
    return self;
}

@end
