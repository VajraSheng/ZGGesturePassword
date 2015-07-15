//
//  ZGCircleView.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/6.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGCircleView.h"

static inline double radius(double degrees){return degrees * M_PI / 180;}

@interface ZGCircleView ()

//圆盘所在View的宽高
@property (nonatomic) float width;
@property (nonatomic) float height;

//外圆和内圆的圆心
@property (nonatomic) float circleCenterX;
@property (nonatomic) float circleCenterY;

//外圆的半径
@property (nonatomic) float radius;

@end

@implementation ZGCircleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

- (void)setDirection:(double)direction
{
    _direction = direction;
    [self setNeedsDisplay];
}

- (void)setWarning:(BOOL)warning
{
    _warning = warning;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    _width = self.bounds.size.width;
    _height = self.bounds.size.height;
    _circleCenterX = _width/2;
    _circleCenterY = _height/2;
    _radius = _width < _height ? _width/2 - 1 : _height/2 - 1;
    
    if ([self isSelected]) {
        if (self.direction != 0){
            [self drawDirectionCircle];
        }
        [self drawSelectedCircle];
    }else{
        [self drawNormalCircle];
    }
}

- (void)drawNormalCircle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, ZGCircleAndLineNormalColor.CGColor);
    CGContextSetLineWidth(context, 1);
    CGContextAddArc(context, _circleCenterX, _circleCenterY, _radius, 0, 2*M_PI, 1);
    CGContextStrokePath(context);
}

- (void)drawSelectedCircle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    if (_warning) {
        CGContextSetStrokeColorWithColor(context, ZGWarningColor.CGColor);
        CGContextSetFillColorWithColor(context, ZGWarningColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, ZGCircleAndLineSelectedColor.CGColor);
        CGContextSetFillColorWithColor(context, ZGCircleAndLineSelectedColor.CGColor);
    }
    CGContextAddArc(context, _circleCenterX, _circleCenterY, _radius, 0, 2*M_PI, 1);
    CGContextStrokePath(context);
    CGContextAddArc(context, _circleCenterX, _circleCenterY, _radius * kZGInnerCircleRadiusScale, 0, 2*M_PI, 1);
    CGContextFillPath(context);
}

- (void)drawDirectionCircle
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    if (_warning) {
        CGContextSetStrokeColorWithColor(context, ZGWarningColor.CGColor);
        CGContextSetFillColorWithColor(context, ZGWarningColor.CGColor);
    }else{
        CGContextSetStrokeColorWithColor(context, ZGCircleAndLineSelectedColor.CGColor);
        CGContextSetFillColorWithColor(context, ZGCircleAndLineSelectedColor.CGColor);
    }
    CGContextAddArc(context, _circleCenterX, _circleCenterY, _radius, 0, 2*M_PI, 1);
    CGContextStrokePath(context);
    CGContextAddArc(context, _circleCenterX, _circleCenterY, _radius * kZGInnerCircleRadiusScale, 0, 2*M_PI, 1);
    CGContextFillPath(context);
    
    float innerRadius = _radius * kZGInnerCircleRadiusScale;
    
    //正上方向三角形的三个顶点坐标，确定以后其余方向只需按角度旋转即可，相邻角度为22.5度
    CGPoint upTriangleFirstVertex = CGPointMake(_circleCenterX, _circleCenterY - sqrt(2)*innerRadius*kZGTriangleVertexLengthScale);
    CGPoint upTriangleSecondVertex = CGPointMake(_circleCenterX + (sqrt(2) - 1)*innerRadius*kZGTriangleVertexLengthScale, _circleCenterY - innerRadius*kZGTriangleVertexLengthScale);
    CGPoint upTriangleThirdVertex = CGPointMake(_circleCenterX - (sqrt(2) - 1)*innerRadius*kZGTriangleVertexLengthScale, _circleCenterY - innerRadius*kZGTriangleVertexLengthScale);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:upTriangleFirstVertex];
    [path addLineToPoint:upTriangleSecondVertex];
    [path addLineToPoint:upTriangleThirdVertex];
    [path closePath];
    CGContextTranslateCTM(context, self.width / 2, self.height / 2);
    CGContextRotateCTM(context, radius(_direction));
    CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
    [path fill];
    
