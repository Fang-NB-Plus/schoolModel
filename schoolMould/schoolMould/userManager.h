//
//  userManager.h
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "userModel.h"

@interface userManager : NSObject
+ (instancetype)shareManager;

-(userModel *)userModel;
-(void)setModel:(userModel *)usermodel;
@end
