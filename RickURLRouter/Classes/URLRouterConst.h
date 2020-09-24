//
//  URLRouterConst.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString* const URLRouteErrorDomain;

typedef NS_ENUM(NSInteger, URLRouteErrorCode) {
    URLRouteErrorCodeEmptyRoute = 1,
    URLRouteErrorCodeInvalidRoute,
    URLRouteErrorCodeEmptyModule,
    URLRouteErrorCodeEmptyTarget,
    URLRouteErrorCodeInvalidParams,
    URLRouteErrorCodeInvalidRouteTarget
};

extern NSString* const HTTPScheme;
extern NSString* const HTTPSScheme;


NS_ASSUME_NONNULL_END
