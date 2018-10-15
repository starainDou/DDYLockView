#import "DDYGestureLockSettingVC.h"
#import "DDYGestureLockConfig.h"
#import "DDYGestureInfoView.h"
#import "DDYGestureLockView.h"
#import "Masonry.h"

@interface DDYGestureLockSettingVC ()

@property (nonatomic, strong) DDYGestureLockConfig *config;

@property (nonatomic, strong) DDYGestureInfoView *infoView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) DDYGestureLockView *lockView;

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

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setFont:[UIFont systemFontOfSize:14]];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipLabel setText:NSLocalizedStringFromTable(@"LockSettingDrawFirst", @"DDYGestureLock", nil)];
    }
    return _tipLabel;
}

- (DDYGestureLockView *)lockView {
    if (!_lockView) {
        _lockView = [[DDYGestureLockView alloc] initWithConfig:self.config];
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

@end
