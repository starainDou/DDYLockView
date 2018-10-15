#import <UIKit/UIKit.h>
#import "DDYGestureLockConfig.h"
#import "DDYGestureCircle.h"

@interface DDYGestureLockView : UIView

@property (nonatomic, copy) void (^gestureBlock)(NSArray <DDYGestureCircle *>*seletedArray);

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config;

@end
