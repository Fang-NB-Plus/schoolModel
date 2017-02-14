//
//  configHead.h
//  liangqing
//
//  Created by Macbook 13.3 on 2017/1/24.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "interface.h"
#ifndef configHead_h
#define configHead_h

#define SCREENHIGHT [UIScreen mainScreen].bounds.size.height

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define LOGIN_SUCCESS  @"login_success"
#define LOGIN_OUT      @"login_out"

#define IS_LOAD        @"is_load"

#define USER           @"user"
// 根据屏幕分辨率判断设备，是则返回YES，不是返回NO
#define isiPhone5or5sor5c ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isiPhone6or6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define isiPhone6plusor6splus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


#endif /* configHead_h */
