#import <React/RCTBridgeModule.h>
#import <Foundation/Foundation.h>

@interface RCT_EXTERN_MODULE(ReactNativeGeth, NSObject)
RCT_EXTERN_METHOD(getNodeInfo:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
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
RCT_EXTERN_METHOD(newAccount:(NSString *) password resolver: (RCTResponseSenderBlock)resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(unlockAccount:(NSString *) address
                  password: (NSString *) password
                  resolver: (RCTResponseSenderBlock)resolve
                  rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(listAccounts:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(getBalance:(NSString *) address
                  resolver: (RCTResponseSenderBlock) resolve
                  rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(getSyncProgress:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
RCT_EXTERN_METHOD(getPeersInfo:(RCTResponseSenderBlock) resolve rejecter:(RCTPromiseRejectBlock) reject)
@end
