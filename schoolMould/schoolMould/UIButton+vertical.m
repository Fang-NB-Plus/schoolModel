//
//  UIButton+vertical.m
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/3/16.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "UIButton+vertical.h"
#import <objc/runtime.h>

static const char verticaly = '\0';
@implementation UIButton (vertical)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzleMethod(class, @selector(layoutSubviews), @selector(aop_layoutSubviews));
        
    });

}

void swizzleMethod (Class class,SEL originalSEL,SEL swizzleSEL){
    
    Method original = class_getInstanceMethod(class, originalSEL);
    Method swizzled = class_getInstanceMethod(class,  swizzleSEL);
    
    BOOL DidAddMethod = class_addMethod(class,
                                        originalSEL,
                                        method_getImplementation(swizzled),
                                        method_getTypeEncoding(swizzled));
    if (DidAddMethod) {
        class_replaceMethod(class, swizzleSEL, method_getImplementation(original), method_getTypeEncoding(original));
    }else{
        method_exchangeImplementations(original, swizzled);
    }
    
}

-(void)setIsVertical:(BOOL)isVertical{

    objc_setAssociatedObject(self, &verticaly, @(isVertical), OBJC_ASSOCIATION_ASSIGN);
    [self setNeedsLayout];
}
-(BOOL)isVertical{

   return [objc_getAssociatedObject(self,&verticaly) boolValue];
}

- (void)aop_layoutSubviews{
    [self aop_layoutSubviews];
    
    if (self.isVertical) {
        
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //btn.imageEdgeInsets = UIEdgeInsetsZero;
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        //NSLog(@"-%f",mybtn.titleLabel.bounds.size.width);
        self.imageEdgeInsets = UIEdgeInsetsMake(-5,0,21,-self.titleLabel.bounds.size.width);
        NSLog(@"=%f",self.titleLabel.frame.origin.x);
        NSLog(@"-%f",self.titleLabel.frame.origin.y);
        
        self.titleEdgeInsets = UIEdgeInsetsMake(55,-self.imageView.frame.size.width, 0, 0);
    }
}

@end
