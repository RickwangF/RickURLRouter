//
//  URLRouteDefaultTargetCreator.m
//  RickURLRouter
//
//  Created by RickWang on 2020/9/26.
//

#import "URLRouteDefaultTargetCreator.h"
#import "URLRouterConst.h"
#import "URLRouterSettings.h"

@implementation URLRouteDefaultTargetCreator

#pragma mark - Method

- (URLRouteTargetCreateResult *)createTargetWithAnalyzedResult:(URLRouteAnalysisResult *)analyzed{
    URLRouteTargetCreateResult *result = [[URLRouteTargetCreateResult alloc] init];
    
    if (analyzed == nil) {
        result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeAnalyzeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由解析失败"}];
        return result;
    }
    
    result.analyzed = analyzed;
    if (analyzed.error != nil) {
        result.error = analyzed.error;
        return result;
    }
    
    if (analyzed.url != nil) {
        if (!URLRouterSettings.webTargetBlock) {
            result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败，请设置webTargetBlock"}];
            return result;
        }
        
        result.target = URLRouterSettings.webTargetBlock(analyzed);
        if (!result.target) {
            result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
        }
    } else {
        if (URLRouterSettings.nativeTargetBlock != nil) {
            result.target = URLRouterSettings.nativeTargetBlock(analyzed);
            if (!result.target) {
                result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
            }
        } else {
            NSString* className = [NSString stringWithFormat:@"%@%@%@Controller", analyzed.prefix.uppercaseString, analyzed.module.capitalizedString, analyzed.target.capitalizedString];
            Class vcClz = NSClassFromString(className);
            if (vcClz == Nil || vcClz == nil) {
                result.error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeTargetInitializeFailure userInfo:@{NSLocalizedDescriptionKey: @"路由目标初始化失败"}];
                return result;
            }
            
            if ([vcClz conformsToProtocol:@protocol(URLRouter)]) {
                result.target = [[vcClz alloc] init];
                [((id<URLRouter>)result.target) hasReceivedRouterParams:analyzed.params];
            }
        }
    }
    
    return result;
}

@end
