#import <Flutter/Flutter.h>

@class FLBFlutterViewContainer;

@protocol FlutterBridge <NSObject>
- (void)getAppVersion:(FlutterResult)result;
- (void)getUserName:(FlutterResult)result;
- (void)request:(NSString *)path :(NSString *)method :(NSDictionary *)parameter :(FlutterResult)result;
@end

@interface FlutterBridgePlugin : NSObject<FlutterPlugin>

+ (void)registerFlutterBridge:(id<FlutterBridge>)bridge;
    
+ (FLBFlutterViewContainer *)FLBFlutterViewContainer:(NSString *)name params:(NSDictionary *)params;
    
+ (void)closePage;
    
@end
