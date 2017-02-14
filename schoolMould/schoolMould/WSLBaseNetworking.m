//
//  WSLBaseNetworking.m
//  liangqing
//
//  Created by Macbook 13.3 on 2017/2/10.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "WSLBaseNetworking.h"
#import "configHead.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation WSLBaseNetworking

+ (instancetype)shareManager{
    static WSLBaseNetworking *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[WSLBaseNetworking alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    });
    return shareManager;

}

- (instancetype)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
    }
    return self;
    
}

- (BOOL)getNetStatus{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        
        return NO;
    }else
        return YES;
}

- (void)requstJSdatawithurl:(NSString *)url method:(NetWorkMethod)method paragram:(NSDictionary *)params andCompleteBlock:(void(^)(id data,NSError *error,BOOL isConneted))completeBlock{
    [self requstJSdatawithurl:url method:method paragram:params autoShowError:YES andCompleteBlock:completeBlock];


}

- (void)requstJSdatawithurl:(NSString *)url method:(NetWorkMethod)method paragram:(NSDictionary *)params autoShowError:(BOOL)autoshow andCompleteBlock:(void(^)(id data,NSError *error,BOOL isConneted))completeBlock{
    
    if (![self getNetStatus]) {
        completeBlock(nil,nil,NO);
        return;
    }
    
    switch (method) {
        case Get:{
            [self GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id error = [self handle:(id)responseObject autoshowError:autoshow];
                if (error) {
                    completeBlock(nil,error,YES);
                }else
                    completeBlock(responseObject,nil,YES);
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,nil,NO);
                 [self showErrorMsg:error.userInfo[@"NSLocalizedDescription"]];
                
            }];
        }
            
            break;
        case Post:{
            [self POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id error = [self handle:responseObject autoshowError:autoshow];
                if (error) {
                    completeBlock(nil,error,YES);
                }else
                    completeBlock(responseObject,nil,YES);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,nil,NO);
                [self showErrorMsg:error.userInfo[@"NSLocalizedDescription"]];
            }];
        
        }
            break;
        case Put:
        {
            [self PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id error = [self handle:responseObject autoshowError:autoshow];
                if (error) {
                    completeBlock(nil,error,YES);
                }else
                    completeBlock(responseObject,nil,YES);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,nil,NO);
                [self showErrorMsg:error.userInfo[@"NSLocalizedDescription"]];
            }];
            break;
        }
        case Delete:{
            [self DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id error = [self handle:responseObject autoshowError:autoshow];
                if (error) {
                    completeBlock(nil,error,YES);
                }else
                    completeBlock(responseObject,nil,YES);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                completeBlock(nil,nil,NO);
                [self showErrorMsg:error.userInfo[@"NSLocalizedDescription"]];
            }];
        }
            break;
        default:
            break;
    }


}

- (id)handle:(id)respone autoshowError:(BOOL)autoshow{
    
    NSError *error = nil;
    //code为非0值时，表示有错
    NSNumber *resultCode = [respone valueForKeyPath:@"status"];
    
    if ([resultCode isKindOfClass:[NSNumber class]] && resultCode.intValue != 0) {
        error = [NSError errorWithDomain:BaseUrl code:resultCode.intValue userInfo:respone];
        if (autoshow) {
            if(resultCode.integerValue!=0){
                [self showErrorMsg:respone[@"msg"]];
                
            }
        }
    }
    
    
    return error;
}

- (void)showErrorMsg:(NSString *)errorStr{
    
    UIView *view = [[UIApplication sharedApplication] keyWindow].subviews.lastObject;
    
    MBProgressHUD *MBhud;
    MBhud                 = [MBProgressHUD showHUDAddedTo:view animated:YES];
    MBhud.mode            = MBProgressHUDModeText;
    MBhud.margin          = 10.f;
    MBhud.userInteractionEnabled = NO;
    MBhud.minSize         = CGSizeMake(120.0 * 1, 30.0 * 1);
    MBhud.label.text      = errorStr;
    MBhud.label.font      = [UIFont systemFontOfSize:15.0 * 1];
    MBhud.bezelView.color = [UIColor blackColor];
    MBhud.label.textColor = [UIColor whiteColor];
    
    // 1秒之后再消失
    [MBhud hideAnimated:YES afterDelay:1.0];
    
    
}

@end
