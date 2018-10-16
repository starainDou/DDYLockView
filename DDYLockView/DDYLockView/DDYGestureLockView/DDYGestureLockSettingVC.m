#import "DDYGestureLockSettingVC.h"
#import "DDYGestureLockConfig.h"
#import "DDYGestureInfoView.h"
#import "DDYGestureLockLabel.h"
#import "DDYGestureLockView.h"
#import "Masonry.h"

@interface DDYGestureLockSettingVC ()

@property (nonatomic, strong) DDYGestureLockConfig *config;

@property (nonatomic, strong) DDYGestureInfoView *infoView;

@property (nonatomic, strong) DDYGestureLockLabel *tipLabel;

@property (nonatomic, strong) DDYGestureLockView *lockView;

@property (nonatomic, strong) NSString *firstSelectedValue;

@end

@implementation DDYGestureLockSettingVC

- (DDYGestureLockConfig *)config {
    if (!_config) {
        _config = [DDYGestureLockConfig config];
    }
    return _config;
}

- (DDYGestureInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[DDYGestureInfoView alloc] initWithConfig:self.config];
    }
    return _infoView;
}

- (DDYGestureLockLabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[DDYGestureLockLabel alloc] initWithConfig:self.config];
        _tipLabel.text = NSLocalizedStringFromTable(@"LockSettingDrawFirst", @"DDYGestureLock", nil);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:self.config.backgroundColor];
    [self.view addSubview:self.infoView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.lockView];
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
        make.width.height.mas_equalTo(36);
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
}

- (void)handleGesture:(NSArray<DDYGestureCircle *> *)seletedArray selectedValue:(NSString *)selectedValue {
    if (selectedValue.length < self.config.circleLeastNumber) {
        [self.tipLabel showWarningAndShakeMessage:NSLocalizedStringFromTable(@"LockSettingDrawLessTip", @"DDYGestureLock", nil)];
    } else if (self.firstSelectedValue.length < self.config.circleLeastNumber) {
        self.firstSelectedValue = selectedValue;
        [self.tipLabel showNormalMessage:NSLocalizedStringFromTable(@"LockSettingDrawAgain", @"DDYGestureLock", nil)];
    } else if ([selectedValue isEqualToString:self.firstSelectedValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:selectedValue forKey:lockEndKey];
        [self.tipLabel showNormalMessage:NSLocalizedStringFromTable(@"LockSettingSuccess", @"DDYGestureLock", nil)];
        self.lockView.userInteractionEnabled = NO;
        self.firstSelectedValue = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } else {
        self.firstSelectedValue = nil;
        [self.tipLabel showWarningAndShakeMessage:NSLocalizedStringFromTable(@"LockSettingDifferent", @"DDYGestureLock", nil)];
    }
}

@end
