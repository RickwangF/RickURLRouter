//
//  RICKViewController.m
//  RickURLRouter
//
//  Created by Rick on 09/24/2020.
//  Copyright (c) 2020 Rick. All rights reserved.
//

#import "RICKViewController.h"
#import <RickURLRouter/RickURLRouter.h>

@interface RICKViewController ()

@property (nonatomic, strong) URLRouteDefaultAnalyzer* analyzer;

@property (nonatomic, strong) URLRouteDefaultTargetCreator* creator;

@property (nonatomic, strong) UIButton* testBtn;

@end

@implementation RICKViewController

#pragma mark - Init

- (URLRouteDefaultAnalyzer *)analyzer{
    if (!_analyzer) {
        _analyzer = [[URLRouteDefaultAnalyzer alloc] init];
    }
    return _analyzer;
}

- (URLRouteDefaultTargetCreator *)creator{
    if (!_creator) {
        _creator = [[URLRouteDefaultTargetCreator alloc] init];
    }
    return _creator;
}

- (UIButton *)testBtn{
    if (!_testBtn) {
        _testBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_testBtn setTitle:@"路由测试" forState:UIControlStateNormal];
        [_testBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_testBtn addTarget:self action:@selector(testBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_testBtn];
    }
    return _testBtn;
}

#pragma mark - Life Circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    URLRouterSettings.scheme = @"jade";
    URLRouterSettings.prefix = @"jd";
    URLRouterSettings.moduleEntrance = @"index";
    NSArray* targetsArray = @[@"index", @"detail", @"playback"];
    NSDictionary* moduleDictionary = @{@"live": targetsArray};
    URLRouterSettings.moduleTargets = [moduleDictionary mutableCopy];
    NSDictionary* fillParams = @{@"statusBarH": @40, @"showNaviBar": @1};
    URLRouterSettings.commonParams = [fillParams mutableCopy];
    URLRouterSettings.webTargetBlock = ^id<URLRouter> _Nullable(URLRouteAnalysisResult * _Nonnull result) {
        id<URLRouter> target;
        
        Class webVCClz = NSClassFromString(@"JDWebController");
        if (webVCClz == Nil || webVCClz == nil) {
            return target;
        }
        if ([webVCClz conformsToProtocol:@protocol(URLRouter)]) {
            target = [[webVCClz alloc] init];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (result.params != nil) {
                [params setDictionary:result.params];
            }
            
            if (![[params allKeys] containsObject:@"url"] && result.url != nil) {
                [params setObject:result.url.absoluteString forKey:@"url"];
            }
            [((id<URLRouter>)target) hasReceivedRouterParams:[params mutableCopy]];
        }
        
        return target;
        
    };
    URLRouterSettings.nativeTargetBlock = ^id<URLRouter> _Nullable(URLRouteAnalysisResult * _Nonnull result) {
        id<URLRouter> target;
        
        NSString* className = [NSString stringWithFormat:@"%@%@%@Controller", result.prefix.uppercaseString, result.module.capitalizedString, result.target.capitalizedString];
        Class vcClz = NSClassFromString(className);
        if (vcClz == Nil || vcClz == nil) {
            return target;
        }
        
        if ([vcClz conformsToProtocol:@protocol(URLRouter)]) {
            target = [[vcClz alloc] init];
            [((id<URLRouter>)target) hasReceivedRouterParams:result.params];
        }
        
        return target;
    };
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    CGFloat height = UIScreen.mainScreen.bounds.size.height;
    self.testBtn.frame = CGRectMake((width - 120)*0.5, (height-60)*0.5, 120, 60);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Method

#pragma mark - Action

- (void)testBtnTapped:(UIButton*)sender {
    // HTTP 链接测试
    // NSString* urlString = @"https://www.baidu.com";
    // NSString* urlString = @"https://www.baidu.com?statusBarH=20&showNaviBar=0";
    //NSString* urlString = @"http://www.baidu.com/index.html#/?statusBarH=20&showNaviBar=0&title=我的";
    //NSString* urlEncodeString = [URLRouterUtil encodeURLString:urlString];
    
    // 原生链接测试
//    NSString* urlString = @"jade://jd.live.detail?id=110";
//    NSURL* url = [NSURL URLWithString:urlString];
//    URLRouteAnalysisResult* result = [self.analyzer analyzeRouteURL:url];
//    NSLog(@"analyze result is %@", [result mj_JSONString]);
//    URLRouteTargetCreateResult* createResult = [self.creator createTargetWithAnalyzedResult:result];
//    NSLog(@"create target result is %@ and target is %@", [createResult description], createResult.target);
    
    // [URLRouterUtil routeToModule:@"live" Target:@"detail" Params:@{@"id": @1} Style:URLRouteStylePresentFullScreen];
    // [URLRouterUtil routeWithURLString:@"https://www.baidu.com?"];
    // URLRouteResult* result = [URLRouterUtil routeWithURLString:[URLRouterUtil encodeURLString:@"https://www.baidu.com/index.html#/?statusBarH=20&showNaviBar=0&title=我的"] Style:URLRouteStylePresentFullScreen];
    URLRouteResult* result = [URLRouterUtil routeToURL:[NSURL URLWithString:@"jade://jd.live.detail?id=16"] Style:URLRouteStylePresentFullScreen];
    if (result.error != nil) {
        NSLog(@"route result error is %@", result.error.localizedDescription);
    }
}

@end
