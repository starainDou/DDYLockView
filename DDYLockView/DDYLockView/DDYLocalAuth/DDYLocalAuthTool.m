#import "DDYLocalAuthTool.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation DDYLocalAuthTool

+ (DDYLocalIDType)checkSupportLocalIDType {
    // iOS8+ 才开始支持TouchID iOS11+且iPhoneX系列才开始支持FaceID
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        return DDYLocalIDTypeNone;
    }
    LAContext *context = [[LAContext alloc] init];
    // canEvaluatePolicy 判断后 biometryType才会有效
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        if (@available(iOS 11.0, *)) {
            switch (context.biometryType) {
                case LABiometryTypeTouchID:
                    return DDYLocalIDTypeTouchID;
                    break;
                case LABiometryTypeFaceID:
                    return DDYLocalIDTypeFaceID;
                    break;
                default:
                    return DDYLocalIDTypeNone;
                    break;
            }
        }
        return DDYLocalIDTypeTouchID;
    }
    return DDYLocalIDTypeNone;
}

+ (void)verifyReply:(void (^)(DDYLocalAuthState))reply {
    void (^callback)(DDYLocalAuthState) = ^(DDYLocalAuthState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reply) reply(state);
        });
    };
    void (^handleResult)(BOOL, NSError*) = ^(BOOL success, NSError * _Nullable error) {
        if (success && !error) {
            callback(DDYLocalAuthStateSuccess);
        } else {
            if (@available(iOS 11.0, *)) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        callback(DDYLocalAuthStateFail);
                        break;
                    case LAErrorUserCancel:
                        callback(DDYLocalAuthStateUserCancel);
                        break;
                    case LAErrorUserFallback:
                        callback(DDYLocalAuthStateUserFallback);
                        break;
                    case LAErrorSystemCancel:
                        callback(DDYLocalAuthStateSystemCancel);
                        break;
                    case LAErrorPasscodeNotSet:
                        callback(DDYLocalAuthStatePasscodeNotSet);
                        break;
                    case LAErrorBiometryNotAvailable:
                        callback(DDYLocalAuthStateNotAvailable);
                        break;
                    case LAErrorBiometryNotEnrolled:
                        callback(DDYLocalAuthStateNotEnrolled);
                        break;
                    case LAErrorBiometryLockout:
                        callback(DDYLocalAuthStateLockout);
                        break;
                    case LAErrorAppCancel:
                        callback(DDYLocalAuthStateAppCancel);
                        break;
                    case LAErrorInvalidContext:
                        callback(DDYLocalAuthStateInvalidContext);
                        break;
                    case LAErrorNotInteractive:
                        callback(DDYLocalAuthStateNotInteractive);
                        break;
                    default:
                        break;
                }
            } else if (@available(iOS 9.0, *)) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        callback(DDYLocalAuthStateFail);
                        break;
                    case LAErrorUserCancel:
                        callback(DDYLocalAuthStateUserCancel);
                        break;
                    case LAErrorUserFallback:
                        callback(DDYLocalAuthStateUserFallback);
                        break;
                    case LAErrorSystemCancel:
                        callback(DDYLocalAuthStateSystemCancel);
                        break;
                    case LAErrorPasscodeNotSet:
                        callback(DDYLocalAuthStatePasscodeNotSet);
                        break;
                    case LAErrorTouchIDNotAvailable:
                        callback(DDYLocalAuthStateNotAvailable);
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        callback(DDYLocalAuthStateNotEnrolled);
                        break;
                    case LAErrorTouchIDLockout:
                        callback(DDYLocalAuthStateLockout);
                        break;
                    case LAErrorAppCancel:
                        callback(DDYLocalAuthStateAppCancel);
                        break;
                    case LAErrorInvalidContext:
                        callback(DDYLocalAuthStateInvalidContext);
                        break;
                    case LAErrorNotInteractive:
                        callback(DDYLocalAuthStateNotInteractive);
                        break;
                    default:
                        break;
                }
            } else {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        callback(DDYLocalAuthStateFail);
                        break;
                    case LAErrorUserCancel:
                        callback(DDYLocalAuthStateUserCancel);
                        break;
                    case LAErrorUserFallback:
                        callback(DDYLocalAuthStateUserFallback);
                        break;
                    case LAErrorSystemCancel:
                        callback(DDYLocalAuthStateSystemCancel);
                        break;
                    case LAErrorPasscodeNotSet:
                        callback(DDYLocalAuthStatePasscodeNotSet);
                        break;
                    case LAErrorTouchIDNotAvailable:
                        callback(DDYLocalAuthStateNotAvailable);
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        callback(DDYLocalAuthStateNotEnrolled);
                        break;
                    case LAErrorTouchIDLockout:
                        callback(DDYLocalAuthStateLockout);
                        break;
                    case LAErrorNotInteractive:
                        callback(DDYLocalAuthStateNotInteractive);
                        break;
                    default:
                        break;
                }
            }
        }
    };
    if ([DDYLocalAuthTool checkSupportLocalIDType] == DDYLocalIDTypeNone) {
        callback(DDYLocalAuthStateNotSupport);
        return;
    }
    
    NSString *titleTouchID = NSLocalizedStringFromTable(@"LocalizedReasonTouchID", @"DDYLocalAuth", nil);
    NSString *titleFaceID = NSLocalizedStringFromTable(@"LocalizedReasonFaceID", @"DDYLocalAuth", nil);
    NSString *TitleFallback = NSLocalizedStringFromTable(@"LocalizedFallbackTitle", @"DDYLocalAuth", nil);
    NSString *title = ([DDYLocalAuthTool checkSupportLocalIDType]==DDYLocalIDTypeFaceID) ? titleFaceID : titleTouchID;
    
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = TitleFallback;
    
    if (@available(iOS 9.0, *)) {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:nil]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:title reply:handleResult];
        } else {
            callback(DDYLocalAuthStateNotSupport);
        }
    } else {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:title reply:handleResult];
        } else {
            callback(DDYLocalAuthStateNotSupport);
        }
    }
}

+ (void)showDefaultAlertWithState:(DDYLocalAuthState)state {
    
}

@end

/** https://github.com/starainDou/DDYKnowledge/blob/master/Files/LocalAuthentication.md */
