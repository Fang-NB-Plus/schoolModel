//
//  AFHTTP.m
//  HTTP
//
//  Created by softlipa软嘴唇 on 16/12/16.
//  Copyright © 2016年 softlipa. All rights reserved.
//

#import "AFHTTP.h"
#import "AFNetworking.h"

@implementation AFHTTP



/**
 最简单的AFget请求
 @param url 请求链接
 @param params 参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 */
+ (void)get:(NSString *)url andParams:(NSDictionary *)params ifSuccess:(void (^)(id response))successBlock orFailure:(void (^)(NSError * error))failureBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject); // 请求成功的回调
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error); // 请求失败的回调
    }];
}


/**
 最简单的AFpost请求
 @param url 请求链接
 @param params 参数
 @param successBlock 请求成功的回调
 @param failureBlock 请求失败的回调
 */
+ (void)post:(NSString *)url andParams:(NSDictionary *)params ifSuccess:(void (^)(id response))successBlock orFailure:(void (^)(NSError * error))failureBlock {
    
    AFHTTPSessionManager * session =  [AFHTTPSessionManager manager];
    [session POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
    }];
}




@end
