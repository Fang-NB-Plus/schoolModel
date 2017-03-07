//
//  VPNManager.m
//  vpn代理
//
//  Created by Macbook 13.3 on 2017/1/8.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "VPNManager.h"

typedef void (^comlete)(NSInteger);

@interface VPNManager ()
@property (nonatomic,copy)comlete comblock;
@property (nonatomic,copy)comlete changeblock;
@property (nonatomic,strong)NSTimer *timer;
@end


@implementation VPNManager

-(instancetype)init{
    self = [super init];
    if (self) {
        
        [self listenning];
    }
    return self;

}
+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static VPNManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[VPNManager alloc] init];
    });
    return manager;
}
- (void)listenning{
    
    _manager = [NEVPNManager sharedManager];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statuschange:) name:NEVPNStatusDidChangeNotification object:nil];
    
}
- (void)statuschange:(NSNotification *)not{
    
    NEVPNConnection *conetion = not.object;
    if (_changeblock) {
        _changeblock(conetion.status);
    }
    NSLog(@"==%d==",conetion.status);
    if (_isStart) {
        if (conetion.status == NEVPNStatusConnected) {
            _isStart = NO;
            _comblock(3);
        }else if (conetion.status == NEVPNStatusDisconnected){
            _isStart = NO;
            _comblock(2);
        }
        
    }
    
    
    

}

- (void)vpnSettingwithUsername:(NSString *)username password:(NSString *)password adress:(NSString *)adress key:(NSString *)key andcompleteblock:(void (^)(NSError *error))completeBlock{
    
    // load config from perference
    if ([username isEqualToString:@""]||[password isEqualToString:@""]||[adress isEqualToString:@""]||[key isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"任何一项不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [_manager loadFromPreferencesWithCompletionHandler:^(NSError *error) {
        
        if (error) {
            
            NSLog(@"Load config failed [%@]", error.localizedDescription);
            
            
            
        }
        
        NEVPNProtocolIPSec *p = _manager.protocol;
        
        if (p) {
            
            // Protocol exists.
            
            // If you don't want to edit it, just return here.
            
            
        } else {
            
            // create a new one.
            
            p = [[NEVPNProtocolIPSec alloc] init];
            
        }
        
        // config IPSec protocol
        
        p.username      = username;
        
        p.serverAddress = adress;
        
        
        
        // Get password persistent reference from keychain
        
        // If password doesn't exist in keychain, should create it beforehand.
        
        [self createKeychainValue:password forIdentifier:@"VPN_PASSWORD"];
        
        
        p.passwordReference = [self searchKeychainCopyMatching:@"VPN_PASSWORD"];
        
        // PSK
        
        p.authenticationMethod = NEVPNIKEAuthenticationMethodSharedSecret;
        
        [self createKeychainValue:@"n1y2d3u4s5" forIdentifier:@"PSK"];
        
        p.sharedSecretReference = [self searchKeychainCopyMatching:@"PSK"];
        
        /*
         
         // certificate
         
         p.identityData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
         
         p.identityDataPassword = @"[Your certificate import password]";
         
         */
        
        
        p.useExtendedAuthentication = YES;
        
        p.disconnectOnSleep = NO;
        p.localIdentifier   = @"45.76.222.118";
        
        
        _manager.protocol = p;
        
        _manager.localizedDescription = @"IPSec NEWDemo";
        _manager.enabled  = YES;
        _manager.onDemandEnabled = YES;
        
        [_manager saveToPreferencesWithCompletionHandler:^(NSError *error) {
            
            if (error) {
                completeBlock(error);
                NSLog(@"Save config failed [%@]", error.localizedDescription);
                
            }else{
                completeBlock(nil);
            }
            
        }];
        
    }];


}

- (void)startVPN:(void (^)(NSInteger))completeBlock andstatechangeBlock:(void(^)(NEVPNStatus))changeBlock{
    _isStart = YES;
    NSError *error;
    _comblock    = completeBlock;
    _changeblock = changeBlock;
    [_manager.connection startVPNTunnelAndReturnError:&error];
    
    /*
   _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
       static int a;
       if (_manager.connection.status == 3) {
           a=0;
           _comblock(3);
           _isStart = NO;
           [timer invalidate];
           _timer = nil;
           return;
       }
       a++;
       if (a>20) {
           a=0;
           _isStart = NO;
           _comblock(2);
           [_manager.connection stopVPNTunnel];
           [timer invalidate];
           _timer = nil;
       }
       
   }];
     */

}
- (void)actionLater{

    if (_comblock&&(_isStart)) {
        _comblock(2);
    }
    
}

- (void)stopVPN{
    _isStart = NO;
    [_manager.connection stopVPNTunnel];
}

#pragma mark - KeyChain

static NSString * const serviceName = @"服务器";

- (NSMutableDictionary *)newSearchDictionary:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [[NSMutableDictionary alloc] init];
    
    [searchDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *encodedIdentifier = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrGeneric];
    
    [searchDictionary setObject:encodedIdentifier forKey:(__bridge id)kSecAttrAccount];
    
    [searchDictionary setObject:serviceName forKey:(__bridge id)kSecAttrService];
    
    return searchDictionary;
    
}

- (NSData *)searchKeychainCopyMatching:(NSString *)identifier {
    
    NSMutableDictionary *searchDictionary = [self newSearchDictionary:identifier];
    
    // Add search attributes
    
    [searchDictionary setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    // Add search return types
    
    // Must be persistent ref !!!!
    
    [searchDictionary setObject:@YES forKey:(__bridge id)kSecReturnPersistentRef];
    
    CFTypeRef result = NULL;
    
    SecItemCopyMatching((__bridge CFDictionaryRef)searchDictionary, &result);
    
    return (__bridge_transfer NSData *)result;
    
}

- (BOOL)createKeychainValue:(NSString *)password forIdentifier:(NSString *)identifier {
    
    NSMutableDictionary *dictionary = [self newSearchDictionary:identifier];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    [dictionary setObject:passwordData forKey:(__bridge id)kSecValueData];
    
    status = SecItemAdd((__bridge CFDictionaryRef)dictionary, NULL);
    
    if (status == errSecSuccess) {
        
        return YES;
        
    }
    
    return NO;
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:NEVPNStatusDidChangeNotification];

}


@end
