#import <UIKit/UIKit.h>
#import "DDYGestureLockConfig.h"
#import "DDYGestureCircle.h"

@interface DDYGestureLockView : UIView

@property (nonatomic, copy) void (^gestureBlock)(NSArray <DDYGestureCircle *>*seletedArray, NSString *selectedValue);

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config;

/** 改变选中数组子控件状态 */
- (void)changeCirclesWithSate:(DDYGestureCircleState)state;

@end
