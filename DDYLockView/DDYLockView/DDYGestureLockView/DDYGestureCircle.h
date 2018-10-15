#import <UIKit/UIKit.h>
#import "DDYGestureLockConfig.h"

/** 圆的状态 */
typedef NS_ENUM(NSInteger, DDYGestureCircleState) {
    DDYGestureCircleStateNormal             = 0,
    DDYGestureCircleStateSelected           = 1,
    DDYGestureCircleStateError              = 2,
};

@interface DDYGestureCircle : UIView

/** 所处状态 */
@property (nonatomic, assign) DDYGestureCircleState state;
/** 角度 */
@property (nonatomic, assign) CGFloat angle;
/** 初始化 */
- (instancetype)initWithConfig:(DDYGestureLockConfig *)config;

@end
