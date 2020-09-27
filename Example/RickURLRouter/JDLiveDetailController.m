//
//  JDLiveDetailController.m
//  RickURLRouter_Example
//
//  Created by RickWang on 2020/9/26.
//  Copyright © 2020 Rick. All rights reserved.
//

#import "JDLiveDetailController.h"
#import <MJExtension/MJExtension.h>

@interface JDLiveDetailController ()

@property (nonatomic, strong) NSDictionary* routerParams;

@end

@implementation JDLiveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    // Do any additional setup after loading the view.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)hasReceivedRouterParams:(nonnull NSDictionary<NSString *,id> *)params {
    _routerParams = params;
    NSLog(@"JDLiveDetailController received router params %@", [params mj_JSONString]);
}
@end
