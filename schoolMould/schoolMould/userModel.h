//
//  userModel.h
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTLModel+NSCoding.h"

@interface userModel : MTLModel

@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *session_id;

@end
