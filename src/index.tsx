import { NativeModules, NativeEventEmitter } from 'react-native';

class Wifi {
	Wifi: any;
	nativeEvent: any;
	onScanResults: any;
	constructor() {
		try {
			this.Wifi = NativeModules.Wifi;
			this.nativeEvent = new NativeEventEmitter(this.Wifi);
		} catch {
			this.Wifi = undefined;
			this.nativeEvent = undefined;
		}
		this.initListener();
	}

	startScan = () => {
		try {
			this.Wifi &&
				typeof this.Wifi !== 'undefined' &&
				this.Wifi.startScan();
		} catch (err) {
			console.log('Wifi-Native-Module/StartScan: err => ', err);
		}
	};

	getWifiList = () => {
		try {
			this.Wifi &&
				typeof this.Wifi !== 'undefined' &&
				this.Wifi.getWifiList();
		} catch (err) {
			console.log('Wifi-Native-Module/StopScan: err => ', err);
		}
	};

	stopScan = () => {
		try {
			this.Wifi &&
				typeof this.Wifi !== 'undefined' &&
				this.Wifi.stopScan();
		} catch (err) {
			console.log('Wifi-Native-Module/StopScan: err => ', err);
		}
	};

	initListener = () => {
		this.nativeEvent.addListener('wifiScanResult', (message = {}) => {
			try {
				this.onScanResults(message);
			} catch (err) {
				console.log(
					'Wifi-Native-Module/initListener/wifiScanResult: err => ',
					err,
				);
			}
		});
	};
}

export default new Wifi();
