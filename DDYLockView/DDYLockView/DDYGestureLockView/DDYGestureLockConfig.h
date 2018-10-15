#import <UIKit/UIKit.h>

static NSString *const lockOneKey  = @"lockOneKey"; // 第一个手势存储偏好设置key
static NSString *const lockEndKey  = @"lockEndKey"; // 最终手势存储偏好设置key

@interface DDYGestureLockConfig : NSObject
/** 整个手势锁背景颜色 默认白色 */
@property (nonatomic, strong) UIColor *backgroundColor;

/** 外空心圆普通状态背景颜色  */
@property (nonatomic, strong) UIColor *circleOutNormalBackColor;
/** 外空心圆选中状态背景颜色  */
@property (nonatomic, strong) UIColor *circleOutSelectedBackColor;
/** 外空心圆错误状态背景颜色  */
@property (nonatomic, strong) UIColor *circleOutErrorBackColor;

/** 外空心圆普通状态颜色 */
@property (nonatomic, strong) UIColor *circleOutNormalBorderColor;
/** 外空心圆选中状态颜色 */
@property (nonatomic, strong) UIColor *circleOutSelectedBorderColor;
/** 外空心圆错误状态颜色 */
@property (nonatomic, strong) UIColor *circleOutErrorBorderColor;

/** 内实心圆普通状态颜色 */
@property (nonatomic, strong) UIColor *circleInNormalColor;
/** 内实心圆选中状态颜色 */
@property (nonatomic, strong) UIColor *circleInSelectedColor;
/** 内实心圆错误状态颜色 */
@property (nonatomic, strong) UIColor *circleInErrorColor;

/** 指示三角形普通状态颜色 */
@property (nonatomic, strong) UIColor *trangleNormalColor;
/** 指示三角形选中状态颜色 */
@property (nonatomic, strong) UIColor *trangleSelectedColor;
/** 指示三角形错误状态颜色 */
@property (nonatomic, strong) UIColor *trangleErrorColor;

/** 连线选中状态颜色 */
@property (nonatomic, strong) UIColor *lineSelectedColor;
/** 连线错误状态颜色 */
@property (nonatomic, strong) UIColor *lineErrorColor;

/** 提示文字普通状态颜色 */
@property (nonatomic, strong) UIColor *textNormalColor;
/** 提示文字错误状态颜色 */
@property (nonatomic, strong) UIColor *textErrorColor;

/** 外空心圆半径 默认30 */
@property (nonatomic, assign) CGFloat circleOutRadius;
/** 外空心圆边宽 默认1 */
@property (nonatomic, assign) CGFloat circleOutBorderWidth;
/** 内实心圆占比 默认0.4 */
@property (nonatomic, assign) CGFloat circleInRadio;
/** 指示三角形边长 默认10 */
@property (nonatomic, assign) CGFloat trangleLength;
/** 连线宽度 默认1.5 */
@property (nonatomic, assign) CGFloat lineWidth;
/** 最少连接圆的个数 默认4 */
@property (nonatomic, assign) NSUInteger circleLeastNumber;
/** 错误状态回显时间 默认1s */
@property (nonatomic, assign) CGFloat displayTime;
/** 头部信息视图圆半径 默认5 */
@property (nonatomic, assign) CGFloat circleInfoRadius;
/** 解锁界面左右边距 默认30 */
@property (nonatomic, assign) CGFloat lockViewMargin;
/** 是否带有箭头 默认有 */
@property (nonatomic, assign) BOOL isArrow;

+ (instancetype)config;

@end



