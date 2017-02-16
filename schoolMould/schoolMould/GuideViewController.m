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
        
        
        imageView.frame = CGRectMake(i*SCREENWIDTH, 0, SCREENWIDTH, SCREENHIGHT);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guidepage%d",i+1]];
        [_bgScrol addSubview:imageView];
        if (i==3) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREENWIDTH-150)/2, SCREENHIGHT-130, 150, 50);
            btn.backgroundColor = [UIColor blueColor];
            btn.titleLabel.font = [UIFont systemFontOfSize:20];
            
            [btn setTitle:@"立即体验" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(jumplogin) forControlEvents:UIControlEventTouchUpInside];
            
            btn.layer.cornerRadius  = 5;
            btn.layer.masksToBounds = YES;
            
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
