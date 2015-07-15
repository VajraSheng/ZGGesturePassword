//
//  ZGInfoView.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/14.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGInfoView.h"
#import "ZGConstant.h"

@implementation ZGInfoView

- (void)setTemporaryPwd:(NSString *)temporaryPwd
{
    _temporaryPwd = temporaryPwd;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, ZGCircleAndLineNormalColor.CGColor);
    CGContextSetFillColorWithColor(context, ZGCircleAndLineSelectedColor.CGColor);
    
    CGFloat marginValue = 5.0f;
    CGFloat subRectWidthAndHeight = (self.frame.size.width - 4 * marginValue) / 3.0f;
    for (NSUInteger i = 0; i < 9; i++) {
        NSUInteger row = i % 3;
        NSUInteger col = i / 3;
        CGFloat x = marginValue * (row + 1) + row * subRectWidthAndHeight;
        CGFloat y = marginValue * (col + 1) + col * subRectWidthAndHeight;
        CGRect rect = CGRectMake(x, y, subRectWidthAndHeight, subRectWidthAndHeight);
        if (_temporaryPwd != nil) {
            if ([_temporaryPwd containsString:[NSString stringWithFormat:@"%lu",(unsigned long)i]]) {
                CGContextFillEllipseInRect(context, rect);
            }else
                CGContextStrokeEllipseInRect(context, rect);
        }else
            CGContextStrokeEllipseInRect(context, rect);
    }
    
}

@end
