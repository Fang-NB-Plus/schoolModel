//
//  VPNManager.h
//  vpn代理
//
//  Created by Macbook 13.3 on 2017/1/8.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NetworkExtension/NetworkExtension.h>

@interface VPNManager : NSObject{

    BOOL _isStart;
}
@property (nonatomic,assign)BOOL isStart;
@property (nonatomic,strong)NEVPNManager *manager;



+ (instancetype)shareManager;
/*
vpn配置,限定两种disco IPSec IKEV4(其他的苹果暂未开放)如需只能自行创建虚拟网卡，创建vpn通道
      username:用户名
      password:密码
        adress:vpn地址
           key:共享密钥
 completeBlock:保存回调
 */
- (void)vpnSettingwithUsername:(NSString *)username
                      password:(NSString *)password
                        adress:(NSString *)adress
                           key:(NSString *)key
              andcompleteblock:(void (^)(NSError *error))completeBlock;
/*
          vpn开始连接
 completeBlock:连接成功或者失败时的回调函数
   changeBlock:连接状态改变时的回调 详见NEVPNStatus
 */
- (void)startVPN:(void (^)(NSInteger))completeBlock andstatechangeBlock:(void(^)(NEVPNStatus))changeBlock;
/*
 vpn停止
 */
- (void)stopVPN;
@end
