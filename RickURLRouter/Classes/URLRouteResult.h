//
//  URLRouteResult.h
//  RickURLRouter
//
//  Created by RickWang on 2020/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLRouteResult : NSObject

@property (nonatomic, copy) NSError* error;

@property (nonatomic, assign) BOOL success;

@end

NS_ASSUME_NONNULL_END
