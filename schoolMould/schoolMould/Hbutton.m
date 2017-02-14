//
//  Hbutton.m
//  liangqing
//
//  Created by Macbook 13.3 on 2017/2/8.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "Hbutton.h"

@implementation Hbutton
-(void)reset{
    self.imageEdgeInsets = UIEdgeInsetsZero;
    self.titleEdgeInsets = UIEdgeInsetsZero;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //btn.imageEdgeInsets = UIEdgeInsetsZero;

    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //NSLog(@"-%f",mybtn.titleLabel.bounds.size.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(-5,0,21,-self.titleLabel.bounds.size.width);
    NSLog(@"=%f",self.titleLabel.frame.origin.x);
    NSLog(@"-%f",self.titleLabel.frame.origin.y);
    
    self.titleEdgeInsets = UIEdgeInsetsMake(55,-self.imageView.frame.size.width, 0, 0);
    
 
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
