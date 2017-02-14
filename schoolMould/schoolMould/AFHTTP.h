//
//  AFHTTP.h
//  HTTP
//
//  Created by softlipa软嘴唇 on 16/12/16.
//  Copyright © 2016年 softlipa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFHTTP : NSObject

/**
 最简单的AFget请求
 @param url 请求链接
 @param params 参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 */
+ (void)get:(NSString *)url andParams:(NSDictionary *)params ifSuccess:(void (^)(id))successBlock orFailure:(void (^)(NSError *))failureBlock;


/**
 最简单的AFpost请求
 @param url 请求链接
 @param params 参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 */
+ (void)post:(NSString *)url andParams:(NSDictionary *)params ifSuccess:(void (^)(id response))successBlock orFailure:(void (^)(NSError *))failureBlock;

@end
