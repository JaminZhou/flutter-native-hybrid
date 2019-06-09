#import "FlutterBridgePlugin.h"
#import <flutter_boost/FlutterBoost.h>
#import <objc/runtime.h>

@interface FLBFlutterViewContainer(Addition)
@property (nonatomic) BOOL previousNavHidden;
@end

@implementation FLBFlutterViewContainer(Addition)

static char kPreviousNavHiddenKey;
    
- (void)setPreviousNavHidden:(BOOL)previousNavHidden {
    objc_setAssociatedObject(self, &kPreviousNavHiddenKey, @(previousNavHidden), OBJC_ASSOCIATION_ASSIGN);
}
    
- (BOOL)previousNavHidden {
    return [objc_getAssociatedObject(self, &kPreviousNavHiddenKey) boolValue];
}
    
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzlingSelector:@selector(flutter_viewWillAppear:) originalSelector:@selector(viewWillAppear:)];
        [self swizzlingSelector:@selector(flutter_viewWillDisappear:) originalSelector:@selector(viewWillDisappear:)];
    });
}
    
#pragma mark - Method Swizzling
+ (void)swizzlingSelector:(SEL)swizzledSelector originalSelector:(SEL)originalSelector {
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
    
- (void)flutter_viewWillAppear:(BOOL)animated {
    [self flutter_viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    self.previousNavHidden = self.navigationController.navigationBar.hidden;
    self.navigationController.navigationBar.hidden = YES;
}
    
- (void)flutter_viewWillDisappear:(BOOL)animated {
    [self flutter_viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = self.previousNavHidden;
}
    
    @end

@interface FlutterBridgePlugin()
    @property (nonatomic) id<FlutterBridge> bridge;
    @end

@implementation FlutterBridgePlugin
    
+ (instancetype)shared {
    static id instance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[FlutterBridgePlugin alloc] init];
    });
    return instance;
}
    
+ (FLBFlutterViewContainer *)FLBFlutterViewContainer:(NSString *)name params:(NSDictionary *)params {
    FLBFlutterViewContainer *vc = FLBFlutterViewContainer.new;
    [vc setName:name params:params];
    return vc;
}
    
+ (void)closePage {
    UIViewController *vc = [[self class] topViewController];
    UINavigationController *nav = vc.navigationController;
    if (nav.viewControllers.count>1) {
        [nav popViewControllerAnimated:YES];
    } else {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
}
    
+ (UIViewController *)topViewController {
    //目前暂时不考虑特殊情况：多个window
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;//[[UIApplication sharedApplication].windows firstObject];
    return [self topViewController:keyWindow.rootViewController];
}
    
+ (UIViewController *)topViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedViewController = [(UITabBarController *)rootViewController selectedViewController];
        return [self topViewController:selectedViewController];
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UIViewController *lastViewController = [[(UINavigationController *)rootViewController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    if (rootViewController.presentedViewController) {
        return [self topViewController:rootViewController.presentedViewController];
    }
    
    return rootViewController;
}
    
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"flutter_bridge" binaryMessenger:[registrar messenger]];
    FlutterBridgePlugin *instance = [FlutterBridgePlugin shared];
    [registrar addMethodCallDelegate:instance channel:channel];
}
    
+ (void)registerFlutterBridge:(id<FlutterBridge>)bridge {
    [FlutterBridgePlugin shared].bridge = bridge;
}
    
#pragma mark - FlutterPlugin
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if (!self.bridge) {
        result(FlutterMethodNotImplemented);
        return;
    }
    NSString *method = call.method;
    NSArray *arguments = call.arguments;
    for (int i=0; i<arguments.count; i++) {
        method = [method stringByAppendingString:@":"];
    }
    SEL selector = NSSelectorFromString(method);
    
    //异步处理，channel回调需要在主线程
    method = [method stringByAppendingString:@":"];
    selector = NSSelectorFromString(method);
    if (!arguments) arguments = [NSArray array];
    NSMutableArray *mutableArguments = [arguments mutableCopy];
    [mutableArguments addObject:result];
    arguments = [mutableArguments copy];
    
    if ([self.bridge respondsToSelector:selector]) {
        NSMethodSignature *signature = [[self.bridge class] instanceMethodSignatureForSelector:selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.target = self.bridge;
        invocation.selector = selector;
        
        if (signature.numberOfArguments>2) {
            NSInteger count = signature.numberOfArguments - 2;// 除self、_cmd以外
            count = MIN(count, arguments.count);
            for (NSInteger i = 0; i < count; i++) {
                id object = arguments[i];
                [invocation setArgument:&object atIndex:i + 2];
            }
        }
        
        [invocation invoke];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
