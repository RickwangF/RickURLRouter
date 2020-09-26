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

- (BOOL)isValidHttpURL:(NSURL*)url{
    
    if (url == nil) {
        return NO;
    }
    
    if ([url isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:(NSString*)url];
    }
    
    if (url == nil) {
        return NO;
    }
    
    NSString *regex =@"http[s]{0,1}://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:[url absoluteString]];
    
//    if (![UIApplication.sharedApplication canOpenURL:url]) {
//        return NO;
//    }
    
    return YES;
}

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
    
    // HTTP,HTTPS链接
    if ([url.scheme isEqualToString:HTTPScheme] || [url.scheme isEqualToString:HTTPSScheme]) {
        if (![self isValidHttpURL:url]) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址不正确"}];
            result.error = error;
            return result;
        }
        
        NSString* urlString;
        if (url.absoluteString == nil || [url.absoluteString isEqualToString:@""]) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址不正确"}];
            result.error = error;
            return result;
        }
        
        urlString = url.absoluteString.lowercaseString;
        
        NSString* schemeHostString, *paramsString;
        NSRange range = [urlString rangeOfString:@"?" options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            schemeHostString = [urlString substringToIndex:range.location];
            paramsString = [urlString substringFromIndex:range.location];
        }
        
        if (paramsString != nil && ![paramsString isEqualToString:@""]) {
            NSDictionary* urlParams = [self fullFillParams:paramsString];
            result.params = [self decodeURLParams:urlParams];
            NSString* fullFillParamString = [self combineFullFillParams:urlParams];
            if (fullFillParamString != nil && ![fullFillParamString isEqualToString:@""]) {
                NSString* fullFillUrlString = [NSString stringWithFormat:@"%@?%@", schemeHostString, fullFillParamString];
                result.url = [NSURL URLWithString:fullFillUrlString];
            }
        } else {
            result.url = url;
        }
        
        return result;
    }
    
    // 原生链接
    if ([url.scheme isEqualToString:URLRouterSettings.scheme]) {
        
        NSString* urlString;
        if (url.absoluteString == nil || [url.absoluteString isEqualToString:@""]) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址不正确"}];
            result.error = error;
            return result;
        }
        
        urlString = url.absoluteString.lowercaseString;
        
        // 截取路由目标地和参数字符串
        
        NSString *pureHostString, *paramsString;
        if (url.host != nil && ![url.host isEqualToString:@""]) {
            pureHostString = url.host;
        }
        
        if (pureHostString == nil) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址host不正确"}];
            result.error = error;
            return result;
        }
        
        NSRange range = [urlString rangeOfString:@"?" options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            paramsString = [urlString substringFromIndex:range.location];
        }
        
        // 路由目标地解析
        NSArray* hostComponentArray = [pureHostString componentsSeparatedByString:@"."];
        if (hostComponentArray == nil || hostComponentArray.count == 0) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址host不正确"}];
            result.error = error;
            return result;
        }
        
        NSString *prefix, *module;
        NSMutableString *target;
        if (hostComponentArray.count == 3) {
            prefix = hostComponentArray[0];
            module = hostComponentArray[1];
            target = [hostComponentArray[2] mutableCopy];
        }
        
        if (prefix == nil || [prefix isEqualToString:@""] || ![prefix isEqualToString:URLRouterSettings.prefix]) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址host的prefix不正确"}];
            result.error = error;
            return result;
        }
        
        if (module == nil || [module isEqualToString:@""] || URLRouterSettings.moduleTargets[module] == nil) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址host的module不正确"}];
            result.error = error;
            return result;
        }
        
        if (target == nil || [target isEqualToString:@""]) {
            NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSURLErrorKey:@"路由地址host的target不正确"}];
            result.error = error;
            return result;
        }
        
        if ([target isEqualToString:URLRouterSettings.moduleEntrance]) {
            target = [@"" mutableCopy];
        }
        
        // 查看路由目标地是否匹配
        
        // 解析参数字符串
        
        // 实例化路由目标地
    }
    
    return result;
}

- (NSDictionary*)fullFillParams:(NSString*)paramsString{
    NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *fullFillParamsDic = [NSMutableDictionary dictionary];
    NSArray* componentArray = [paramsString componentsSeparatedByString:@"&"];
    if (componentArray == nil || componentArray.count == 0){
        return [fullFillParamsDic copy];
    }
    
    [componentArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray* subComponentArr = [obj componentsSeparatedByString:@"="];
        if (subComponentArr == nil || subComponentArr.count == 0) {
            return;
        }
        
        if (subComponentArr.count == 2) {
            NSString* key = subComponentArr[0];
            NSString* value = subComponentArr[1];
            [paramsDictionary setObject:value forKey:key];
        }
    }];
    
    if (paramsDictionary.count == 0) {
        return [fullFillParamsDic copy];
    }
    
    [paramsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([[URLRouterSettings.fillParams allKeys] containsObject:key]) {
            id fillObj = [URLRouterSettings.fillParams objectForKey:key];
            if (!fillObj) {
                [fullFillParamsDic setObject:obj forKey:key];
            } else {
                [fullFillParamsDic setObject:[fillObj description] forKey:key];
            }
        } else {
            [fullFillParamsDic setObject:obj forKey:key];
        }
    }];
    
    return [fullFillParamsDic copy];
}

- (NSString*)decodeURLString:(NSString*)urlString {
    if (urlString == nil || [urlString isEqualToString:@""]) {
        return @"";
    }
    
    return [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
}

- (NSDictionary*)decodeURLParams:(NSDictionary*)dictionary{
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionary];
    if (paramsDic == nil || paramsDic.count == 0) {
        return [paramsDic copy];
    }
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString* decodeValue = [self decodeURLString:obj];
        [paramsDic setObject:decodeValue forKey:key];
    }];
    return [paramsDic copy];
}

- (NSString*)combineFullFillParams:(NSDictionary*)fullFillParams{
    NSMutableString* fullFillString = [NSMutableString string];
    if (fullFillParams == nil || fullFillParams.count == 0) {
        return [fullFillString copy];
    }
    
    [fullFillParams enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        [fullFillString appendString:key];
        [fullFillString appendFormat:@"%@=%@&", key, obj];
    }];
    
    fullFillString = [[fullFillString substringToIndex:fullFillString.length-1] mutableCopy];
    return [fullFillString copy];
}

@end