//    switch (_direction) {
//        case NextDirectionDown:
//            CGContextMoveToPoint(context, _circleCenterX, _circleCenterY + sqrt(2)*innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + (sqrt(2) - 1)*innerRadius*scale, _circleCenterY + innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - (sqrt(2) - 1)*innerRadius*scale, _circleCenterY + innerRadius*scale);
//            break;
//        case NextDirectionDownLeft:
//            CGContextMoveToPoint(context, _circleCenterX - innerRadius*scale, _circleCenterY + innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - (sqrt(2) - 1)*innerRadius*scale, _circleCenterY + innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - innerRadius*scale, _circleCenterY + (sqrt(2) - 1)*innerRadius*scale);
//            break;
//        case NextDirectionDownRight:
//            CGContextMoveToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY + innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + (sqrt(2) - 1)*innerRadius*scale, _circleCenterY + innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY + (sqrt(2) - 1)*innerRadius*scale);
//            break;
//        case NextDirectionLeft:
//            CGContextMoveToPoint(context, _circleCenterX - sqrt(2)*innerRadius*scale, _circleCenterY);
//            CGContextAddLineToPoint(context, _circleCenterX - innerRadius*scale, _circleCenterY - (sqrt(2) - 1)*innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - innerRadius*scale, _circleCenterY + (sqrt(2) - 1)*innerRadius*scale);
//            break;
//        case NextDirectionRight:
//            CGContextMoveToPoint(context, _circleCenterX + sqrt(2)*innerRadius*scale, _circleCenterY);
//            CGContextAddLineToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY - (sqrt(2) - 1)*innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY + (sqrt(2) - 1)*innerRadius*scale);
//            break;
//        case NextDirectionUp:
//            CGContextMoveToPoint(context, _circleCenterX, _circleCenterY - sqrt(2)*innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + (sqrt(2) - 1)*innerRadius*scale, _circleCenterY - innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - (sqrt(2) - 1)*innerRadius*scale, _circleCenterY - innerRadius*scale);
//            break;
//        case NextDirectionUpLeft:
//            CGContextMoveToPoint(context, _circleCenterX - innerRadius*scale, _circleCenterY - innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - (sqrt(2) - 1)*innerRadius*scale, _circleCenterY - innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX - innerRadius*scale, _circleCenterY - (sqrt(2) - 1)*innerRadius*scale);
//            break;
//        case NextDirectionUpRight:
//            CGContextMoveToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY - innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + (sqrt(2) - 1)*innerRadius*scale, _circleCenterY - innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY - (sqrt(2) - 1)*innerRadius*scale);
//            break;
//        case NextDirectionRight:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(22.5f));
//            CGContextTranslateCTM(context, -self.width/2, -self.height/2);
//            CGContextMoveToPoint(context, _circleCenterX + sqrt(2)*innerRadius*scale, _circleCenterY);
//            CGContextAddLineToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY - (sqrt(2) - 1)*innerRadius*scale);
//            CGContextAddLineToPoint(context, _circleCenterX + innerRadius*scale, _circleCenterY + (sqrt(2) - 1)*innerRadius*scale);
////            CGContextTranslateCTM(context, innerRadius*scale, -innerRadius*scale);
//            
//            break;
//        case NextDirectionUp:
//            
//            [path fill];
//            
//            break;
//        case NextDirectionUpRightNearUp:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(22.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionUpRight:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(45.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionUpRightNearRight:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(67.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionRight:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(-306.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDownRightNearRight:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(112.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDownRight:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(135.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDownRightNearDown:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(157.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDown:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(180.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDownLeftNearDown:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(202.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDownLeft:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(225.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionDownLeftNearLeft:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(247.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionLeft:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(270.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionUpLeftNearLeft:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(292.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionUpLeft:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(315.0f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//        case NextDirectionUpLeftNearUp:
//            CGContextTranslateCTM(context, self.width / 2, self.height / 2);
//            CGContextRotateCTM(context, radius(337.5f));
//            CGContextTranslateCTM(context, -self.width / 2, -self.height / 2);
//            [path fill];
//            
//            break;
//    }
    
    
    
}


@end
