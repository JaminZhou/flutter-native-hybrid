//
//  FlutterBridge.h
//  example
//
//  Created by JaminZhou on 2019/6/6.
//  Copyright © 2019 JaminZhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlutterBridgePlugin.h"
#import "FlutterBoost.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlutterBridge : NSObject<FlutterBridge, FLBPlatform>

@end

NS_ASSUME_NONNULL_END
