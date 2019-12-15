/**
 * @format
 */

import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';

global.test = function() {
  console.warn('test!');
};

AppRegistry.registerComponent(appName, () => App);
