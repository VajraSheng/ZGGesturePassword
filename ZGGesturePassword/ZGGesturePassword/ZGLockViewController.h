//
//  ZGLockViewController.h
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGLockView.h"

@interface ZGLockViewController : UIViewController

@property (nonatomic) ZGLockType type;

//用户是否设置过密码
+ (BOOL)hasPassword;

//界面退出
- (void)dismiss:(NSTimeInterval)timeInterval;

//展示设置密码控制器
+ (instancetype)showSetPwdViewControllerOnVC:(UIViewController *)vc successBlock:(void(^)(ZGLockViewController *lockVC,NSString *password)) successBlock;

//展示验证密码控制器
+ (instancetype)showVerifyPwdViewControllerOnVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(ZGLockViewController *lockVC, NSString *pwd))successBlock;

//展示修改密码控制器
+ (instancetype)showModifyPwdViewControllerOnVC:(UIViewController *)vc successBlock:(void(^)(ZGLockViewController *lockVC,NSString *password)) successBlock;

//关闭密码控制器
+ (instancetype)showClosePwdViewControllerOnVC:(UIViewController *)vc;

//是否显示密码轨迹
+ (BOOL)allowShowLineTrail;

@end
