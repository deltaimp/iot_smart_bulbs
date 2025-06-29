import 'dart:ui';

import 'package:iot_smart_bulbs/data/models/bulb.dart';

abstract class ISmartBulbConnector {
  Future<List<Bulb>> discoverDevices();
  Future<void> setDeviceColor(int id, Color color);
  Future<bool> pingDevice (int id);
  Future<void> setDeviceBrightness(int id, double brightness);
}