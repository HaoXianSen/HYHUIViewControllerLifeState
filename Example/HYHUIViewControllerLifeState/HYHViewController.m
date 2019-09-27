//
//  HYHViewController.m
//  HYHUIViewControllerLifeState
//
//  Created by 1335430614@qq.com on 09/27/2019.
//  Copyright (c) 2019 1335430614@qq.com. All rights reserved.
//

#import "HYHViewController.h"
#import <HYHUIViewControllerLifeState/UIViewController+HYHLifeState.h>

@interface HYHViewController ()

@end

@implementation HYHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%ld", self.dd_lifeState);
    [self dd_executeTaskInLifeState:HYHControllerLifeViewDidAppearState executedEveryTime:NO task:^{
        NSLog(@"This code will excuted in viewDidAppear， current state: %@", [self getStateString]);
    }];
    [self dd_executeTaskInLifeState:HYHControllerLifeViewWillAppearState executedEveryTime:NO task:^{
        NSLog(@"This code will excuted in viewWillAppear， current state: %@", [self getStateString]);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%ld", self.dd_lifeState);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"%ld", self.dd_lifeState);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getStateString {
    NSString *string = @"";
    switch (self.dd_lifeState) {
        case HYHControllerLifeViewDidLoadState:
            string = @"HYHControllerLifeViewDidLoadState";
            break;
        case HYHControllerLifeViewWillAppearState:
            string = @"HYHControllerLifeViewWillAppearState";
            break;
        case HYHControllerLifeViewDidAppearState:
            string = @"HYHControllerLifeViewDidAppearState";
            break;
        case HYHControllerLifeViewWillDisappearState:
            string = @"HYHControllerLifeViewWillDisappearState";
            break;
        case HYHControllerLifeViewDidDisappearState:
            string = @"HYHControllerLifeViewDidDisappearState";
            break;
        default:
            break;
    }
    return string;
}

@end
