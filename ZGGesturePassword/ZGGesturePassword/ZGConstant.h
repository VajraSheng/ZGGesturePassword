//
//  ZGConstant.h
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/11.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef _ZGCONSTANT_H_
#define _ZGCONSTANT_H_

#define colorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/225.0f green:g/225.0f blue:b/225.0f alpha:a]

//背景色
#define ZGViewBackgroudColor colorWithRGBA(13,52,89,1)
//圆盘默认颜色
#define ZGCircleAndLineNormalColor colorWithRGBA(241,241,241,1)
//圆盘选中后圆环和线条的颜色
#define ZGCircleAndLineSelectedColor colorWithRGBA(0,0,255,1)
//出现错误和异常时圆盘圆环、线条以及指示Label的颜色
#define ZGWarningColor colorWithRGBA(255,0,0,1)

#endif

//选中圆半径比例
extern const CGFloat kZGInnerCircleRadiusScale;
//方向圆的三角指示相对于内圆的坐标长度的比例大小,默认1.8
extern const CGFloat kZGTriangleVertexLengthScale;
//实时线条的宽度
extern const CGFloat kZGMoveLineWidth;
//密码存储的Key
extern NSString *const kZGPasswordKey;
//是否显示验证痕迹的Key
extern NSString *const kZGAllowVerifyLineTrail;
//最低密码数
extern const NSUInteger kZGMinCircleNum;

//设置密码第一次的指示Label文字
extern NSString *const kZGSetPwdFirstTitle;
//设置密码第二次的指示Label文字
extern NSString *const kZGSetPwdConfirmTitle;
//设置密码两次不一致的提示文字
extern NSString *const kZGSetPwdTwiceDifferentTitle;
//设置密码两次一致的提示文字
extern NSString *const kZGSetPwdTwiceSameTitle;

//验证密码时的提示文字
extern NSString *const kZGVerifyPwdNormalTitle;
//验证密码错误提示
extern NSString *const kZGVerifyPwdFailedTitle;
//验证密码正确提示
extern NSString *const kZGVerifyPwdSuccessedTitle;

//修改密码提示文字
extern NSString *const kZGModifyPwdNormalTitle;




@interface ZGConstant : NSObject

@end
