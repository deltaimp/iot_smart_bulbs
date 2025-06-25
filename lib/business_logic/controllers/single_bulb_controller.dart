import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart' show UIBulb;
import 'package:iot_smart_bulbs/data/models/state.dart' show BulbState;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart' show FakeBulbConnector;

class SingleBulbController extends GetxController {
  //final UIBulb bulb;
  final FakeBulbConnector _repository = FakeBulbConnector();
  UIBulb _bulb;
  UIBulb get bulb => _bulb;
  SingleBulbController({required UIBulb bulb}) : _bulb = bulb;

  Future<void> changeColor(Color newColor) {
    return Future.microtask(() {
      return _repository.setDeviceColor(bulb.id, newColor);
    }).then((_) {
      _bulb.uiColor.value = newColor;
      update();
    }).catchError((error) {
      debugPrint("Errore cambio colore: $error");
      Get.snackbar('Errore', 'Impossibile cambiare colore');
    });
  }

  Future<void> setBrightness(double value) {
    final clampedValue = value.clamp(0.0, 1.0);
    return Future.microtask(() {
      _repository.setDeviceBrightness(bulb.id, clampedValue);
    }).then((_) {
      _bulb.brightness.value = clampedValue;
      if (clampedValue == 0) {
        return togglePower(); // Spenta se luminosità a 0
      }
      else {
        update();
      }
    }).catchError((error) {
      debugPrint("Errore regolazione luminosità: $error");
      Get.snackbar('Errore', 'Impossibile regolare luminosità');
    });
  }


  Future<void> checkAvailability() {
    return Future.delayed(const Duration(seconds: 1)).then((_) {
     final isAvailable = true;
      // final isAvailable = Random().nextBool(); // Simula risultato casuale
      _bulb = bulb.copyWith(
        isAvailable: isAvailable,
      );
    });
  }

  Future<void> togglePower() {
    final newState = bulb.state.value == BulbState.ACCESA
        ? BulbState.SPENTA
        : BulbState.ACCESA;

    _bulb = bulb.copyWith(
      state: newState,
    );

    update();
    // Qui ci sarà logica vera per cambiare lo stato
    return _repository.setDeviceState(bulb.id, newState).then((_) {
      //
    });
  }


  @override
  void onInit() {
    super.onInit();
    checkAvailability();
  }
}