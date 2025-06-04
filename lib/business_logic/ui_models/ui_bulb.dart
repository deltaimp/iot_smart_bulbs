import 'package:flutter/material.dart';
import 'package:iot_smart_bulbs/data/models/bulb.dart';
import 'package:iot_smart_bulbs/data/models/state.dart';
class UIBulb extends Bulb {
  bool isSelected;
  bool isAvailable;
  Color uiColor;

  UIBulb({
    required super.id,
    required super.name,
    required super.isDimmable,
    required super.state,
    this.isSelected = false,
    this.isAvailable = true,
    Color? uiColor,
  }) : uiColor = uiColor ?? defaultColorForState(state);

  // Metodo factory per creare UIBulb da Bulb
  factory UIBulb.fromBulb(Bulb bulb) {
    return UIBulb(
      id: bulb.id,
      name: bulb.name,
      isDimmable: bulb.isDimmable,
      state: bulb.state,
    );
  }

  static Color defaultColorForState(BulbState state) {
    return state == BulbState.ACCESA
        ? Colors.yellow
        : Colors.grey;
  }

  UIBulb copyWith({
    bool? isSelected,
    bool? isAvailable,
    BulbState? state,
    Color? uiColor,
  }) {
    return UIBulb(
      id: id,
      name: name,
      isDimmable: isDimmable,
      state: state ?? this.state,
      isSelected: isSelected ?? this.isSelected,
      isAvailable: isAvailable ?? this.isAvailable,
      uiColor: uiColor ?? this.uiColor,
    );
  }
}