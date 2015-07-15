//
//  ZGLabel.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/13.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "ZGLabel.h"

@implementation ZGLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
//    [UIView animateWithDuration:1.0f
//                          delay:0
//         usingSpringWithDamping:0.1f
//          initialSpringVelocity:1.0f
//                        options:UIViewAnimationOptionCurveLinear
//                     animations:^{
////                         CGAffineTransform transform = CGAffineTransformMakeTranslation(-10, 0);
////                         self.transform = transform;
//                         CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"tranform.translation.x"];
//                         animation.values = @[@(-20),@(0),@(20),@(0),@(-20),@(0),@(20),@(0)];
//                         animation.duration = 0.2f;
//                         animation.repeatCount = 2;
//                         [self.layer addAnimation:animation forKey:@"move"];
//                     } completion:^(BOOL finished) {
////                         self.transform = CGAffineTransformIdentity;
//                         [self.layer removeAllAnimations];
//                     }];
//    [UIView animateKeyframesWithDuration:0.5
//                                   delay:0
//                                 options:UIViewKeyframeAnimationOptionRepeat
//                              animations:^{
//                                  CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"tranform.translation.x"];
//                                  animation.values = @[@(-20),@(0),@(20),@(0),@(-20),@(0),@(20),@(0)];
//                                  animation.duration = 0.2f;
//                                  animation.repeatCount = 2;
//                                  [self.layer addAnimation:animation forKey:@"move"];
//                              } completion:^(BOOL finished) {
//                                  
//                              }];
    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.tra"];
//    animation.values = @[@(-20),@(0),@(20),@(0),@(-20),@(0),@(20),@(0)];
//    animation.duration = 0.2f;
//    animation.repeatCount = 2;
//    [self.layer addAnimation:animation forKey:@"move"];
    
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
