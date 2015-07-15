//
//  ZGLockViewDelegate.h
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/10.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZGLockViewDelegate <NSObject>

#pragma mark - Set Password
//第一次输入
//- (void)setPwdBegin;
//密码长度不足
- (void)setPwdTooShortError;
//第二次确认输入
//- (void)setPwdConfirm;
//第一次输入以后
- (void)setPwdFirstRight:(NSString *)firstRightPwd;
//两次密码不一致
- (void)setPwdTwiceDifferentWithFirst:(NSString *)firstPwd andSecond:(NSString *)secondPwd;
//两次输入一致
- (void)setPwdTwiceSameWithPwd:(NSString *)pwd;

#pragma mark - Verify Password
//验证密码开始
//- (void)verifyPwdBegin;
//验证密码结果
- (BOOL)verifyPwdResult:(NSString *)pwd;

#pragma mark - Modify Password
//修改密码
- (void)modifyPwd;
//修改成功
//- (void)modifyPwdSuccess;

@end
