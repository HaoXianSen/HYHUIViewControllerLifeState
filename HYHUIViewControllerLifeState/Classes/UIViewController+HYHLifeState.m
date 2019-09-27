//
//  UIViewController+DDLifeStatus.m
//  AFNetworking
//
//  Created by harry on 2019/9/27.
//

#import "UIViewController+HYHLifeState.h"
#import <objc/runtime.h>

@interface NSObject (HYHMethodSizzle)

+ (void)swizzleClassMethod:(SEL)originalSelector
        withOverrideMethod:(SEL)overrideSelector;

+ (void)swizzleInstanceMethod:(SEL)originalSelector
           withOverrideMethod:(SEL)overrideSelector;

@end

@implementation NSObject (HYHMethodSizzle)

+ (void)swizzleClassMethod:(SEL)originalSelector
        withOverrideMethod:(SEL)overrideSelector
{
    Class metaClass       = object_getClass(self);
    
    Method originalMethod = class_getInstanceMethod(metaClass, originalSelector);
    
    NSAssert( originalMethod != NULL,
             @"Original method +[%@ %@] does not exist.",
             NSStringFromClass(self),
             NSStringFromSelector(originalSelector) );
    
    Method overrideMethod = class_getInstanceMethod(metaClass, overrideSelector);
    NSAssert( overrideMethod != NULL,
             @"Override method +[%@ %@] does not exist.",
             NSStringFromClass(self),
             NSStringFromSelector(overrideSelector) );
    
    if (originalMethod == overrideMethod)
    {
        return;
    }
    
    class_addMethod( metaClass,
                    originalSelector,
                    class_getMethodImplementation(self, originalSelector),
                    method_getTypeEncoding(originalMethod) );
    class_addMethod( metaClass,
                    overrideSelector,
                    class_getMethodImplementation(self, overrideSelector),
                    method_getTypeEncoding(overrideMethod) );
    
    method_exchangeImplementations( class_getInstanceMethod(metaClass, originalSelector),
                                   class_getInstanceMethod(metaClass, overrideSelector) );
} /* swizzleClassMethod */

+ (void)swizzleInstanceMethod:(SEL)originalSelector
           withOverrideMethod:(SEL)overrideSelector
{
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    
    NSAssert( originalMethod != NULL,
             @"Original method -[%@ %@] does not exist.",
             NSStringFromClass(self),
             NSStringFromSelector(originalSelector) );
    
    Method overrideMethod = class_getInstanceMethod(self, overrideSelector);
    NSAssert( overrideMethod != NULL,
             @"Override method -[%@ %@] does not exist.",
             NSStringFromClass(self),
             NSStringFromSelector(overrideSelector) );
    
    if (originalMethod == overrideMethod)
    {
        return;
    }
    
    class_addMethod( self,
                    originalSelector,
                    class_getMethodImplementation(self, originalSelector),
                    method_getTypeEncoding(originalMethod) );
    class_addMethod( self,
                    overrideSelector,
                    class_getMethodImplementation(self, overrideSelector),
                    method_getTypeEncoding(overrideMethod) );
    
    method_exchangeImplementations( class_getInstanceMethod(self, originalSelector),
                                   class_getInstanceMethod(self, overrideSelector) );
}
@end

@interface DDLifeExecuteTaskModel : NSObject

@property (nonatomic, assign) HYHControllerLifeState state;

@property (nonatomic, copy) HYHLifeExecuteTask task;

@property (nonatomic, assign) BOOL isEveryTimeExecute;

- (instancetype)initWithState:(HYHControllerLifeState)state everyTimeExecute:(BOOL)isEveryTimeExecute executeTask:(HYHLifeExecuteTask)task;

+ (instancetype)ddLifeExecuteTaskModelWithState:(HYHControllerLifeState)state everyTimeExecute:(BOOL)isEveryTimeExecute executeTask:(HYHLifeExecuteTask)task;

@end

@implementation DDLifeExecuteTaskModel

- (instancetype)initWithState:(HYHControllerLifeState)state everyTimeExecute:(BOOL)isEveryTimeExecute executeTask:(HYHLifeExecuteTask)task {
    if (self = [super init]) {
        _state = state;
        _task = task;
        _isEveryTimeExecute = isEveryTimeExecute;
    }
    return self;
}

