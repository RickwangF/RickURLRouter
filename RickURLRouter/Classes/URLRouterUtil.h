//
//  URLRouterAnalysis.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "URLRouterConst.h"
#import "URLRouteAnalysisResult.h"
#import "URLRouteResult.h"
#import "URLRouteAnalyzer.h"
#import "URLRouteTargetCreator.h"

NS_ASSUME_NONNULL_BEGIN

@interface URLRouterUtil : NSObject

@property (nonatomic, strong, class) id<URLRouteAnalyzer> analyzer;

@property (nonatomic, strong, class) id<URLRouteTargetCreator> creator;

+ (NSString *)encodeURLString:(NSString*)originString;

+ (NSString *)decodeURLString:(NSString*)encodedString;

+ (URLRouteResult*)routeTo:(NSString*)module Target:(NSString*)target Params:(NSDictionary*)params;

+ (URLRouteResult*)routeWithURL:(NSURL*)url;

+ (URLRouteResult*)routeWithURLString:(NSString*)urlString;

+ (URLRouteResult*)routeTo:(NSString*)module Target:(NSString*)target Params:(NSDictionary*)params Style:(URLRouteStyle)style;

+ (URLRouteResult*)routeWithURL:(NSURL*)url Style:(URLRouteStyle)style;

+ (URLRouteResult*)routeWithURLString:(NSString*)urlString Style:(URLRouteStyle)style;

@end

NS_ASSUME_NONNULL_END
