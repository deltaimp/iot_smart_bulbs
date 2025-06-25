import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart';
import 'package:iot_smart_bulbs/data/models/state.dart';

class UIBulb {
  final String name;
  final int id;
  final bool isDimmable;
  final Rx<BulbState> state;
  final RxBool isSelected; // 1. Diventa final
  final RxBool isAvailable; // 2. Diventa RxBool invece di bool
  final Rx<Color> uiColor; // 3. Diventa Rx<Color>
  final RxDouble brightness; // 0.0-1.0

  UIBulb({
    required this.id,
    required this.name,
    required this.isDimmable,
    required BulbState state,
    bool isSelected = false,
    bool isAvailable = true,
    Color uiColor = Colors.yellow,
    double brightness = 1.0,
  })  : isSelected = isSelected.obs,
        isAvailable = isAvailable.obs,
        uiColor = uiColor.obs,
        brightness = brightness.obs,
        state = state.obs;

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
      state: state ?? this.state.value,
      isSelected: isSelected ?? this.isSelected.value,
      isAvailable: isAvailable ?? this.isAvailable.value,
      uiColor: uiColor ?? this.uiColor.value,
      brightness: brightness ?? this.brightness.value,
    );
  }

  // 7. Metodo per cambiare stato (opzionale ma utile)
  void toggleSelected() => isSelected.toggle();

  Color getColor() {
    final clr = state.value == BulbState.ACCESA
        ? uiColor.value
        : Colors.grey;

    return clr.withOpacity(brightness.value);
  }
}