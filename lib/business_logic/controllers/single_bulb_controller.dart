import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart' show UIBulb;
import 'package:iot_smart_bulbs/data/models/state.dart' show BulbState;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart' show FakeBulbConnector;

class SingleBulbController extends GetxController {
  //final UIBulb bulb;
  final FakeBulbConnector _repository = FakeBulbConnector();
  final Rx<UIBulb> rxBulb;

  SingleBulbController({required UIBulb bulb}) : rxBulb = bulb.obs;

  Future<void> changeColor(Color newColor) {
    return Future.microtask(() {
      rxBulb.update((bulb) {
        bulb?.uiColor.value = newColor;
      });
    }).then((_) {
      return _repository.setDeviceColor(rxBulb.value.id, newColor.value);
    }).catchError((error) {
      debugPrint("Errore cambio colore: $error");
      Get.snackbar('Errore', 'Impossibile cambiare colore');
    });
  }

  Future<void> setBrightness(double value) {
    final clampedValue = value.clamp(0.0, 1.0);
    return Future.microtask(() {
      rxBulb.update((bulb) {
        bulb?.brightness.value = clampedValue;
      });
    }).then((_) {
      return _repository.setDeviceBrightness(rxBulb.value.id, clampedValue);
    }).then((_) {
      if (clampedValue == 0) {
        return togglePower(); // Spenta se luminosità a 0
      }
      return Future.value();
    }).catchError((error) {
      debugPrint("Errore regolazione luminosità: $error");
      Get.snackbar('Errore', 'Impossibile regolare luminosità');
    });
  }


  Future<void> checkAvailability() {
    return Future.delayed(const Duration(seconds: 1)).then((_) {
     final isAvailable = true;
      // final isAvailable = Random().nextBool(); // Simula risultato casuale
      rxBulb.value = rxBulb.value.copyWith(
        isAvailable: isAvailable,
        uiColor: isAvailable ? null : Colors.grey,
      );
    });
  }

  Future<void> togglePower() {
    final newState = rxBulb.value.state == BulbState.ACCESA
        ? BulbState.SPENTA
        : BulbState.ACCESA;

    rxBulb.value = rxBulb.value.copyWith(
      state: newState,
      uiColor: UIBulb.defaultColorForState(newState),
    );

    // Qui ci sarà logica vera per cambiare lo stato
    return _repository.setDeviceState(rxBulb.value.id, newState).then((_) {
      //
    });
  }


  @override
  void onInit() {
    super.onInit();
    checkAvailability();
  }
}