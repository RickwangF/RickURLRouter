//
//  URLRouter.h
//  Pods
//
//  Created by RickWang on 2020/9/24.
//

#ifndef URLRouter_h
#define URLRouter_h

NS_ASSUME_NONNULL_BEGIN

@protocol URLRouter <NSObject>

- (void)hasReceivedRouterParams:(NSDictionary<NSString*, id> *)params;

@end


NS_ASSUME_NONNULL_END

#endif /* URLRouter_h */
