//
//  WebViewController.m
//  NBNavigatorDemo
//
//  Created by 刘彬 on 2017/7/17.
//  Copyright © 2017年 NB. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (instancetype)initWithQuery:(NSDictionary *)query {
    self = [super initWithQuery:query];
    if (self) {
        _urlString =
        [query objectForKey:@"urlString"];
        self.title = [query objectForKey:@"title"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    NSLog(@"url=%@",self.urlString);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    request.timeoutInterval = 10;
    request.cachePolicy = YES;
    [_webView loadRequest:request];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.navigationItem.title = @"加载中...";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
   
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 10) {
        title = [[title substringToIndex:9] stringByAppendingString:@"…"];
    }
    self.navigationItem.title = title;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    self.navigationItem.title = @"加载失败";
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (UIWebView*)webView {
    if (_webView) return _webView;
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.translatesAutoresizingMaskIntoConstraints = NO;
    return _webView;
}
@end
