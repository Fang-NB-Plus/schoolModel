//
//  WebViewComponent.h
//  GuoWuYuan
//
//  Created by softlipa软嘴唇 on 16/12/30.
//  Copyright © 2016年 softlipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewComponent : UIViewController

@property (nonatomic,copy  ) NSString  *url;
@property (nonatomic,strong) WKWebView *webView;

@end
