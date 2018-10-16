#import <UIKit/UIKit.h>
#import "DDYGestureLockConfig.h"

@interface DDYGestureLockLabel : UILabel

- (instancetype)initWithConfig:(DDYGestureLockConfig *)config;

/** 普通提示 */
- (void)showNormalMessage:(NSString *)message;

/** 摇动警示 */
- (void)showWarningAndShakeMessage:(NSString *)message;

@end
