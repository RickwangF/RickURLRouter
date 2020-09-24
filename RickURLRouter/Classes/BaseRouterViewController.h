//
//  BaseRouterViewController.h
//  Pods
//
//  Created by RickWang on 2020/9/24.
//

#import <UIKit/UIKit.h>
#import "URLRouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseRouterViewController : UIViewController<URLRouter>

@property (nonatomic, copy) NSDictionary* routerParams;

@end

NS_ASSUME_NONNULL_END
