import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';

class Bulb { // caratteristiche della Lampadina
  final int id;
  final String name;
  final BulbState state;
  // final Color color;
  final bool isDimmable;

  Bulb ({
    required this.id,
    required this.name,
    required this.isDimmable,
    required this.state,
    // required this.color,
  });
}