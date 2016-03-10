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
}


@end
