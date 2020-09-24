//
//  URLRouterAnalysis.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "URLRouteAnalysisResult.h"
#import "URLRouteResult.h"
#import "URLRouteAnalyzer.h"

NS_ASSUME_NONNULL_BEGIN

@interface URLRouterUtil : NSObject

@property (nonatomic, strong, class) id<URLRouteAnalyzer> analyzer;

+ (URLRouteResult*)routeTo:(NSString*)module Target:(NSString*)target;

+ (URLRouteResult*)routeWithURL:(NSURL*)url;

+ (URLRouteResult*)routeWithURLString:(NSString*)urlString;

@end

NS_ASSUME_NONNULL_END
