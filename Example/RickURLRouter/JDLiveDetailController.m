//
//  JDLiveDetailController.m
//  RickURLRouter_Example
//
//  Created by RickWang on 2020/9/26.
//  Copyright © 2020 Rick. All rights reserved.
//

#import "JDLiveDetailController.h"

@interface JDLiveDetailController ()

@property (nonatomic, strong) NSDictionary* routerParams;

@end

@implementation JDLiveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backBarButtonItemTapped:)];
    self.view.backgroundColor = UIColor.grayColor;
    // Do any additional setup after loading the view.
}

- (void)backBarButtonItemTapped:(UIBarButtonItem*)sender{
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

- (void)hasReceivedRouterParams:(nonnull NSDictionary<NSString *,id> *)params {
    _routerParams = params;
    NSLog(@"JDLiveDetailController received router params %@", [params description]);
}
@end
