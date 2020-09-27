//
//  JDWebController.m
//  RickURLRouter_Example
//
//  Created by RickWang on 2020/9/26.
//  Copyright © 2020 Rick. All rights reserved.
//

#import "JDWebController.h"
#import <WebKit/WebKit.h>

@interface JDWebController ()

@property (nonatomic, strong) NSDictionary* routerParams;

@property (nonatomic, strong) WKWebView* webView;

@end

@implementation JDWebController

#pragma mark - Property

- (WKWebView *)webView{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.javaScriptEnabled = YES;
        config.userContentController = [[WKUserContentController alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.backgroundColor = UIColor.grayColor;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_routerParams != nil && [[_routerParams allKeys] containsObject:@"url"]) {
        NSString* urlString = _routerParams[@"url"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)hasReceivedRouterParams:(nonnull NSDictionary<NSString *,id> *)params {
    _routerParams = params;
    NSLog(@"JDWebController received router params %@", [_routerParams description]);
}

@end
