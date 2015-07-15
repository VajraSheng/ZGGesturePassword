//
//  ZGLockViewController.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGLockViewController.h"
#import "ZGLabel.h"
#import "ZGInfoView.h"

@interface ZGLockViewController () <ZGLockViewDelegate>
@property (weak, nonatomic) IBOutlet ZGLockView *lockView;
@property (weak, nonatomic) IBOutlet ZGLabel *label;
@property (weak, nonatomic) IBOutlet ZGInfoView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

@property (nonatomic,strong) UIBarButtonItem *resetItem;

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(ZGLockViewController *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@end

@implementation ZGLockViewController

//After twice input different show the reset button ,reset the first password
- (UIBarButtonItem *)resetItem
{
    if (_resetItem == nil) {
        _resetItem = [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(resetPwd)];
    }
    return _resetItem;
}

//是否显示验证密码轨迹
+ (BOOL)allowShowLineTrail
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZGAllowVerifyLineTrail];
}

//重设设置密码时的第一次密码，即重新设置密码
- (void)resetPwd
{
    [self.label showNormalMsg:kZGSetPwdFirstTitle];
    self.navigationItem.rightBarButtonItem = nil;
    [self.lockView resetPwd];
    self.infoView.temporaryPwd = nil;
}

//判断是否已经设置过密码
+ (BOOL)hasPassword
{
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:kZGPasswordKey];
    return password != nil;
}
//调整初始label文字以及指示图和忘记密码按钮的显隐
- (void)initialLabel
{
    switch (_type) {
        case ZGLockTypeSetPwd:
            [self.label showNormalMsg:kZGSetPwdFirstTitle];
            self.infoView.hidden = NO;
            self.forgetButton.hidden = YES;
            break;
        case ZGLockTypeModifyPwd:
            [self.label showNormalMsg:kZGModifyPwdNormalTitle];
            self.infoView.hidden = YES;
            self.forgetButton.hidden = YES;
            break;
        case ZGLockTypeVerifyPwd:
            [self.label showNormalMsg:kZGVerifyPwdNormalTitle];
            self.infoView.hidden = YES;
            self.forgetButton.hidden = NO;
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lockView.delegate = self;
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.lockView.type = _type;
    [self initialLabel];
}

#pragma mark - Instant methods
+ (instancetype)lockVC:(UIViewController *)vc
{
    ZGLockViewController *lockVC = [[UIStoryboard storyboardWithName:@"LockVC" bundle:nil] instantiateViewControllerWithIdentifier:@"LockVC"];
    if (vc.navigationController) {
        [vc.navigationController pushViewController:lockVC animated:YES];
    }else{
        [vc presentViewController:lockVC animated:YES completion:nil];
    }
    
    return lockVC;
}

//展示设置密码控制器
+ (instancetype)showSetPwdViewControllerOnVC:(UIViewController *)vc successBlock:(void (^)(ZGLockViewController *, NSString *))successBlock
{
    ZGLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"设置密码";
    lockVC.type = ZGLockTypeSetPwd;
    lockVC.successBlock = successBlock;
    return lockVC;
}

//展示验证密码控制器
+ (instancetype)showVerifyPwdViewControllerOnVC:(UIViewController *)vc forgetPwdBlock:(void (^)())forgetPwdBlock successBlock:(void (^)(ZGLockViewController *, NSString *))successBlock
{
    ZGLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"验证密码";
    lockVC.type = ZGLockTypeVerifyPwd;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    lockVC.successBlock = successBlock;
    return lockVC;
}

//展示修改密码控制器
+ (instancetype)showModifyPwdViewControllerOnVC:(UIViewController *)vc successBlock:(void (^)(ZGLockViewController *, NSString *))successBlock
{
    ZGLockViewController *lockVC = [self lockVC:vc];
    lockVC.title = @"修改密码";
    lockVC.type = ZGLockTypeModifyPwd;
    lockVC.successBlock = successBlock;
    return lockVC;
}

//展示关闭密码控制器
+ (instancetype)showClosePwdViewControllerOnVC:(UIViewController *)vc
{
    return [self showVerifyPwdViewControllerOnVC:vc
                                  forgetPwdBlock:^{}
                                    successBlock:^(ZGLockViewController *lockVC, NSString *pwd) {
                                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZGPasswordKey];
                                        [lockVC dismiss:0];
                                    }];
}

//是否显示密码轨迹
+ (void)showLineTrail:(BOOL)show
{
    
}

#pragma mark - Lock view delegate methods

- (void)setPwdFirstRight:(NSString *)firstRightPwd
{
    [self.label showNormalMsg:kZGSetPwdConfirmTitle];
    self.infoView.temporaryPwd = firstRightPwd;
}

- (void)setPwdTooShortError
{
    [self.label showWarningMsg:[NSString stringWithFormat:@"至少需要%@个点，请重新绘制",@(kZGMinCircleNum)]];
}

- (void)setPwdTwiceDifferentWithFirst:(NSString *)firstPwd andSecond:(NSString *)secondPwd
{
    [self.label showWarningMsg:kZGSetPwdTwiceDifferentTitle];
    self.navigationItem.rightBarButtonItem = self.resetItem;
}

- (void)setPwdTwiceSameWithPwd:(NSString *)pwd
{
    [self.label showNormalMsg:kZGSetPwdTwiceSameTitle];
    [[NSUserDefaults standardUserDefaults] setValue:pwd forKey:kZGPasswordKey];
    self.view.userInteractionEnabled = NO;
    if (_successBlock != nil) {
        _successBlock(self,pwd);
    }
    if(ZGLockTypeModifyPwd == _type){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

- (BOOL)verifyPwdResult:(NSString *)pwd
{
    NSString *localPwd = [[NSUserDefaults standardUserDefaults] stringForKey:kZGPasswordKey];
    BOOL result = [localPwd isEqualToString:pwd];
    if (result) {
        [self.label showNormalMsg:kZGVerifyPwdSuccessedTitle];
        if (_type == ZGLockTypeVerifyPwd) {
            self.view.userInteractionEnabled = NO;
            if (_successBlock != nil) {
                _successBlock(self,pwd);
            }
        }else if (_type == ZGLockTypeModifyPwd) {
            [self.label showNormalMsg:kZGSetPwdFirstTitle];
            self.infoView.hidden = NO;
        }
    }else{
        [self.label showWarningMsg:kZGVerifyPwdFailedTitle];
    }
    return result;
}

- (void)modifyPwd
{
    [self.label showNormalMsg:kZGModifyPwdNormalTitle];
}

//界面退出
- (void)dismiss:(NSTimeInterval)timeInterval
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    });
}

//忘记密码
- (IBAction)forgetPwd:(UIButton *)sender {
    [self dismiss:0];
    if (_forgetPwdBlock) {
        _forgetPwdBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
