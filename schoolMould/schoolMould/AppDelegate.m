//
//  AppDelegate.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "AppDelegate.h"
#import "configHead.h"
#import "userManager.h"
#import "GuideViewController.h"
#import "LoginViewController.h"
#import "MainTabbarVC.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:60];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginout) name:LOGIN_OUT object:nil];
    id obj =  [[NSUserDefaults standardUserDefaults] objectForKey:IS_LOAD];
    
    if (obj) {
        //创造随机进入导航页面的数字
        int a = arc4random()%1;
        if (a==0) {
            [self guide];
            return YES;
        }
        
        userModel *model = [[userManager shareManager] userModel];
        
        if (model.session_id) {
            [self login];
            
        }else{
            [self loginout];
        }
        
    }else{
    
        [self guide];
    }
        
    
    return YES;
}
- (void)login{
    MainTabbarVC *tab = [[MainTabbarVC alloc] init];
    
    self.window.rootViewController = tab;
}

- (void)loginout{
    
    
    LoginViewController *logVC = [[LoginViewController alloc] init];
    UINavigationController *nav= [[UINavigationController alloc] initWithRootViewController:logVC];
    self.window.rootViewController = nav;
    
}

- (void)guide{
    GuideViewController *guideVC = [[GuideViewController alloc] init];
    
    self.window.rootViewController = guideVC;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGIN_OUT object:nil];
}


@end
