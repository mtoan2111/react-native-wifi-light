import { NativeModules } from 'react-native';

type WifiLightType = {
  multiply(a: number, b: number): Promise<number>;
};

const { WifiLight } = NativeModules;

export default WifiLight as WifiLightType;
