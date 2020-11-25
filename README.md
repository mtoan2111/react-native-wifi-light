# react-native-wifi-light

Wifi iteractive for react-native

## Installation

```sh
npm i react-native-wifi-light --save
```

### iOS

You need use enable `Access WIFI Information`, with correct profile. `Hotspot Configuration` is required in order to connect to networks.

#### iOS 13

You need put "Privacy - Location When In Use Usage Description" or "Privacy - Location Always and When In Use Usage Description" in Settings -> info

### Android

#### `ACCESS_FINE_LOCATION` permission

Since [Android 6](https://developer.android.com/about/versions/marshmallow), you must request the [`ACCESS_FINE_LOCATION`](https://developer.android.com/reference/android/Manifest.permission#ACCESS_FINE_LOCATION) permission at runtime to use the device's Wi-Fi scanning and managing capabilities. In order to accomplish this, you can use the [PermissionsAndroid API](https://reactnative.dev/docs/permissionsandroid) or [React Native Permissions](https://github.com/react-native-community/react-native-permissions).

Example:

```javascript
import { PermissionsAndroid } from 'react-native';

const granted = await PermissionsAndroid.request(
	PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
	{
		title: 'Location permission is required for WiFi connections',
		message:
			'This app needs location permission as this is required  ' +
			'to scan for wifi networks.',
		buttonNegative: 'DENY',
		buttonPositive: 'ALLOW',
	},
);
if (granted === PermissionsAndroid.RESULTS.GRANTED) {
	// You can now use react-native-wifi-reborn
} else {
	// Permission denied
}
```

## Usage

```javascript
import Wifi from "react-native-wifi-light";

componentDidMount(){
    PermissionsAndroid.request(
        PermissionsAndroid.PERMISSIONS.ACCESS_FINE_LOCATION,
        {
            title: 'Location permission is required for WiFi connections',
            message:
                'This app needs location permission as this is required  ' +
                'to scan for wifi networks.',
            buttonNegative: 'DENY',
            buttonPositive: 'ALLOW',
        },
    )
    .then((res) => {
        if (res === PermissionsAndroid.RESULTS.GRANTED) {
            Wifi.onScanResults = (mess) => {
                this.listWifi = JSON.parse(mess.data);
                console.log(this.listWifi);
                this.setState({
                    isUpdateView: !this.state.isUpdateView,
                });
            };
            Wifi.getWifiList();
        } else {
        }
    })
    .catch((err) => {});
}
```

## Methods

_The api documentation is in progress._

### Android & iOS

The following methods work on both Android and iOS

### `getWifiList(): Promise<Array<Any>>`

Returns a promise that resolves a list of available Wifi SSIDs.

### `startScan(): Promise<Array<Any>>`

Similar to `getWifiList` but it forcefully starts a new WiFi scan and only passes the results when the scan is done.

## Event

### `onScanResults: callback(data: any)`

The event wil be executed when list wifi is ready

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
