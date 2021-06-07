import React from 'react';
import {
	View,
	Button,
	ScrollView,
	PermissionsAndroid,
	Text,
	Platform
} from 'react-native';
import Wifi from 'react-native-wifi-light';

export default class App extends React.Component {
	listWifi = [];
	constructor(props) {
		super(props);
		this.state = {};
	}

	componentDidMount() {
		if (Platform.OS === "android") {
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
				.catch((err) => { });
		} else {
			Wifi.onScanResults = (mess) => {
				this.listWifi = mess.data;
				console.log(this.listWifi);
				this.setState({
					isUpdateView: !this.state.isUpdateView,
				});
			};
			Wifi.getWifiList();
		}
	}

	onStartScanWifiPress = () => {
		try {
			Wifi.startScan();
			// if (Platform.OS === "android") {
			// 	Wifi.startScan();
			// } else {
			// 	Linking.openURL("app-settings:")
			// }
		} catch { }
	};

	render() {
		return (
			<View>
				<Button
					title={'Start Scan'}
					onPress={this.onStartScanWifiPress}
				/>
				<ScrollView>
					{this.listWifi &&
						typeof this.listWifi !== 'undefined' &&
						this.listWifi instanceof Array &&
						this.listWifi.map((w, index) => {
							return <Text key={index}>{w.SSID}</Text>;
						})}
				</ScrollView>
			</View>
		);
	}
}
