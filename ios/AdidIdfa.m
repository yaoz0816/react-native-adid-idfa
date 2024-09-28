#import "AdidIdfa.h"
#import <AdSupport/AdSupport.h>

@implementation AdidIdfa

RCT_EXPORT_MODULE(RNAdidIdfa)
/*
*获取idfa
*/
RCT_EXPORT_METHOD(getAdId:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  if (@available(iOS 14, *)) {
    // iOS14及以上版本需要先请求权限
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
      // 主线程执行
      dispatch_async(dispatch_get_main_queue(), ^{
        // 获取到权限后，依然使用老方法获取idfa
        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
          NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
          NSLog(@"获取到设备idfa:%@",idfa);
          self->count = 30;
          resolve(idfa);
        } else {
          NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪:%ld%ld", status,(long)self->count);
          if (status == ATTrackingManagerAuthorizationStatusNotDetermined && self->count < 30) {
            
            self->count++;
       
            // 未授权,需要弹窗叫用户授权
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              NSLog(@"失败然后轮训:%ld", (long)self->count);
              [self getInitIDfa:^(id result) {
                NSLog(@"获取到设备idfa:%@",result);
              } rejecter:^(NSString *code, NSString *message, NSError *error) {
                NSLog(@"获取到设备idfa:%@%@",message,code);
              }];
            });
            return;
          }
        }
        });
      }];
    } else {
      // iOS14以下版本依然使用老方法
      // 判断在设置-隐私里用户是否打开了广告跟踪
      if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
          NSLog(@"获取到设备idfa:%@",idfa);
          resolve(idfa);
        });
      } else {
        NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
        
      }
    }
}
@end
