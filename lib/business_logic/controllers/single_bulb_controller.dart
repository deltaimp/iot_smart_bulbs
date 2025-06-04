import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:iot_smart_bulbs/business_logic/ui_models/ui_bulb.dart' show UIBulb;
import 'package:iot_smart_bulbs/data/models/state.dart' show BulbState;
import 'package:iot_smart_bulbs/data/repositories/implementations/fake_bulb_repository.dart' show FakeBulbConnector;

class SingleBulbController extends GetxController {
  final UIBulb bulb;
  final FakeBulbConnector _repository = FakeBulbConnector();
  final Rx<UIBulb> rxBulb;

  SingleBulbController({required this.bulb}) : rxBulb = bulb.obs;

  Future<void> checkAvailability() {
    return Future.delayed(const Duration(seconds: 1)).then((_) {
      final isAvailable = Random().nextBool(); // Simula risultato casuale
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