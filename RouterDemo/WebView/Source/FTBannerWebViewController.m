//
//  FTBannerWebViewController.m
//  CreditCat
//
//  Created by luming on 2017/5/23.
//  Copyright © 2017年 luming. All rights reserved.
//

#import "FTBannerWebViewController.h"
#import <WebKit/WebKit.h>
@interface FTBannerWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>



@property (nonatomic,strong) WKWebView *wkView;
@property (nonatomic, strong) UIProgressView *progressView;//设置加载进度条

@end

@implementation FTBannerWebViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.progressView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubviews];
}


- (void)initSubviews
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView setMultipleTouchEnabled:YES];
    [webView setAutoresizesSubviews:YES];
    [webView.scrollView setAlwaysBounceVertical:YES];
    [self.view addSubview:webView];
    self.wkView = webView;
    [_wkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // Mozilla/5.0 (iPhone; CPU iPhone OS 10_2 like Mac OS X) AppleWebKit/602.3.12 (KHTML, like Gecko) Mobile/14C92
    [_wkView setAllowsBackForwardNavigationGestures:true];
    NSURL *url = [NSURL URLWithString:self.urlStr];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:req];
    [webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    [self.view addSubview:self.progressView];
    if (self.name.length > 0) {
        self.title = _name;
    }
    //    //信用特权介绍
    //    if ([self.name isEqualToString:@"信用特权介绍"]) {
    //        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        rightBtn.frame = CGRectMake(0, 0, 70, 40);
    //        rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    //        [rightBtn setTitle:@"提升特权" forState:UIControlStateNormal];
    //        rightBtn.tag = 1;
    //        [rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //    }
    
    //监听键盘操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
}
- (void)keyboardDidShow:(NSNotification *)notification
{
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    //    NSString *string = [self.wkView stringByEvaluatingJavaScriptFromString:@"document.getElementById(‘input’).value;" ];
    //    [self.wkView evaluateJavaScript:@"document.getElementById('input').value;" completionHandler:^(NSString *str, NSError * _Nullable error) {
    //        NSLog(@"11111 %@",str);
    //    }];
    //
    //    [self.wkView evaluateJavaScript:@"document.getElementById('mobile').value;" completionHandler:^(NSString *str, NSError * _Nullable error) {
    //        NSLog(@"2222 %@",str);
    //    }];
    //    NSLog(@"~~监控的控件的值：~~~~:%@", string);
}

-(void)resignForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)backClicked
{
    if (!_isNoGoback) {
        if (self.wkView.canGoBack) {
            [self.wkView goBack];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - WKWebView Delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO; //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
    
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //加载完成后隐藏progressView
    //    self.progressView.hidden = YES;
    
}
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
        
    }
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSDictionary *dic = message.body;
    NSLog(@"dict %@",dic);
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString* strRequest = navigationAction.request.URL.absoluteString;
    NSLog(@"ruquest1 %@",strRequest);
    
    //需要判断targetFrame是否为nil，如果为空则重新请求
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    if([strRequest containsString:@"sourceType"]){
        if([strRequest containsString:@"sourceType/1"]){//钱包首页
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        if ([strRequest containsString:@"sourceType/2"])
                    {//银行卡列表
                        NSArray *array =self.navigationController.viewControllers;
                        for (id subVC in array) {
//                            if ([subVC isKindOfClass:[FTNewMyBindBankCardViewController class]] || [subVC isKindOfClass:[FTPaymentSettingViewController class]]) {
//                                [self.navigationController popToViewController:subVC animated:YES];
//                            }
                        }
                    }
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
//        {//小额免密
//            NSArray *array =self.navigationController.viewControllers;
//            for (id subVC in array) {
//                if ([subVC isKindOfClass:[CPaymentSettingViewController class]]) {
//                    [self.navigationController popToViewController:subVC animated:YES];
//                }
//            }
//        }
    }
    if ([strRequest containsString:@"itunes.apple.com"]) {
        
        [[UIApplication sharedApplication] openURL: navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler
{
    NSLog(@"phone %@ --- %@--- %@",prompt,defaultText,completionHandler);
}

#pragma mark - 点击网页内部按钮无效需要家这段代码
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


//kvo 监听进度
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                      context:(void *)context{
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == self.wkView) {
        [self.progressView setAlpha:1.0f];
        if (self.title.length == 0) {
            self.title = self.wkView.title;
        }
        BOOL animated = self.wkView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkView.estimatedProgress
                              animated:animated];
        
        if (self.wkView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f
                                  delay:0.3f
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.progressView setAlpha:0.0f];
                             }
                             completion:^(BOOL finished) {
                                 [self.progressView setProgress:0.0f animated:NO];
                             }];
        }
    }
    //网页title
    else if ([keyPath isEqualToString:@"title"])
    { if (object == self.wkView && self.name.length <= 0){

        self.title = self.wkView.title;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context]; }

    }
    
    else{
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

-(void)dealloc{
    [self.wkView removeObserver:self
                     forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    
    [self resignForKeyboardNotifications];
    
}

-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 3, [[UIScreen mainScreen] bounds].size.width, 3)];
        [_progressView setTrackTintColor:[UIColor clearColor]];
        _progressView.progressTintColor = [UIColor colorWithHexString:@"6AC20B"];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        //        _progressView.transform = CGAffineTransformMakeScale(1.0f, 0.5f);
        
    }
    return _progressView;
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

