//
//  ZGConstant.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/11.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGConstant.h"

//选中圆半径比例
const CGFloat kZGInnerCircleRadiusScale = 0.25f;
//方向圆的三角指示相对于内圆的坐标长度的比例大小,默认1.8
const CGFloat kZGTriangleVertexLengthScale = 1.8f;
//实时线条的宽度
const CGFloat kZGMoveLineWidth = 1.0f;
//密码存储的Key
NSString *const kZGPasswordKey = @"ZGLockPassword";
//是否显示验证痕迹的Key
NSString *const kZGAllowVerifyLineTrail = @"ZGAllowVerifyLineTrail";
//最低密码数
const NSUInteger kZGMinCircleNum = 4;

//设置密码第一次的指示Label文字
NSString *const kZGSetPwdFirstTitle = @"请绘制解锁图案";
//设置密码第二次的指示Label文字
NSString *const kZGSetPwdConfirmTitle = @"请再次绘制解锁图案";
//设置密码两次不一致的提示文字
NSString *const kZGSetPwdTwiceDifferentTitle = @"与上次绘制不一致，请重新绘制";
//设置密码两次一致的提示文字
NSString *const kZGSetPwdTwiceSameTitle = @"设置成功";

//验证密码时的提示文字
NSString *const kZGVerifyPwdNormalTitle = @"请滑动输入密码";
//验证密码错误提示
NSString *const kZGVerifyPwdFailedTitle = @"密码错误";
//验证密码正确提示
NSString *const kZGVerifyPwdSuccessedTitle = @"密码正确";

//修改密码提示文字
NSString *const kZGModifyPwdNormalTitle = @"请输入原密码";


@implementation ZGConstant

@end
