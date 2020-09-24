//
//  URLRouteAnalyzer.h
//  Pods
//
//  Created by RickWang on 2020/9/24.
//

#ifndef URLRouteAnalyzer_h
#define URLRouteAnalyzer_h
#import "URLRouteAnalysisResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol URLRouteAnalyzer <NSObject>

- (URLRouteAnalysisResult*)analyzeRouteURL:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END

#endif /* URLRouteAnalyzer_h */
