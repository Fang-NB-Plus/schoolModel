//
//  errorPageView.h
//  schoolMould
//
//  Created by Macbook 13.3 on 2017/2/14.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myblock)();

@interface errorPageView : UIView
/*
    webView错误页面专用
    @view:webView的错误页面
   @block:点击按钮的回调block
 */
+(instancetype)showinView:(UIView *)view andbuttonBlock:(void (^)())block;

@end
