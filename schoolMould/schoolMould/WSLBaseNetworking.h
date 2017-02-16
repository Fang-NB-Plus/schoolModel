//
//  WSLBaseNetworking.h
//  liangqing
//
//  Created by Macbook 13.3 on 2017/2/10.
//  Copyright © 2017年 方正泉. All rights reserved.
//
#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger,NetWorkMethod){
    Get = 0,
    Post,
    Put,
    Delete
    
};
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

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                           O\  =  /O
//                        ____/`---'\____
//                      .'  \\|     |//  `.
//                     /  \\|||  :  |||//  \
//                    /  _||||| -:- |||||-  \
//                    |   | \\\  -  /// |   |
//                    | \_|  ''\---/''  |   |
//                    \  .-\__  `-`  ___/-. /
//                   ___`. .'  /--.--\  `. . __
//                ."" '<  `.___\_<|>_/___.'  >'"".
//              | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//              \  \ `-.   \_ __\ /__ _/   .-` /  /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

@interface WSLBaseNetworking : AFHTTPSessionManager
/*
 单例构造
 */

+(instancetype)shareManager;

/*
           @url: 路径
        @method: 请求方法
        @params: 参数
      @autoshow: 是否自动显示错误 默认是YES
 @completeBlock: 请求完的回调，三个参数 
           data: 请求成功的返回参数(data,nil,YES)
          error: 连接上服务器但是参数错误(nil,error,YES)
     isConneted: 没连上服务器(nil,nil,NO)
 */

- (void)requstJSdatawithurl:(NSString *)url
                     method:(NetWorkMethod)method
                   paragram:(NSDictionary *)params
           andCompleteBlock:(void(^)(id data,NSError *error,BOOL isConneted))completeBlock;
- (void)requstJSdatawithurl:(NSString *)url
                     method:(NetWorkMethod)method
                   paragram:(NSDictionary *)params
              autoShowError:(BOOL)autoshow
           andCompleteBlock:(void(^)(id data,NSError *error,BOOL isConneted))completeBlock;


@end
