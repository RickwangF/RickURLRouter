#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "RickURLRouter.h"
#import "URLRouteAnalysisResult.h"
#import "URLRouteAnalyzer.h"
#import "URLRouteDefaultAnalyzer.h"
#import "URLRouteDefaultTargetCreator.h"
#import "URLRouter.h"
#import "URLRouterConst.h"
#import "URLRouteResult.h"
#import "URLRouterSettings.h"
#import "URLRouterUtil.h"
#import "URLRouteTargetCreateResult.h"
#import "URLRouteTargetCreator.h"

FOUNDATION_EXPORT double RickURLRouterVersionNumber;
FOUNDATION_EXPORT const unsigned char RickURLRouterVersionString[];

