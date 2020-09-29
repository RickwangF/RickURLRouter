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
    
    return YES;
}

- (URLRouteAnalysisResult * _Nonnull)analyzeHTTPURL:(URLRouteAnalysisResult *)result url:(NSURL * _Nonnull)url {
    // 先校验URL是否有效
    if (![self isValidHttpURL:url]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址不正确"}];
        result.error = error;
        return result;
    }
    
    // 取出URL的全部地址
    NSString* urlString;
    if (url.absoluteString == nil || [url.absoluteString isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址不正确"}];
        result.error = error;
        return result;
    }
    
    urlString = url.absoluteString;
    
    // 分离Host和Params字符串
    NSString* schemeHostString, *paramsString;
    NSRange range = [urlString rangeOfString:@"?" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        schemeHostString = [urlString substringToIndex:range.location];
        if (range.location < urlString.length - 1) {
            paramsString = [urlString substringFromIndex:range.location + 1];
        }
    } else {
        schemeHostString = urlString;
    }
    
    // 解析参数字符串并加入公共参数
    NSDictionary* urlParams = [self mixCommonParams:paramsString];
    result.params = urlParams;
    NSString* fullFillParamString = [self combineAllParams:urlParams];
    if (fullFillParamString != nil && ![fullFillParamString isEqualToString:@""]) {
        NSString* fullFillUrlString = [NSString stringWithFormat:@"%@?%@", schemeHostString, fullFillParamString];
        result.url = [NSURL URLWithString:fullFillUrlString];
    } else {
        result.url = url;
    }
    
    return result;
}

- (URLRouteAnalysisResult * _Nonnull)analyzeNativeURL:(URLRouteAnalysisResult *)result url:(NSURL * _Nonnull)url {
    NSString* urlString;
    if (url.absoluteString == nil || [url.absoluteString isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址不正确"}];
        result.error = error;
        return result;
    }
    
    urlString = url.absoluteString;
    
    // 截取路由目标地和参数字符串
    
    NSString *pureHostString, *paramsString;
    if (url.host != nil && ![url.host isEqualToString:@""]) {
        pureHostString = url.host.lowercaseString;
    }
    
    if (pureHostString == nil) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址host不正确"}];
        result.error = error;
        return result;
    }
    
    NSRange range = [urlString rangeOfString:@"?" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        if (range.location < urlString.length - 1) {
            paramsString = [urlString substringFromIndex:range.location + 1];
        }
    }
    
    // 路由目标地解析
    NSArray* hostComponentArray = [pureHostString componentsSeparatedByString:@"."];
    if (hostComponentArray == nil || hostComponentArray.count == 0) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址host不正确"}];
        result.error = error;
        return result;
    }
    
    NSString *prefix, *module, *target;
    if (hostComponentArray.count == 3) {
        prefix = hostComponentArray[0];
        module = hostComponentArray[1];
        target = [hostComponentArray[2] mutableCopy];
    }
    
    if (prefix == nil || [prefix isEqualToString:@""] || ![prefix isEqualToString:URLRouterSettings.prefix]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址host的prefix不正确"}];
        result.error = error;
        return result;
    }
    
    if (module == nil || [module isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyModule userInfo:@{NSLocalizedDescriptionKey:@"路由module为空"}];
        result.error = error;
        return result;
    }
    
    NSArray* moduleTargets = URLRouterSettings.moduleTargets[module];
    if (moduleTargets == nil || moduleTargets.count == 0) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeCantFindModule userInfo:@{NSLocalizedDescriptionKey:@"找不到路由的module"}];
        result.error = error;
        return result;
    }
    
    
    if (target == nil || [target isEqualToString:@""]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyTarget userInfo:@{NSLocalizedDescriptionKey:@"路由target为空"}];
        result.error = error;
        return result;
    }
    
    // 查看路由目标地是否匹配
    if (![moduleTargets containsObject:target]) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeCantFindTarget userInfo:@{NSLocalizedDescriptionKey:@"找不到路由目标地"}];
        result.error = error;
        return result;
    }
    
    result.prefix = prefix;
    result.module = module;
    result.target = target;
    
    // 解析参数
    NSDictionary* urlParams = [self mixCommonParams:paramsString];
    result.params = urlParams;
    
    return result;
}

