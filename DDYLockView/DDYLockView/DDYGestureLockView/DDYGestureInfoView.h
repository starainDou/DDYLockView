#import <UIKit/UIKit.h>
#import "DDYGestureLockConfig.h"
#import "DDYGestureCircle.h"

@interface DDYGestureInfoView : UIView

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config;

- (void)changeCirclesWithSelectedArray:(NSArray <DDYGestureCircle *>*)selectedArray;

@end
