import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart';
import 'package:iot_smart_bulbs/data/models/state.dart';

class UIBulb extends Bulb {
  final RxBool isSelected; // 1. Diventa final
  final RxBool isAvailable; // 2. Diventa RxBool invece di bool
  final Rx<Color> uiColor; // 3. Diventa Rx<Color>
  final RxDouble brightness; // 0.0-1.0

  UIBulb({
    required super.id,
    required super.name,
    required super.isDimmable,
    required super.state,
    bool isSelected = false,
    bool isAvailable = true,
    Color? uiColor,
    double brightness = 1.0,
  })  : isSelected = isSelected.obs,
        isAvailable = isAvailable.obs,
        uiColor = (uiColor ?? defaultColorForState(state)).obs,
        brightness = brightness.obs;

  factory UIBulb.fromBulb(Bulb bulb) {
    return UIBulb(
      id: bulb.id,
      name: bulb.name,
      isDimmable: bulb.isDimmable,
      state: bulb.state,
    );
  }

  UIBulb copyWith({
    bool? isSelected,
    bool? isAvailable,
    BulbState? state,
    Color? uiColor,
    double? brightness,
  }) {
    return UIBulb(
      id: id,
      name: name,
      isDimmable: isDimmable,
      state: state ?? this.state,
      isSelected: isSelected ?? this.isSelected.value,
      isAvailable: isAvailable ?? this.isAvailable.value,
      uiColor: uiColor ?? this.uiColor.value,
      brightness: brightness ?? this.brightness.value,
    );
  }

  // 7. Metodo per cambiare stato (opzionale ma utile)
  void toggleSelected() => isSelected.toggle();

  static Color defaultColorForState(BulbState state) {
    return state == BulbState.ACCESA
        ? Colors.yellowAccent
        : Colors.grey;
  }
}