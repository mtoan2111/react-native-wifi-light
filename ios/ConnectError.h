//
//  ConnectError.h
//  WifiLight
//
//  Created by Nguyễn Mạnh Toàn on 07/06/2021.
//  Copyright © 2021 Facebook. All rights reserved.
//
@interface ConnectError : NSObject

typedef enum {
    UnavailableForOSVersion,
    Invalid,
    InvalidSSID,
    InvalidSSIDPrefix,
    InvalidPassphrase,
    UserDenied,
    UnableToConnect,
    LocationPermissionDenied,
    LocationPermissionRestricted,
    DidNotFindNetwork,
    CouldNotDetectSSID
} ConnectErrorCode;

+ (NSString*)code:(ConnectErrorCode)errorCode;

@end
