//
//  URLRouteTargetCreator.h
//  Pods
//
//  Created by RickWang on 2020/9/26.
//

#ifndef URLRouteTargetCreator_h
#define URLRouteTargetCreator_h
#import "URLRouteAnalysisResult.h"
#import "URLRouteTargetCreateResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol URLRouteTargetCreator <NSObject>

- (URLRouteTargetCreateResult*)createTargetWithAnalyzedResult:(URLRouteAnalysisResult*)analyzed;

@end

NS_ASSUME_NONNULL_END

#endif /* URLRouteTargetCreator_h */
