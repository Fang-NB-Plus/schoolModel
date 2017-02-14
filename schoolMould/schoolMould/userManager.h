//
//  userManager.h
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MTLModel+NSCoding.h"

@interface userModel : MTLModel
//用户模型相关都在这实现实现添加
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *session_id;//登录获取的session_id

@end

/*
 *
 *          ┌─┐       ┌─┐
 *       ┌──┘ ┴───────┘ ┴──┐
 *       │                 │
 *       │       ───       │
 *       │  ─┬┘       └┬─  │
 *       │                 │
 *       │       ─┴─       │
 *       │                 │
 *       └───┐         ┌───┘
 *           │         │
 *           │         │
 *           │         │
 *           │         └──────────────┐
 *           │                        │
 *           │                        ├─┐
 *           │                        ┌─┘
 *           │                        │
 *           └─┐  ┐  ┌───────┬──┐  ┌──┘
 *             │ ─┤ ─┤       │ ─┤ ─┤
 *             └──┴──┘       └──┴──┘
 *                 神兽保佑
 *                 代码无BUG!
 */

@interface userManager : NSObject
/*
  单例构造
 */
+ (instancetype)shareManager;
//取出本地用户模型
-(userModel *)userModel;
//更新单例及用户模型
-(void)setModel:(userModel *)usermodel;
@end
