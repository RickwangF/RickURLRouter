//
//  URLRouteAnalysisResult.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLRouteAnalysisResult : NSObject

@property (nonatomic, copy) NSError* error;

@property (nonatomic, copy) NSString* prefix;

@property (nonatomic, copy) NSString* module;

@property (nonatomic, copy) NSString* target;

@property (nonatomic, copy) NSString* path;

@property (nonatomic, copy) NSDictionary* params;

@end

NS_ASSUME_NONNULL_END
