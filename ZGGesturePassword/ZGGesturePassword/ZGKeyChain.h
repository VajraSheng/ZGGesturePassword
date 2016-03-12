//
//  ZGKeyChain.h
//  ZGGesturePassword
//
//  Created by WiseCloudCRM on 16/3/12.
//  Copyright © 2016年 盛振国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

#define KEY_PASSWORD @"com.odom.sheng.password"
#define KEY_USERNAME_PASSWORD @"com.odom.sheng.usernamepassword"

@interface ZGKeyChain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
