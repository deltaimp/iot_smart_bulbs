import 'dart:ui';

import 'package:iot_smart_bulbs/data/models/bulb.dart';
import 'package:iot_smart_bulbs/data/models/state.dart';

abstract class ISmartBulbConnector {
  Future<List<Bulb>> discoverDevices();
  Future<void> setDeviceColor(int id, Color color);
  Future<void> setDeviceBrightness(int id, double brightness);
  Future<void> setDeviceState(int deviceId, BulbState state);
  // Future<Bulb> setDeviceProps(...)
  // Future<Bulb> setDeviceProp(...)
}