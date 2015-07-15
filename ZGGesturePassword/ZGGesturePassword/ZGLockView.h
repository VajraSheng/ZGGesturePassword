//
//  ZGLockView.h
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGCircleView.h"
#import "ZGLockViewDelegate.h"

typedef enum{
    //设置密码
    ZGLockTypeSetPwd = 0,
    //验证密码
    ZGLockTypeVerifyPwd,
    //修改密码
    ZGLockTypeModifyPwd
    
}ZGLockType;

@interface ZGLockView : UIView

@property (nonatomic) ZGLockType type;

@property (nonatomic,weak) id<ZGLockViewDelegate> delegate;

//是否出现错误
@property (nonatomic) BOOL warning;

//重设密码
- (void)resetPwd;



@end
