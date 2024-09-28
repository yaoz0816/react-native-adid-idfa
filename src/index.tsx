import { NativeModules } from 'react-native';

type RNAdidIdfaType = {
  getAdId(): Promise<number>;
};

const { RNAdidIdfa } = NativeModules;

export default RNAdidIdfa as RNAdidIdfaType;