- (nonnull URLRouteAnalysisResult *)analyzeRouteURL:(nonnull NSURL *)url {
    
    URLRouteAnalysisResult *result = [[URLRouteAnalysisResult alloc] init];
    
    if (url == nil) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeEmptyRoute userInfo:@{NSLocalizedDescriptionKey:@"路由地址为空"}];
        result.error = error;
        return result;
    }
    
    if (url.scheme == nil ||
        (![url.scheme isEqualToString: URLRouterSettings.scheme] &&
        ![url.scheme isEqualToString:HTTPScheme] &&
        ![url.scheme isEqualToString:HTTPSScheme])) {
        NSError *error = [NSError errorWithDomain:URLRouteErrorDomain code:URLRouteErrorCodeInvalidRoute userInfo:@{NSLocalizedDescriptionKey:@"路由Scheme错误"}];
        result.error = error;
        return result;
    }
    
    // HTTP,HTTPS链接
    if ([url.scheme isEqualToString:HTTPScheme] || [url.scheme isEqualToString:HTTPSScheme]) {
        [self analyzeHTTPURL:result url:url];
    }
    
    // 原生链接
    if ([url.scheme isEqualToString:URLRouterSettings.scheme]) {
        [self analyzeNativeURL:result url:url];
    }
    
    return result;
}

- (NSDictionary*)mixCommonParams:(NSString*)paramsString{
    NSMutableDictionary *paramsDictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *mixedParamsDic = [NSMutableDictionary dictionary];
    if (paramsString == nil || [paramsString isEqualToString:@""]){
        if (URLRouterSettings.commonParams.count > 0) {
            [mixedParamsDic setDictionary:URLRouterSettings.commonParams];
        }
        return [mixedParamsDic copy];
    }
    
    NSArray* componentArray = [paramsString componentsSeparatedByString:@"&"];
    if (componentArray == nil || componentArray.count == 0){
        if (URLRouterSettings.commonParams.count > 0) {
            [mixedParamsDic setDictionary:URLRouterSettings.commonParams];
        }
        return [mixedParamsDic copy];
    }
    
    [componentArray enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray* subComponentArr = [obj componentsSeparatedByString:@"="];
        if (subComponentArr == nil || subComponentArr.count == 0) {
            return;
        }
        
        if (subComponentArr.count == 2) {
            NSString* key = [self decodeURLString:subComponentArr[0]];
            NSString* value = [self decodeURLString: subComponentArr[1]];
            [paramsDictionary setObject:value forKey:key];
        }
    }];
    
    if (paramsDictionary.count == 0) {
        if (URLRouterSettings.commonParams.count > 0) {
            [mixedParamsDic setDictionary:URLRouterSettings.commonParams];
        }
        return [mixedParamsDic copy];
    }
    
    if (URLRouterSettings.commonParams.count > 0) {
        [mixedParamsDic setDictionary:URLRouterSettings.commonParams];
    }
    
    [paramsDictionary enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![[mixedParamsDic allKeys] containsObject:key]) {
            [mixedParamsDic setObject:obj forKey:key];
        }
    }];
    
    return [mixedParamsDic copy];
}

- (NSString *)encodeURLString:(NSString*)originString{
    if (originString == nil || [originString isEqualToString:@""]) {
        return @"";
    }
    
    NSMutableCharacterSet* set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    return [originString stringByAddingPercentEncodingWithAllowedCharacters:set];
}

- (NSString*)decodeURLString:(NSString*)urlString {
    if (urlString == nil || [urlString isEqualToString:@""]) {
        return @"";
    }
    
    NSMutableCharacterSet *set = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [set addCharactersInString:@"#"];
    return [urlString stringByRemovingPercentEncoding];
}

- (NSString*)combineAllParams:(NSDictionary*)fullFillParams{
    NSMutableString* allParamsString = [NSMutableString string];
    if (fullFillParams == nil || fullFillParams.count == 0) {
        return [allParamsString copy];
    }
    
    [fullFillParams enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [allParamsString appendFormat:@"%@=%@&", [self encodeURLString:key], [self encodeURLString:[obj description]]];
    }];
    
    allParamsString = [[allParamsString substringToIndex:allParamsString.length-1] mutableCopy];
    return [allParamsString copy];
}

@end
