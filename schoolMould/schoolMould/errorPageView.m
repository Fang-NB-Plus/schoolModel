//
//  errorPageView.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/14.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "errorPageView.h"
#import "configHead.h"

@interface errorPageView ()
@property (nonatomic,copy)myblock buttonBlock;

@end

@implementation errorPageView

+(instancetype)showinView:(UIView *)view andbuttonBlock:(void (^)())block{
    errorPageView *errorView;
    
    errorView = [[errorPageView alloc] initWithFrame:view.bounds];
    errorView.buttonBlock = block;
    if (errorView) {
        [errorView setView];
        [view addSubview:errorView];
    }
    return errorView;
}

- (void)setView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-64)/2, 100, 64, 64)];
    imageView.image = [UIImage imageNamed:@"errorIMG"];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, SCREENWIDTH, 50)];
    lable.text          = @"出错了，请重新加载";
    lable.textColor     = [UIColor blueColor];
    lable.textAlignment = NSTextAlignmentCenter;

    UIButton *reClick   = [UIButton buttonWithType:UIButtonTypeCustom];
    [reClick setTitle:@"重新加载" forState:UIControlStateNormal];
    [reClick setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    reClick.frame = CGRectMake((self.frame.size.width - 150)/2, 300, 150, 50);
    reClick.layer.cornerRadius  = 5;
    reClick.layer.masksToBounds = YES;
    reClick.layer.borderColor   = [UIColor blueColor].CGColor;
    reClick.layer.borderWidth   = 2;
    
    [reClick addTarget:self action:@selector(reClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:reClick];
    [self addSubview:imageView];
    [self addSubview:lable];
    
}

- (void)reClick{
    
    self.buttonBlock?_buttonBlock():nil;
    [self hide];
    
}

- (void)hide{

    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
