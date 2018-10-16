#import "DDYGestureLockLoginVC.h"
#import "DDYGestureLockConfig.h"
#import "DDYGestureLockLabel.h"
#import "DDYGestureLockView.h"
#import "DDYLocalAuthTool.h"
#import "Masonry.h"

@interface DDYGestureLockLoginVC ()

@property (nonatomic, strong) DDYGestureLockConfig *config;

@property (nonatomic, strong) UIImageView *infoView;

@property (nonatomic, strong) DDYGestureLockLabel *tipLabel;

@property (nonatomic, strong) DDYGestureLockView *lockView;

@property (nonatomic, strong) UIButton *forgetButton;

@property (nonatomic, strong) UIButton *touchIDButton;

@property (nonatomic, strong) NSString *firstSelectedValue;

@end

@implementation DDYGestureLockLoginVC

- (DDYGestureLockConfig *)config {
    if (!_config) {
        _config = [DDYGestureLockConfig config];
    }
    return _config;
}

- (UIImageView *)infoView {
    if (!_infoView) {
        _infoView = [[UIImageView alloc] init];
        _infoView.backgroundColor = [UIColor redColor];
    }
    return _infoView;
}

- (DDYGestureLockLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[DDYGestureLockLabel alloc] initWithConfig:self.config];
        _tipLabel.text = NSLocalizedStringFromTable(@"LockLoginDraw", @"DDYGestureLock", nil);
    }
    return _tipLabel;
}

- (DDYGestureLockView *)lockView {
    if (!_lockView) {
        _lockView = [[DDYGestureLockView alloc] initWithConfig:self.config];
        __weak __typeof (self)weakSelf = self;
        [_lockView setGestureBlock:^(NSArray<DDYGestureCircle *> *seletedArray, NSString *selectedValue) {
            [weakSelf handleGesture:seletedArray selectedValue:selectedValue];
        }];
    }
    return _lockView;
}

- (UIButton *)forgetButton {
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetButton setTitle:NSLocalizedStringFromTable(@"LockLoginForget", @"DDYGestureLock", nil) forState:UIControlStateNormal];
        [_forgetButton setTitleColor:self.config.circleOutNormalBorderColor forState:UIControlStateNormal];
        [_forgetButton addTarget:self action:@selector(handleForget:) forControlEvents:UIControlEventTouchUpInside];
        [_forgetButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    }
    return _forgetButton;
}

- (UIButton *)touchIDButton {
    if (!_touchIDButton) {
        _touchIDButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchIDButton setTitleColor:self.config.circleOutNormalBorderColor forState:UIControlStateNormal];
        [_touchIDButton addTarget:self action:@selector(handleTouchID:) forControlEvents:UIControlEventTouchUpInside];
        [_touchIDButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        DDYLocalIDType supportType = [DDYLocalAuthTool checkSupportLocalIDType];
        if (supportType == DDYLocalIDTypeNone) {
            _touchIDButton.hidden = YES;
        } else if (supportType == DDYLocalIDTypeTouchID) {
            [_touchIDButton setTitle:NSLocalizedStringFromTable(@"LockLoginTouchID", @"DDYGestureLock", nil) forState:UIControlStateNormal];
        } else if (supportType == DDYLocalIDTypeFaceID) {
            [_touchIDButton setTitle:NSLocalizedStringFromTable(@"LockLoginTouchID", @"DDYGestureLock", nil) forState:UIControlStateNormal];
        }
    }
    return _touchIDButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:self.config.backgroundColor];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.lockView];
    [self.view addSubview:self.forgetButton];
    [self.view addSubview:self.touchIDButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.infoView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(40);
        } else {
            make.top.equalTo(self.mas_topLayoutGuideBottom).offset(40);
        }
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(60);
    }];
    [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [self.lockView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(self.config.lockViewMargin);
        make.right.mas_equalTo(self.view.mas_right).offset(-self.config.lockViewMargin);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(25);
        make.height.mas_equalTo(self.lockView.mas_width).multipliedBy(1);
    }];
    [self.forgetButton mas_updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.mas_bottomLayoutGuideTop).offset(-10);
        }
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
    [self.touchIDButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.forgetButton.mas_bottom);
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
    }];
}

- (void)handleGesture:(NSArray<DDYGestureCircle *> *)seletedArray selectedValue:(NSString *)selectedValue {
    if ([selectedValue isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:lockEndKey]]) {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    } else {
        [self.tipLabel showWarningAndShakeMessage:NSLocalizedStringFromTable(@"LockLoginError", @"DDYGestureLock", nil)];
    }
}

- (void)handleForget:(UIButton *)button {
    NSLog(@"点击忘记密码");
}

- (void)handleTouchID:(UIButton *)button {
    [DDYLocalAuthTool verifyReply:^(DDYLocalAuthState state) {
        
        switch (state) {
            case DDYLocalAuthStateSuccess:
                [self dismissViewControllerAnimated:YES completion:^{ }];
                break;
            case DDYLocalAuthStateFail:
                NSLog(@"验证失败");
                break;
            case DDYLocalAuthStatePasscodeNotSet:
                NSLog(@"用户没有设置密码");
                break;
            case DDYLocalAuthStateNotEnrolled:
                NSLog(@"设置了密码但没设置LocalID");
                break;
            case DDYLocalAuthStateLockout:
                NSLog(@"iOS8重启才能恢复使用,iOS9+停用指定时间后输入密码");
                break;
            default:
                NSLog(@"其他原因的无法完成验证，看枚举解释 state:%ld", state);
                break;
        }
    }];
}

@end
