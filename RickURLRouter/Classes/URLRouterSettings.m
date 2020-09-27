//
//  URLRouterSettings.m
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import "URLRouterSettings.h"

static NSString* _scheme;
static NSString* _prefix;
static NSString* _moduleEntrance;
static NSMutableDictionary* _fillParams;
static NSMutableDictionary* _moduleTargets;
static CreateWebTargetBlock _webTargetBlock;
static CreateNativeTargetBlock _nativeTargetBlock;

@implementation URLRouterSettings

@dynamic scheme, prefix, moduleEntrance, moduleTargets, commonParams, webTargetBlock, nativeTargetBlock;

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

+ (NSString *)moduleEntrance{
    if (!_moduleEntrance) {
        _moduleEntrance = @"index";
    }
    return [_moduleEntrance copy];
}

+ (void)setModuleEntrance:(NSString *)moduleEntrance{
    _moduleEntrance = [moduleEntrance copy];
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

+ (NSMutableDictionary *)commonParams{
    if (!_fillParams) {
        _fillParams = [NSMutableDictionary dictionary];
    }
    return [_fillParams mutableCopy];
}

+ (void)setCommonParams:(NSMutableDictionary *)fillParams{
    _fillParams = [fillParams mutableCopy];
}

+ (CreateWebTargetBlock)webTargetBlock{
    return [_webTargetBlock copy];
}

+ (void)setWebTargetBlock:(CreateWebTargetBlock)webTargetBlock{
    _webTargetBlock = [webTargetBlock copy];
}

+ (CreateNativeTargetBlock)nativeTargetBlock{
    return [_nativeTargetBlock copy];
}

+ (void)setNativeTargetBlock:(CreateNativeTargetBlock)nativeTargetBlock{
    _nativeTargetBlock = [nativeTargetBlock copy];
}

@end
