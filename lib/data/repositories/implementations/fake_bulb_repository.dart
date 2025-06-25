import 'package:flutter/material.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart' show Bulb, BulbCopyWith;
import 'package:iot_smart_bulbs/data/models/state.dart';
import 'package:iot_smart_bulbs/data/repositories/interfaces/i_smart_bulb_connector.dart';
import 'package:iot_smart_bulbs/nd_dart_lib/extensions.dart';

class FakeBulbConnector extends ISmartBulbConnector {
  final List<Bulb> _fakeBulbs = [
    Bulb(id: 1,
        name: "Lampada cucina",
        isDimmable: true,
        state: BulbState.ACCESA),
    Bulb(id: 2,
        name: "Lampada giardino",
        isDimmable: false,
        state: BulbState.ACCESA),
    Bulb(id: 3,
        name: "Abat jour camera",
        isDimmable: true,
        state: BulbState.SPENTA),
    Bulb(id: 4,
        name: "Lampada bagno",
        isDimmable: true,
        state: BulbState.ACCESA),
    Bulb(id: 5,
        name: "Luce soffitto",
        isDimmable: false,
        state: BulbState.SPENTA),
    Bulb(id: 6,
        name: "Lampada studio",
        isDimmable: true,
        state: BulbState.ACCESA),
  ];

  @override
  Future<List<Bulb>> discoverDevices() {
    return _fakeBulbs.toFuture();
  }

  Future<void> setDeviceState(int deviceId, BulbState state) {
    return Future.delayed(const Duration(milliseconds: 300)).then((_) {
      // In un'implementazione reale qui aggiorneremmo lo stato sul dispositivo
    });
  }

  // TODO aggiungere reale logica di controllo della rete
  Future<bool> pingDevice (int id) {
    return Future.delayed(const Duration(milliseconds: 300)).then((_) {
      return id % 2 == 0;
    });
  }

  @override
  Future<void> setDeviceColor(int id, Color color) {
    return Future.delayed(const Duration(milliseconds: 300)).then((_) {

      final index = _fakeBulbs.indexWhere((bulb) => bulb.id == id);
      if (index != -1) {
        debugPrint("Cambiato colore dispositivo $id a $color");
        _fakeBulbs[index] = _fakeBulbs[index].copyWith(color: color);
        // In una reale implementazione qui aggiorneremmo il colore sul dispositivo
      } else {
        throw Exception("Dispositivo $id non trovato");
      }
    });
  }

  @override
  Future<void> setDeviceBrightness(int id, double brightness) {
    return Future.delayed(const Duration(milliseconds: 300)).then((_) {
      final index = _fakeBulbs.indexWhere((bulb) => bulb.id == id);
      if (index != -1) {
        final bulb = _fakeBulbs[index];
        // Simula l'aggiornamento della luminosità
        debugPrint("Aggiornata luminosità dispositivo $id a $brightness");

        // Se la luminosità è 0, spegni automaticamente la lampadina
        if (brightness <= 0) {
          _fakeBulbs[index] = bulb.copyWith(state: BulbState.SPENTA);
          debugPrint("Dispositivo $id spento per luminosità zero");
        } else if (bulb.state == BulbState.SPENTA) {
          // Se era spenta e impostiamo luminosità >0, accendila
          _fakeBulbs[index] = bulb.copyWith(state: BulbState.ACCESA);
          debugPrint("Dispositivo $id acceso per luminosità positiva");
        }
      } else {
        debugPrint("Dispositivo $id non trovato");
        throw Exception("Dispositivo non trovato");
      }
    }).catchError((error) {
      debugPrint("Errore impostazione luminosità: $error");
      throw error; // Rilancia per gestione negli strati superiori
    });
  }
}
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

