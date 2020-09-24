//
//  URLRouterSettings.m
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import "URLRouterSettings.h"

static NSString* _scheme;
static NSString* _prefix;
static NSMutableDictionary* _fillParams;
static NSMutableDictionary* _moduleTargets;

@implementation URLRouterSettings

@dynamic scheme, prefix, moduleTargets, fillParams;

#pragma mar - Getter && Setter

+ (NSString *)scheme{
    if (!_scheme) {
        _scheme = @"rick";
    }
    return [_scheme copy];
}

+ (void)setScheme:(NSString *)scheme{
    _scheme = [scheme copy];
}

+ (NSString *)prefix{
    if (!_prefix) {
        _prefix = @"w";
    }
    return [_prefix copy];
}

+ (void)setPrefix:(NSString *)prefix{
    _prefix = [prefix copy];
}

+ (NSMutableDictionary *)moduleTargets{
    if (!_moduleTargets) {
        _moduleTargets = [NSMutableDictionary dictionary];
    }
    return [_moduleTargets mutableCopy];
}

+ (void)setModuleTargets:(NSMutableDictionary *)moduleTargets{
    _moduleTargets = [moduleTargets mutableCopy];
}

+ (NSMutableDictionary *)fillParams{
    if (!_fillParams) {
        _fillParams = [NSMutableDictionary dictionary];
    }
    return [_fillParams mutableCopy];
}

+ (void)setFillParams:(NSMutableDictionary *)fillParams{
    _fillParams = [fillParams mutableCopy];
}

@end
