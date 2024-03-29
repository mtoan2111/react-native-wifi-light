//
//  ConnectError.m
//  WifiLight
//
//  Created by Nguyễn Mạnh Toàn on 07/06/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ConnectError.h"

@implementation ConnectError

+ (NSString*)code:(ConnectErrorCode)errorCode {
    switch(errorCode) {
        case UnavailableForOSVersion:
            return @"unavailableForOSVersion";
        case Invalid:
            return @"invalid";
        case InvalidSSID:
            return @"invalidSSID";
        case InvalidSSIDPrefix:
            return @"invalidSSIDPrefix";
        case InvalidPassphrase:
            return @"invalidPassphrase";
        case UserDenied:
            return @"userDenied";
        case LocationPermissionDenied:
            return @"locationPermissionDenied";
        case LocationPermissionRestricted:
            return @"locationPermissionRestricted";
        case DidNotFindNetwork:
            return @"didNotFindNetwork";
        case CouldNotDetectSSID:
            return @"couldNotDetectSSID";
        case UnableToConnect:
        default:
            return @"unableToConnect";
    }
}

@end
