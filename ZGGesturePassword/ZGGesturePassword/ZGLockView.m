//
//  ZGLockView.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/8.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGLockView.h"

const CGFloat marginValue = 36.0f;

@interface ZGLockView ()

//已选中的圆盘的临时数组
@property (nonatomic,strong) NSMutableArray *circleViews;
@property (nonatomic,copy) NSMutableString *password;

//滑动过程中实时跟踪的点
@property (nonatomic,strong) NSSet *fingerPoints;

//设置密码时第一次输入的密码
@property (nonatomic,copy) NSString *firstSetPwd;

//修改密码之前的验证密码是否正确
@property (nonatomic) BOOL verifyBeforeModifyOldPwdRight;

//验证时是否显示痕迹
@property (nonatomic) BOOL allowShowLineTrail;

@end

@implementation ZGLockView

#pragma mark - Initial methods

- (NSMutableArray *)circleViews
{
    if (!_circleViews) {
        _circleViews = [NSMutableArray array];
    }
    return _circleViews;
}

- (NSMutableString *)password
{
    if (!_password) {
        _password = [NSMutableString string];
    }
    return _password;
}

- (BOOL)allowShowLineTrail
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZGAllowVerifyLineTrail];
}

- (void)setWarning:(BOOL)warning
{
    _warning = warning;
    [self setNeedsDisplay];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self prepareLockView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareLockView];
    }
    return self;
}

#pragma mark - Layout of circle views
- (void)prepareLockView
{
    for (NSUInteger i = 0; i < 9; i++) {
        ZGCircleView *view = [[ZGCircleView alloc] init];
        [self addSubview:view];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat circleViewWidthAndHeight = (self.frame.size.width - 4 * marginValue) / 3.0f;

    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx % 3;
        NSUInteger col = idx / 3;
        CGFloat x = marginValue * (row + 1) + row * circleViewWidthAndHeight;
        CGFloat y = marginValue * (col + 1) + col * circleViewWidthAndHeight;
        CGRect frame = CGRectMake(x, y, circleViewWidthAndHeight, circleViewWidthAndHeight);
        subview.tag = idx;
        subview.frame = frame;
    }];
}

#pragma mark - Drawing code
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (self.circleViews.count < 1 ) {
        return;
    }
    if (_fingerPoints == nil) {
        return;
    }
    
    if (_type != ZGLockTypeVerifyPwd || (_type == ZGLockTypeVerifyPwd && [self allowShowLineTrail])) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //添加裁剪区域，使9个小圆盘内不能绘制线条
        [self.circleViews enumerateObjectsUsingBlock:^(ZGCircleView *view, NSUInteger idx, BOOL *stop) {
            CGContextAddEllipseInRect(context, view.frame);
        }];
        CGContextAddRect(context, CGContextGetClipBoundingBox(context));
        CGContextEOClip(context);
        
        CGContextSetLineWidth(context, kZGMoveLineWidth);
        
        //发生错误时将显示警示信息
        if (_warning) {
            CGContextSetStrokeColorWithColor(context, ZGWarningColor.CGColor);
            
            [self.circleViews enumerateObjectsUsingBlock:^(ZGCircleView *view, NSUInteger idx, BOOL *stop) {
                view.warning = YES;
                CGPoint point = view.center;
                //添加各圆盘之间的连线
                if (idx == 0) {
                    CGContextMoveToPoint(context, point.x, point.y);
                }else{
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
            }];
            CGContextStrokePath(context);
        }else{
            CGContextSetStrokeColorWithColor(context, ZGCircleAndLineSelectedColor.CGColor);
            NSUInteger count = self.circleViews.count;
            [self.circleViews enumerateObjectsUsingBlock:^(ZGCircleView *view, NSUInteger idx, BOOL *stop) {
                CGPoint point = view.center;
                //添加各圆盘之间的连线
                if (idx == 0) {
                    CGContextMoveToPoint(context, point.x, point.y);
                }else{
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
                //每次从最近添加的圆盘到手指间动态连线
                if (idx == count - 1) {
                    CGContextMoveToPoint(context, point.x, point.y);
                }
            }];
            
            UITouch *touch = [_fingerPoints anyObject];
            CGPoint currentPoint = [touch locationInView:self];
            CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
            CGContextStrokePath(context);
        }

    }
    
    
    
    
}


#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _fingerPoints = touches;
    [self handleLock:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _fingerPoints = touches;
    [self handleLock:touches];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endLock];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endLock];
}

