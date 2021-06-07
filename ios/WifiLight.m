#import "WifiLight.h"

@implementation Wifi

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents{
    return @[@"wifiScanResult"];
}

- (instancetype)init{
    self = [super init];
    if (self){
        NSLog(@"Wifi Manager: Init");
        self.solved = YES;
        if (@available(iOS 13, *)){
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"Wifi Manager: state changed %d", status);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WifiManager: authorizationStatus" object:nil userInfo:nil];
}

- (NSString *) getWifiSSID {
    NSString *kSSID = (NSString *)kCNNetworkInfoKeySSID;
    
    NSArray *iFs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *iFname in iFs){
        NSDictionary *info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)iFname);
        if (info[kSSID]){
            return info[kSSID];
        }
    }
    return nil;
}

RCT_EXPORT_METHOD(getWifiList) {
    if (@available(iOS 13, *)) {
        // Reject when permission had rejected
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
            NSLog(@"RNWIFI:ERROR:Cannot detect SSID because LocationPermission is Denied ");
//            reject([ConnectError code:LocationPermissionDenied], @"Cannot detect SSID because LocationPermission is Denied", nil);
        }
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted){
            NSLog(@"RNWIFI:ERROR:Cannot detect SSID because LocationPermission is Restricted ");
//            reject([ConnectError code:LocationPermissionRestricted], @"Cannot detect SSID because LocationPermission is Restricted", nil);
        }
    }

    BOOL hasLocationPermission = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
    [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
    if (@available(iOS 13, *) && hasLocationPermission == NO) {
        // Need request LocationPermission or HotSpot or have VPN connection
        // https://forums.developer.apple.com/thread/117371#364495
        [self.locationManager requestWhenInUseAuthorization];
        self.solved = NO;
        [[NSNotificationCenter defaultCenter] addObserverForName:@"RNWIFI:authorizationStatus" object:nil queue:nil usingBlock:^(NSNotification *note)
        {
            if(self.solved == NO){
                if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
                    [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways){
                    NSString *SSID = [self getWifiSSID];
                    if (SSID){
//                        resolve(SSID);
                        NSDictionary *ssid = @{
                            @"SSID": SSID
                        };
                        NSArray *ssids = [NSArray arrayWithObject:ssid];
                        NSDictionary *payload = @{
                            @"data": ssids
                        };
                        [self  sendEventWithName:@"wifiScanResult" body:payload];
                        return;
                    }
                    NSLog(@"RNWIFI:ERROR:Cannot detect SSID");
//                    reject([ConnectError code:CouldNotDetectSSID], @"Cannot detect SSID", nil);
                }else{
//                    reject([ConnectError code:LocationPermissionDenied], @"Permission not granted", nil);
                }
            }
            // Avoid call when live-reloaded app
            self.solved = YES;
        }];
    }else{
        NSString *SSID = [self getWifiSSID];
        if (SSID){
//            resolve(SSID);
            NSDictionary *ssid = @{
                @"SSID": SSID
            };
            NSArray *ssids = [NSArray arrayWithObject:ssid];
            NSDictionary *payload = @{
                @"data": ssids
            };
            [self  sendEventWithName:@"wifiScanResult" body:payload];
            return;
        }
        NSLog(@"RNWIFI:ERROR:Cannot detect SSID");
//        reject([ConnectError code:CouldNotDetectSSID], @"Cannot detect SSID", nil);
    }
}

// Example method
// See // https://facebook.github.io/react-native/docs/native-modules-ios

RCT_EXPORT_METHOD(startScan){
    
}

RCT_EXPORT_METHOD(stopScan){
    
}

RCT_EXPORT_METHOD(openSettings){
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"app-settings:root=WIFI"]];
    });
}

// Example method
// See // https://facebook.github.io/react-native/docs/native-modules-ios

@end
