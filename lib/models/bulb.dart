import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';

class Bulb { // caratteristiche della Lampadina
  final int id;
  final RxString name;
  final Rx<BulbState> state;
  final Rx<Color> color;
  final bool isDimmable;

  Bulb ( {
    required this.id,
    required String name,
    required this.isDimmable,
    BulbState initialState = BulbState.SPENTA,
    Color initialColor = Colors.white,
}) : name = name.obs,
        state = initialState.obs,
        color = initialColor.obs;

  void toggleState() { //  per un pulsante di switch in ListTile/row
    state.value = state.value == BulbState.ACCESA ? BulbState.SPENTA : BulbState.ACCESA;
  }
}