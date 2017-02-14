//
//  GuideViewController.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/7.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "GuideViewController.h"
#import "configHead.h"

@interface GuideViewController ()
@property (nonatomic,strong)UIScrollView *bgScrol;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _bgScrol = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:_bgScrol];
    _bgScrol.contentSize = CGSizeMake(SCREENWIDTH*4, SCREENHIGHT);
    _bgScrol.pagingEnabled = YES;
    
    for (int i = 0; i<4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        int a =arc4random()%255;
        int b =arc4random()%255;
        int c =arc4random()%255;
        imageView.backgroundColor = [UIColor colorWithDisplayP3Red:a/255.0 green:b/255.0 blue:c/255.0 alpha:1];
        
        imageView.frame = CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, SCREENHIGHT);
        
        [_bgScrol addSubview:imageView];
        if (i==3) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREENWIDTH-100)/2, SCREENHIGHT-200, 100, 50);
            
            [btn setTitle:@"进入app" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(jumplogin) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:btn];
            imageView.userInteractionEnabled = YES;
        }
        
    }
    
}

- (void)jumplogin{
    
    NSString *is = @"yes";
    [[NSUserDefaults standardUserDefaults] setObject:is forKey:IS_LOAD];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_OUT object:nil];
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
