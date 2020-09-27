//
//  URLRouterSettings.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "URLRouteAnalysisResult.h"
#import "URLRouter.h"


NS_ASSUME_NONNULL_BEGIN

typedef id<URLRouter>_Nullable(^CreateWebTargetBlock)(URLRouteAnalysisResult* result);
typedef id<URLRouter>_Nullable(^CreateNativeTargetBlock)(URLRouteAnalysisResult* result);

@interface URLRouterSettings : NSObject

@property (nonatomic, copy, class) NSString* scheme;

@property (nonatomic, copy, class) NSString* prefix;

@property (nonatomic, copy, class) NSString* moduleEntrance;

@property (nonatomic, copy, class) NSMutableDictionary* moduleTargets;

@property (nonatomic, copy, class) NSMutableDictionary* commonParams;

@property (nonatomic, copy, class) CreateWebTargetBlock webTargetBlock;

@property (nonatomic, copy, class) CreateNativeTargetBlock nativeTargetBlock;

@end

NS_ASSUME_NONNULL_END
