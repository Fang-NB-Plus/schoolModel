//
//  WebViewComponent.m
//  GuoWuYuan
//
//  Created by softlipa软嘴唇 on 16/12/30.
//  Copyright © 2016年 softlipa. All rights reserved.
//

#import "WebViewComponent.h"
#import "configHead.h"

@interface WebViewComponent ()<WKUIDelegate,WKNavigationDelegate,UIScrollViewDelegate,WKScriptMessageHandler>
@property (nonatomic , strong)UIBarButtonItem * closeItem;
@property (nonatomic , strong)UIBarButtonItem * backItem;

@end

@implementation WebViewComponent

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createWebView];
}


-(void)dealloc {
    
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"canGoBack"];
    self.webView.UIDelegate          = nil;
    self.webView.navigationDelegate  = nil;
    self.webView.scrollView.delegate = nil;
    [self.webView removeFromSuperview];
    self.webView = nil;
}



- (void)createWebView {
    
    // webView frame Y坐标设置-20的话看不到系统通知栏
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHIGHT - 40)]; // 高度-64可以防止"阅读原文"被覆盖。
    self.webView.backgroundColor = [UIColor whiteColor]; // webView向下拉伸后的背景
    self.webView.UIDelegate          = self;
    self.webView.navigationDelegate  = self;
    self.webView.scrollView.delegate = self;
    
    // 添加这句话estimatedProgress才有
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    WKWebViewConfiguration * Configuration = [[WKWebViewConfiguration alloc]init];
    Configuration.allowsAirPlayForMediaPlayback  = YES;// 允许视频播放
    Configuration.allowsInlineMediaPlayback      = YES;// 允许在线播放
    Configuration.selectionGranularity           = YES;// 允许可以与网页交互，选择视图
    Configuration.suppressesIncrementalRendering = YES;// 是否支持记忆读取
    
    self.webView.allowsLinkPreview                   = YES;//允许预览链接
    self.webView.userInteractionEnabled              = YES;// 交互
    self.webView.allowsBackForwardNavigationGestures = YES;//左右滑回退功能
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.webView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:NULL];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]; // 加载url
    [self.webView loadRequest:request];
    
    [self.view addSubview:self.webView];
    [self createBackBtn];
}
- (void)createBackBtn
{
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBlicked:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    closeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    UIImage* backItemImage = [[UIImage imageNamed:@"backItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage* backItemHlImage = [[UIImage imageNamed:@"backItemImage-hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backBtn setImage:backItemImage forState:UIControlStateNormal];
    [backBtn setImage:backItemHlImage forState:UIControlStateHighlighted];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backBtn.contentMode = UIViewContentModeScaleAspectFit;
    backBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [backBtn addTarget:self action:@selector(goback:) forControlEvents:UIControlEventTouchUpInside];
    
    _closeItem = [[UIBarButtonItem alloc] initWithCustomView:closeBtn];
    _backItem  = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
}
#pragma mark -naviFun
- (void)closeBlicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)goback:(id)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
        [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable titlestr, NSError * _Nullable error) {
            
            self.navigationItem.title = titlestr;
        }];
    }
    else
    {
        [self.webView goToBackForwardListItem:[self.webView.backForwardList.backList firstObject]];
    }
    
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
//    [SVProgressHUD show];
//    self.progressview.hidden = NO;

    self.navigationItem.title = @"正在加载...";
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (webView.isLoading) { // 防止网页重定向重复调用
        
//        [SVProgressHUD dismiss];
        
        return;// return以后，结束这个didFinishNavigation方法
    }
    
//    [SVProgressHUD dismiss];
}


// 处理进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
//    if (object == self.webView) {
//        
//        if ([keyPath isEqualToString:@"estimatedProgress"]) {
//            
//            if (self.webView.estimatedProgress == 1.0) {
//                
//                self.progressview.hidden = YES;
//                
//            } else {
//                
//                self.progressview.progress = self.webView.estimatedProgress;// estimatedProgress 等于progressview的进度
//            }
//        }
    if ([keyPath isEqualToString:@"canGoBack"]) {
    
    if (self.webView.canGoBack) {
        
        self.navigationItem.leftBarButtonItems = @[_backItem];
        self.navigationItem.rightBarButtonItem = _closeItem;
        //self.tabBarController.tabBar.hidden = YES;

        
    }
    else
    {
        self.navigationItem.leftBarButtonItems = @[];
        self.navigationItem.rightBarButtonItem = nil;
        //self.tabBarController.tabBar.hidden = NO;
        
        
        
    }
 }
    


    if ([keyPath isEqualToString:@"title"]) {
        
        if (object == self.webView) {
            self.navigationItem.title = self.webView.title;
        }
    }

}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"网页返回信息：%@",message);
    if ([message isEqualToString:@"logout"]) {
        
        completionHandler();
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SESSIONID];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        [delegate LogoutSuccess];
        
    }
    else if ([message isEqualToString:@"payorder"])
    {
        NSLog(@"支付支付");
        completionHandler();
        
        
    }
    else
    {
        completionHandler();
    }
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    completionHandler(YES);
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    completionHandler(@"不传");
}


- (void)viewWillAppear:(BOOL)animated
{   [super viewWillAppear:YES];
    //self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{  [super viewWillDisappear:YES];
    //self.tabBarController.tabBar.hidden = NO;
}

@end
