//
//  ZGCircleView.h
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/6.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZGConstant.h"

@interface ZGCircleView : UIView

@property (nonatomic,getter=isSelected) BOOL selected;
@property (nonatomic) double direction;

@property (nonatomic) BOOL warning;


@end
