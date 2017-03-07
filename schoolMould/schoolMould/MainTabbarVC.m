//
//  MainTabbarVC.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "MainTabbarVC.h"
#import "ASQMyShopVC.h"
#import "BMViewController.h"
#import "userManager.h"
#import "configHead.h"

#define url @"http://jgy.nnwsl.com/index.php?s=/Wap/Index/index/session_id/"

@interface MainTabbarVC ()

@end

@implementation MainTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path    = [[NSBundle mainBundle]pathForResource:@"keyWord" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    userModel *model = [[userManager shareManager] userModel];
    
    ASQMyShopVC *vc1 = [[ASQMyShopVC alloc] init];
    NSString *urlstr = [dic[@"indexurl"] stringByAppendingString:model.session_id];
    vc1.urlString = urlstr;
    
    BMViewController *vc2 = [[BMViewController alloc] init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nav1.tabBarItem.title         = @"主页";
    nav1.tabBarItem.image         = [UIImage imageNamed:@"maintab_oa"];
    nav1.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_oa_click"];
    
    
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nav2.tabBarItem.title         = @"生活应用";
    nav2.tabBarItem.image         = [UIImage imageNamed:@"maintab_sun"];
    nav2.tabBarItem.selectedImage = [UIImage imageNamed:@"maintab_sun_click"];
    
    
    self.viewControllers = @[nav1,nav2];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