+ (instancetype)ddLifeExecuteTaskModelWithState:(HYHControllerLifeState)state everyTimeExecute:(BOOL)isEveryTimeExecute executeTask:(HYHLifeExecuteTask)task {
    return [[self alloc] initWithState:state everyTimeExecute:isEveryTimeExecute executeTask:task];
}


@end

@implementation UIViewController (HYHLifeState)

@dynamic dd_lifeState;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(viewDidLoad) withOverrideMethod:@selector(_ddViewDidLoad)];
        [self swizzleInstanceMethod:@selector(viewWillAppear:) withOverrideMethod:@selector(_ddViewWillAppear:)];
        [self swizzleInstanceMethod:@selector(viewDidAppear:) withOverrideMethod:@selector(_ddViewDidAppear:)];
        [self swizzleInstanceMethod:@selector(viewWillDisappear:) withOverrideMethod:@selector(_ddViewDidDisappear:)];
        [self swizzleInstanceMethod:@selector(viewDidDisappear:) withOverrideMethod:@selector(_ddViewDidDisappear:)];
    });
}

- (void)setDd_lifeState:(HYHControllerLifeState)dd_lifeState {
    
    objc_setAssociatedObject(self, _cmd, @(dd_lifeState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (HYHControllerLifeState)dd_lifeState {
    
    return [objc_getAssociatedObject(self, @selector(setDd_lifeState:)) unsignedIntegerValue];
}

- (NSMutableArray *)dd_tasks {
    NSMutableArray *tasks = objc_getAssociatedObject(self, _cmd);
    if (tasks == nil) {
        tasks = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, tasks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tasks;
}

- (void)_ddViewDidLoad {
    self.dd_lifeState = HYHControllerLifeViewDidLoadState;
    [self _ddViewDidLoad];
    [self _dd_executeTaskWithState:self.dd_lifeState];
}

- (void)_ddViewWillAppear:(BOOL)animated {
    self.dd_lifeState = HYHControllerLifeViewWillAppearState;
    [self _ddViewWillAppear:animated];
    [self _dd_executeTaskWithState:self.dd_lifeState];
}

- (void)_ddViewDidAppear:(BOOL)animated {
    self.dd_lifeState = HYHControllerLifeViewDidAppearState;
    [self _ddViewDidAppear:animated];
    [self _dd_executeTaskWithState:self.dd_lifeState];
}

- (void)_ddViewWillDisappear:(BOOL)animated {
    self.dd_lifeState = HYHControllerLifeViewWillDisappearState;
    [self _ddViewWillDisappear:animated];
    [self _dd_executeTaskWithState:self.dd_lifeState];
}

- (void)_ddViewDidDisappear:(BOOL)animated {
    self.dd_lifeState = HYHControllerLifeViewDidDisappearState;
    [self _ddViewDidDisappear:animated];
    [self _dd_executeTaskWithState:self.dd_lifeState];
}

- (void)dd_executeTaskInLifeState:(HYHControllerLifeState)state executedEveryTime:(BOOL)isExecutedEveryTime task:(HYHLifeExecuteTask)task; {
    DDLifeExecuteTaskModel *model = [DDLifeExecuteTaskModel ddLifeExecuteTaskModelWithState:state everyTimeExecute:isExecutedEveryTime executeTask:task];
    [[self dd_tasks] addObject:model];
    if (self.dd_lifeState == state) {
        [self _dd_executeTaskWithState:self.dd_lifeState];
    }
}

- (void)_dd_executeTaskWithState:(HYHControllerLifeState)state {
    if ([self dd_tasks].count > 0) {
        NSArray *tempArray = [NSArray arrayWithArray:[self dd_tasks]];
        [tempArray enumerateObjectsUsingBlock:^(DDLifeExecuteTaskModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.state == state) {
                obj.task();
                if (!obj.isEveryTimeExecute) {
                    [[self dd_tasks] removeObject:obj];                    
                }
            }
        }];
    }
}

@end

