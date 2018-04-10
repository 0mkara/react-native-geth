#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(ReactNativeGeth, NSObject)
RCT_EXTERN_METHOD(getName)
RCT_EXTERN_METHOD(nodeConfig:(id) config
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(startNode:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(stopNode:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(sendTransaction:(NSObject *) transaction
                  password: (NSString *) password
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(signTransaction:(NSObject *) transaction
                  address: (NSString *) address
                  password: (NSString *) password
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(sendSignedTransaction:(NSObject *) transaction
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter: (RCTPromiseRejectBlock) reject)
@end
