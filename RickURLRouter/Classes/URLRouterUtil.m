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

+ (URLRouteResult *)routeTo:(NSString *)module Target:(NSString *)target Params:(NSDictionary*)params Style:(URLRouteStyle)style{
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
    analyzed.params = params;
    
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
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController: (UIViewController*)created.target];
        naviVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [[self findCurrentController].navigationController presentViewController:naviVC animated:true completion:nil];
    } else {
        [[self findCurrentController].navigationController pushViewController:(UIViewController*)created.target animated:true];
    }
    
    result.success = true;
    return result;
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

@end
