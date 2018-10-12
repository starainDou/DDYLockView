#import "ViewController.h"

#ifndef DDYTopH
#define DDYTopH (self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef DDYScreenW
#define DDYScreenW [UIScreen mainScreen].bounds.size.width
#endif

#ifndef DDYScreenH
#define DDYScreenH [UIScreen mainScreen].bounds.size.height
#endif

@interface ViewController ()

@property (nonatomic, strong) UIButton *button1;

@property (nonatomic, strong) UIButton *button2;

@property (nonatomic, strong) UIButton *button3;

@end

@implementation ViewController

- (UIButton *)btnY:(CGFloat)y tag:(NSUInteger)tag title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    [button setFrame:CGRectMake(10, DDYTopH + y, DDYScreenW-20, 40)];
    [button setTag:tag];
    [button addTarget:self action:@selector(handleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (UIButton *)button1 {
    if (!_button1) {
        _button1 = [self btnY: 50 tag:100 title:@"手势锁设置"];
    }
    return _button1;
}

- (UIButton *)button2 {
    if (!_button2) {
        _button2 = [self btnY:100 tag:101 title:@"手势锁验证"];
    }
    return _button2;
}

- (UIButton *)button3 {
    if (!_button3) {
        _button3 = [self btnY:150 tag:102 title:@"手势锁登录"];
    }
    return _button3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.button1];
    [self.view addSubview:self.button2];
    [self.view addSubview:self.button3];
}

- (void)handleBtn:(UIButton *)sender {
    if (sender.tag == 100) {
        
    } else if (sender.tag == 101) {
        
    } else if (sender.tag == 102) {
        [self changeLanguage];
    }
}



- (void)changeLanguage {
    
}

@end
