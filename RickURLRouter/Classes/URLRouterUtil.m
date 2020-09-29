//
//  URLRouterAnalysis.m
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import "URLRouterUtil.h"
#import "URLRouterConst.h"
#import "URLRouterSettings.h"
#import "URLRouteDefaultAnalyzer.h"
#import "URLRouteDefaultTargetCreator.h"

static id<URLRouteAnalyzer> _analyzer;
static id<URLRouteTargetCreator> _creator;

@implementation URLRouterUtil

@dynamic analyzer, creator;

#pragma mark - Property

+ (id<URLRouteAnalyzer>)analyzer{
    if (!_analyzer) {
        _analyzer = [[URLRouteDefaultAnalyzer alloc] init];
    }
    return _analyzer;
}

+ (void)setAnalyzer:(id<URLRouteAnalyzer>)analyzer{
    _analyzer = analyzer;
}

+ (id<URLRouteTargetCreator>)creator{
    if (!_creator) {
        _creator = [[URLRouteDefaultTargetCreator alloc] init];
    }
    return _creator;
}

+ (void)setCreator:(id<URLRouteTargetCreator>)creator{
    _creator = creator;
}

#pragma mark - Private Method

+ (NSDictionary*)concatParamsDictionary:(NSDictionary*)params{
    NSMutableDictionary* mixDictionary = [NSMutableDictionary dictionary];
    if (params == nil || params.count == 0) {
        return [mixDictionary copy];
    }
    
    if (URLRouterSettings.commonParams.count > 0) {
        [mixDictionary setDictionary:URLRouterSettings.commonParams];
        
        [params enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (![[mixDictionary allKeys] containsObject:key]) {
                [mixDictionary setObject:obj forKey:key];
            }
        }];
    } else {
        [mixDictionary setDictionary:params];
    }
    
    return [mixDictionary copy];
}

+ (UIViewController *)getRootViewController{

    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}

+ (UIViewController *)findCurrentController{
    
    UIViewController* currentViewController = [self getRootViewController];

    BOOL loopFind = YES;
    while (loopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

+ (void)presentRouteTarget:(URLRouteTargetCreateResult *)created {
    UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController: (UIViewController*)created.target];
    naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [[self findCurrentController].navigationController presentViewController:naviVC animated:true completion:nil];
}

+ ( NSError* _Nullable )pushRouteTarget:(URLRouteTargetCreateResult *)created{
    if ([self findCurrentController].navigationController == nil) {
        NSError* error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeCantFindNavigationController userInfo:@{NSLocalizedDescriptionKey: @"没有找到导航控制器"}];
        return error;
    }
    
    [[self findCurrentController].navigationController pushViewController:(UIViewController*)created.target animated:true];
    
    return nil;
}

#pragma mark - Public Method

+ (NSString *)encodeURLString:(NSString*)originString{
    if (originString == nil || [originString isEqualToString:@""]) {
        return @"";
    }
    
    NSMutableCharacterSet* set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    return [originString stringByAddingPercentEncodingWithAllowedCharacters:set];
}

+ (NSString *)decodeURLString:(NSString*)encodedString{
    return [encodedString stringByRemovingPercentEncoding];
}

+ (URLRouteResult *)routeToURL:(NSURL *)url{
    return [self routeToURL:url Style:URLRouteStylePush];
}

+ (URLRouteResult*)routeToURL:(NSURL*)url Style:(URLRouteStyle)style{
    
    URLRouteResult *result = [[URLRouteResult alloc] init];
    
    if (url == nil || [url.absoluteString isEqualToString:@""]) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyRoute userInfo:@{NSLocalizedDescriptionKey: @"路由地址为空"}];
        return result;
    }
    
    URLRouteAnalysisResult *analyzed = [self.analyzer analyzeRouteURL:url];
    if (analyzed == nil) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeAnalyzeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由解析失败"}];
        return result;
    }
    
    if (analyzed.error != nil) {
        result.error = analyzed.error;
        return result;
    }
    
    if (analyzed.url == nil) {
        if (analyzed.module == nil || analyzed.target == nil) {
            result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey: @"路由解析失败"}];
            return result;
        }
    }
    
    URLRouteTargetCreateResult *created = [self.creator createTargetWithAnalyzedResult:analyzed];
    if (created == nil) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
        return result;
    }
    
    if (created.error != nil) {
        result.error = created.error;
        return result;
    }
    
    if (created.target == nil) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
        return result;
    }
    
    if (style == URLRouteStylePresentFullScreen) {
        [self presentRouteTarget:created];
    } else {
        result.error = [self pushRouteTarget:created];
    }
    
    if (result.error != nil) {
        return result;
    }
    
    result.success = true;
    return result;
}

+ (URLRouteResult *)routeWithURLString:(NSString *)urlString{
    NSURL* url = [NSURL URLWithString:urlString];
    return [self routeToURL:url Style:URLRouteStylePush];
}

+ (URLRouteResult *)routeWithURLString:(NSString *)urlString Style:(URLRouteStyle)style{
    NSURL* url = [NSURL URLWithString:urlString];
    return [self routeToURL:url Style:style];
}

+ (URLRouteResult *)routeToModule:(NSString *)module Target:(NSString *)target Params:(NSDictionary *)params{
    return [self routeToModule:module Target:target Params:params Style:URLRouteStylePush];
}

+ (URLRouteResult *)routeToModule:(NSString *)module Target:(NSString *)target Params:(NSDictionary*)params Style:(URLRouteStyle)style{
    URLRouteResult* result = [[URLRouteResult alloc] init];
    if (module == nil || [module isEqualToString:@""]) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyModule userInfo:@{NSLocalizedDescriptionKey: @"路由模块名称为空"}];
        return result;
    }
    
    if (target == nil || [target isEqualToString:@""]) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyTarget userInfo:@{NSLocalizedDescriptionKey: @"路由目标名称为空"}];
        return result;
    }
    
    NSArray* moduleTargets = URLRouterSettings.moduleTargets[module];
    if (moduleTargets == nil || moduleTargets.count == 0) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeCantFindModule userInfo:@{NSLocalizedDescriptionKey: @"找不到路由模块"}];
        return result;
    }
    
    if (![moduleTargets containsObject:target]) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeCantFindTarget userInfo:@{NSLocalizedDescriptionKey: @"找不到路由目标"}];
        return result;
    }
    
    URLRouteAnalysisResult* analyzed = [[URLRouteAnalysisResult alloc] init];
    analyzed.prefix = URLRouterSettings.prefix;
    analyzed.module = module;
    analyzed.target = target;
    analyzed.params = [self concatParamsDictionary:params];
    
    URLRouteTargetCreateResult *created = [self.creator createTargetWithAnalyzedResult:analyzed];
    if (created == nil) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
        return result;
    }
    
    if (created.error != nil) {
        result.error = created.error;
        return result;
    }
    
    if (created.target == nil) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
        return result;
    }
    
    if (style == URLRouteStylePresentFullScreen) {
        [self presentRouteTarget:created];
    } else {
        result.error = [self pushRouteTarget:created];
    }
    
    if (result.error != nil) {
        return result;
    }
    
    result.success = true;
    return result;
}

@end
