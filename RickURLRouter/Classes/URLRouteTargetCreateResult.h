//
//  URLRouteTargetCreateResult.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/26.
//

#import <Foundation/Foundation.h>
#import "URLRouteAnalysisResult.h"
#import "URLRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface URLRouteTargetCreateResult : NSObject

@property (nonatomic, strong) URLRouteAnalysisResult *analyzed;

@property (nonatomic, copy) NSError* error;

@property (nonatomic, strong) id<URLRouter> target;

@end

NS_ASSUME_NONNULL_END
