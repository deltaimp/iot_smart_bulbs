import 'package:flutter/material.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart' show Bulb;
import 'package:iot_smart_bulbs/data/models/state.dart';
import 'package:iot_smart_bulbs/data/repositories/interfaces/i_smart_bulb_connectore.dart';
import 'package:iot_smart_bulbs/nd_dart_lib/extensions.dart';

class FakeBulbConnector extends ISmartBulbConnector {
  final List<Bulb> _fakeBulbs = [
    Bulb(id: 1, name: "Lampada cucina", isDimmable: true, state: BulbState.ACCESA),
    Bulb(id: 2, name: "Lampada giardino", isDimmable: false, state: BulbState.ACCESA),
    Bulb(id: 3, name: "Abat jour camera", isDimmable: true, state: BulbState.SPENTA),
    Bulb(id: 4, name: "Lampada bagno", isDimmable: true, state: BulbState.ACCESA),
    Bulb(id: 5, name: "Luce soffitto", isDimmable: false, state: BulbState.SPENTA),
    Bulb(id: 6, name: "Lampada studio", isDimmable: true, state: BulbState.ACCESA),
  ];


  // Future<List<Bulb>> getDevices() {
  //   return Future.delayed(const Duration(seconds:1))
  //       .then((_) => _fakeBulbs);
  // }
  //
  // Future<List<Bulb>> getAvailableDevices() {
  //   return Future.delayed(const Duration(seconds:1))
  //       .then((_) => _availableBulbs);
  // }
  //
  // Future<bool> handShake(int deviceId) {
  //   return Future.delayed(const Duration(milliseconds: 500))
  //       .then((_) => true);
  // }
  //
  // Future<bool> addDevice(Bulb newBulb) {
  //   return Future.delayed(const Duration(milliseconds: 300))
  //       .then((_) {
  //     _fakeBulbs.add(newBulb);
  //     return true;
  //   });
  // }
  //
  // Future<bool> removeDevice(int deviceId) {
  //   return Future.delayed(const Duration(milliseconds: 300))
  //       .then((_) {
  //     _fakeBulbs.removeWhere((bulb) => bulb.id == deviceId);
  //     return true;
  //   });
  // }

  @override
  Future<List<Bulb>> discoverDevices() {
    return _fakeBulbs.toFuture();
  }

}
