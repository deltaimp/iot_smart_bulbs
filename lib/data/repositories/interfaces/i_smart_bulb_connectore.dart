import 'package:iot_smart_bulbs/data/models/bulb.dart';

abstract class ISmartBulbConnector {
  Future<List<Bulb>> discoverDevices();
  // Future<Bulb> setDeviceProps(...)
  // Future<Bulb> setDeviceProp(...)
}