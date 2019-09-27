//
//  UIViewController+DDLifeStatus.h
//  AFNetworking
//
//  Created by harry on 2019/9/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HYHControllerLifeState) {
    HYHControllerLifeViewDidLoadState,
    HYHControllerLifeViewWillAppearState,
    HYHControllerLifeViewDidAppearState,
    HYHControllerLifeViewWillDisappearState,
    HYHControllerLifeViewDidDisappearState
};

typedef void(^HYHLifeExecuteTask)(void);

@interface UIViewController (HYHLifeState)

@property (nonatomic, assign) HYHControllerLifeState dd_lifeState;

/**
 Execute a task on specified state，isExecutedEveryTime is YES task will every specified state executed, NO is Not.

 @param state specified task executed state
 @param isExecutedEveryTime is or not everytime execute on specified state
 @param task excuted block
 */
- (void)dd_executeTaskInLifeState:(HYHControllerLifeState)state executedEveryTime:(BOOL)isExecutedEveryTime task:(HYHLifeExecuteTask)task;

@end

NS_ASSUME_NONNULL_END
