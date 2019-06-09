//
//  FlutterBridge.m
//  example
//
//  Created by JaminZhou on 2019/6/6.
//  Copyright © 2019 JaminZhou. All rights reserved.
//

#import "FlutterBridge.h"

@implementation FlutterBridge
    
#pragma mark - FlutterBridge
- (void)getUserName:(FlutterResult)result {
    result(@"JaminZhou");
}
    
- (void)getAppVersion:(FlutterResult)result {
    result([[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]);
}
    
- (void)request:(NSString *)path :(NSString *)method :(NSDictionary *)parameter :(FlutterResult)result {
    NSLog(@"request path=%@, method=%@, parameter=%@", path, method, parameter);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(4);
        dispatch_async(dispatch_get_main_queue(), ^{
            result(@{@"data":@"Hello World!"});
        });
    });
    //FlutterError you can result(FlutterError)
}
    
#pragma mark - FLBPlatform
- (void)openPage:(NSString *)name
          params:(NSDictionary *)params
        animated:(BOOL)animated
      completion:(void (^)(BOOL))completion
{
    NSLog(@"openPage name: %@ params: %@", name, params);
}
    
- (void)closePage:(NSString *)uid
         animated:(BOOL)animated
           params:(NSDictionary *)params
       completion:(void (^)(BOOL))completion
{
    [FlutterBridgePlugin closePage];
}

@end
