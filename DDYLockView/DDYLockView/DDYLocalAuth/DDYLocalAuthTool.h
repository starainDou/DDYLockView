#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DDYLocalIDType) {
    DDYLocalIDTypeNone = 0, // 不支持生物识别
    DDYLocalIDTypeTouchID,  // 支持TouchID指纹识别
    DDYLocalIDTypeFaceID,   // 支持FaceID面容识别
};

typedef NS_ENUM(NSUInteger, DDYLocalAuthState) {
    DDYLocalAuthStateNotSupport = 0,  // LocalID 验证不被该设备支持
    DDYLocalAuthStateSuccess,         // LocalID 验证成功
    DDYLocalAuthStateFail,            // LocalID 验证失败
    DDYLocalAuthStateUserCancel,      // LocalID 验证被用户手动取消
    DDYLocalAuthStateUserFallback,    // LocalID 验证不被使用(用户选择输入密码验证)
    DDYLocalAuthStateSystemCancel,    // LocalID 验证被系统取消(其他应用进入前台,如通知、来电等)
    DDYLocalAuthStatePasscodeNotSet,  // LocalID 验证无法启动(用户没有设置密码)
    DDYLocalAuthStateNotAvailable,    // LocalID 验证无法启动(硬件损坏等)
    DDYLocalAuthStateNotEnrolled,     // LocalID 验证无法启动(设置了密码但没设置LocalID)
    DDYLocalAuthStateLockout,         // LocalID 验证连续失败被系统锁定(iOS8重启才能恢复使用,iOS9+停用指定时间后输入密码)
    DDYLocalAuthStateAppCancel,       // LocalID 验证被应用取消(锁屏、按Home键等)
    DDYLocalAuthStateInvalidContext,  // LocalID 验证无法启动(LAContext对象无效)
    DDYLocalAuthStateNotInteractive,  // LocalID 验证无法启动(尝试启动时应用未变为活跃状态)
};

@interface DDYLocalAuthTool : NSObject

+ (DDYLocalIDType)checkSupportLocalIDType;

+ (void)verifyReply:(void(^)(DDYLocalAuthState state))reply;

+ (void)showDefaultAlertWithState:(DDYLocalAuthState)state;

@end

/** https://github.com/starainDou/DDYKnowledge/blob/master/Files/LocalAuthentication.md */
