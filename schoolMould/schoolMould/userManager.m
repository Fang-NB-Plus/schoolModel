//
//  userManager.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "userManager.h"
#import "configHead.h"

@interface userManager ()
@property (nonatomic,strong)userModel *userModel;

@end

@implementation userManager
+(instancetype)shareManager{
    static userManager *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[userManager alloc] init];
    });
    return shareManager;
    
}

-(void)setModel:(userModel *)userModel{

    _userModel = userModel;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:USER];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(userModel *)userModel{

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USER];
    _userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    return _userModel;
}

@end

@implementation userModel



@end
