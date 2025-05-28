import 'package:flutter/material.dart';
import 'package:iot_smart_bulbs/models/bulb.dart';
import 'package:iot_smart_bulbs/models/state.dart';

class FakeBulbRepository {
  final List<Bulb> _fakeBulbs = [
    Bulb(id: 1, name: "Lampada cucina", isDimmable: true),
    Bulb(id: 2, name: "Lampada giardino", isDimmable: false),
    Bulb(id: 3, name: "Abat jour camera", isDimmable: true, initialState: BulbState.ACCESA),
    Bulb(id: 4, name: "Lampada bagno", isDimmable: true),
    Bulb(id: 5, name: "Luce soffitto", isDimmable: false),
    Bulb(id: 6, name: "Lampada studio", isDimmable: true),
  ];

  final List<Bulb> _availableBulbs = [
    Bulb(id: 101, name: "Nuova lampada 1", isDimmable: true),
    Bulb(id: 102, name: "Nuova lampada 2", isDimmable: false),
    Bulb(id: 103, name: "Nuova lampada 3", isDimmable: true),
  ];

  Future<List<Bulb>> getDevices() {
    return Future.delayed(const Duration(seconds:1))
        .then((_) => _fakeBulbs);
  }

  Future<List<Bulb>> getAvailableDevices() {
    return Future.delayed(const Duration(seconds:1))
        .then((_) => _availableBulbs);
  }

  Future<bool> handShake(int deviceId) {
    return Future.delayed(const Duration(milliseconds: 500))
        .then((_) => true);
  }

  Future<bool> addDevice(Bulb newBulb) {
    return Future.delayed(const Duration(milliseconds: 300))
        .then((_) {
      _fakeBulbs.add(newBulb);
      return true;
    });
  }

  Future<bool> removeDevice(int deviceId) {
    return Future.delayed(const Duration(milliseconds: 300))
        .then((_) {
      _fakeBulbs.removeWhere((bulb) => bulb.id == deviceId);
      return true;
    });
  }

}
