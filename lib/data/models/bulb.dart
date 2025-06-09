import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';

class Bulb {
  final int id;
   String name;
  final BulbState state;
  // maybe stringa esadecimale colore
  final bool isDimmable;

  Bulb ({
    required this.id,
    required this.name,
    required this.isDimmable,
    required this.state,
  });
}