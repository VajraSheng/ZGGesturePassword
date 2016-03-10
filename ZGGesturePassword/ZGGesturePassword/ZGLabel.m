//
//  ZGLabel.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/13.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGLabel.h"

@implementation ZGLabel

- (void)showNormalMsg:(NSString *)msg
{
    self.textColor = ZGCircleAndLineNormalColor;
    self.text = msg;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:16.0f];
}

- (void)showWarningMsg:(NSString *)msg
{
    self.textColor = ZGWarningColor;
    self.text = msg;
    self.textAlignment = NSTextAlignmentCenter;
    self.font = [UIFont systemFontOfSize:16.0f];
    
    CGPoint position = self.layer.position;
    CGPoint x = CGPointMake(position.x - 16, position.y);
    CGPoint y = CGPointMake(position.x + 16, position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.1f;
    animation.repeatCount = 5;
    animation.removedOnCompletion = YES;
    animation.autoreverses = YES;
    animation.fromValue = [NSValue valueWithCGPoint:x];
    animation.toValue = [NSValue valueWithCGPoint:y];
    [self.layer addAnimation:animation forKey:nil];
}

@end
