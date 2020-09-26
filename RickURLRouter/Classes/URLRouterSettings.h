//
//  URLRouterSettings.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>
#import "URLRouteAnalysisResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface URLRouterSettings : NSObject

@property (nonatomic, copy, class) NSString* scheme;

@property (nonatomic, copy, class) NSString* prefix;

@property (nonatomic, copy, class) NSString* moduleEntrance;

@property (nonatomic, copy, class) NSMutableDictionary* moduleTargets;

@property (nonatomic, copy, class) NSMutableDictionary* fillParams;

@end

NS_ASSUME_NONNULL_END