#pragma mark - Handle lock action
- (void)handleLock:(NSSet *)touches
{
    [self setNeedsDisplay];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    ZGCircleView *circleView = [self circleViewWithTouchLocation:point];
    if (circleView == nil) {
        return;
    }
    if ([self.circleViews containsObject:circleView]) {
        return;
    }
    [self.circleViews addObject:circleView];
    [self.password appendFormat:@"%@",@(circleView.tag)];
    
    if (_type != ZGLockTypeVerifyPwd || (_type == ZGLockTypeVerifyPwd && [self allowShowLineTrail])){
        //计算方向
        [self calculateDirection];
        //变更circleView的选择情况
        circleView.selected = YES;
    }
}

- (void)calculateDirection
{
    if (self.circleViews == nil || self.circleViews.count <= 1) {
        return;
    }
    ZGCircleView *lastCircleView = [self.circleViews lastObject];
    ZGCircleView *beforeLastCircleView = [self.circleViews objectAtIndex:self.circleViews.count - 2];
    
    CGFloat lastX = lastCircleView.frame.origin.x;
    CGFloat lastY = lastCircleView.frame.origin.y;
    CGFloat beforeLastX = beforeLastCircleView.frame.origin.x;
    CGFloat beforeLastY = beforeLastCircleView.frame.origin.y;
    
    //获取两点之间与水平线的夹角角度
    CGFloat xMarginValue = lastX - beforeLastX;
    CGFloat yMarginValue = lastY - beforeLastY;
    CGFloat degrees = atan(yMarginValue/xMarginValue) * 180 / M_PI;
    
    //往左滑的角度处理（将直接得出circleView的旋转度数）
    if (xMarginValue < 0) {
        beforeLastCircleView.direction = degrees - 90;
    }else if (xMarginValue > 0) {
        //往右滑的角度处理（将直接得出circleView的旋转度数）
        beforeLastCircleView.direction = degrees + 90;
    }else if (xMarginValue == 0) {
        //上下垂直滑动的处理
        if (yMarginValue < 0) {
            beforeLastCircleView.direction = 360;
        }else if (yMarginValue > 0){
            beforeLastCircleView.direction = 180;
        }
    }

}

- (ZGCircleView *)circleViewWithTouchLocation:(CGPoint)point
{
    ZGCircleView *view = nil;
    for (ZGCircleView *subview in self.subviews) {
        if (!CGRectContainsPoint(subview.frame, point)) {
            continue;
        }
        view = subview;
        break;
    }
    return view;
}

#pragma mark - End lock action

- (void)endLock
{
    if (self.password.length != 0) {
        [self setPwdCheck];
    }
    if (_warning) {
        //发生错误时显示警示信息0.5s
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //还原界面
            for (ZGCircleView *view in self.circleViews) {
                view.selected = NO;
                view.direction = 0;
                view.warning = NO;
            }
            [self.circleViews removeAllObjects];
            self.password = nil;
            self.warning = NO;
        });
    }else{
        //还原界面
        for (ZGCircleView *view in self.circleViews) {
            view.selected = NO;
            view.direction = 0;
            view.warning = NO;
        }
        [self.circleViews removeAllObjects];
        self.password = nil;
        [self setNeedsDisplay];
    }
    
    
    
}


- (void)setPwdCheck
{
    if (self.circleViews.count < kZGMinCircleNum) {
        self.warning = YES;
        [self.delegate setPwdTooShortError];
        return;
    }
    if (_type == ZGLockTypeSetPwd) {
        [self setPwd];
    }else if (_type == ZGLockTypeVerifyPwd) {
        [self.delegate verifyPwdResult:self.password];
    }else if (_type == ZGLockTypeModifyPwd) {
        if (!_verifyBeforeModifyOldPwdRight) {
            _verifyBeforeModifyOldPwdRight = [self.delegate verifyPwdResult:self.password];
        }else{
            [self setPwd];
        }
    }
}

- (void)setPwd
{
    if (self.firstSetPwd == nil) {
        //第一次设置密码
        self.firstSetPwd = self.password;
        [self.delegate setPwdFirstRight:self.firstSetPwd];
    }else{
        if (![self.firstSetPwd isEqualToString:self.password]) {
            self.warning = YES;
            [self.delegate setPwdTwiceDifferentWithFirst:self.firstSetPwd andSecond:self.password];
        }else
            [self.delegate setPwdTwiceSameWithPwd:self.password];
    }
}


- (void)resetPwd
{
    _firstSetPwd = nil;
}




@end
