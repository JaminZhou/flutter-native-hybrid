//
//  FlutterBridge.h
//  example
//
//  Created by JaminZhou on 2019/6/6.
//  Copyright © 2019 JaminZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <flutter_bridge/FlutterBridgePlugin.h>
#import <flutter_boost/FlutterBoost.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlutterBridge : NSObject<FlutterBridge, FLBPlatform>

@end

NS_ASSUME_NONNULL_END
