//
//  URLRouteDefaultAnalyzer.m
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import "URLRouteDefaultAnalyzer.h"
#import "URLRouterConst.h"
#import "URLRouterSettings.h"

@implementation URLRouteDefaultAnalyzer

- (nonnull URLRouteAnalysisResult *)analyzeRouteURL:(nonnull NSURL *)url {
    
    URLRouteAnalysisResult *result = [[URLRouteAnalysisResult alloc] init];
    
    if (url == nil) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyRoute userInfo:@{NSURLErrorKey:@"路由地址为空"}];
        result.error = error;
        return result;
    }
    
    if (url.scheme == nil ||
        ![url.scheme isEqualToString: URLRouterSettings.scheme] ||
        ![url.scheme isEqualToString:HTTPScheme] ||
        ![url.scheme isEqualToString:HTTPSScheme]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由Scheme错误"}];
        result.error = error;
        return result;
    }
    
    if (url) {
        
    }
    
    return result;
}

@end
