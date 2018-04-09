#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(ReactNativeGeth, NSObject)
RCT_EXTERN_METHOD(getName)
RCT_EXTERN_METHOD(nodeConfig:(id) config
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(startNode:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(stopNode:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(sendTransaction:(id) transaction
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(signTransaction:(id) transaction
                  address: (NSString *) address
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
@end
