#import "WifiLight.h"

@implementation Wifi

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents{
    return @[@"wifiScanResult"];
}

RCT_EXPORT_METHOD(getWifiList){
    
}

RCT_EXPORT_METHOD(startScan){
    
}

RCT_EXPORT_METHOD(stopScan){
    
}
// Example method
// See // https://facebook.github.io/react-native/docs/native-modules-ios

@end
