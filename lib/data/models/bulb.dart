import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';

class Bulb {
  final int id;
   String name;
  final BulbState state;
  // maybe stringa esadecimale colore
  final Color color;
  final bool isDimmable;

  Bulb ({
    required this.id,
    required this.name,
    required this.isDimmable,
    required this.state,
    this.color = Colors.yellow
  });
}

extension BulbCopyWith on Bulb {
  Bulb copyWith({
    int? id,
    String? name,
    bool? isDimmable,
    BulbState? state,
    Color? color
  }) {
    return Bulb(
      id: id ?? this.id,
      name: name ?? this.name,
      isDimmable: isDimmable ?? this.isDimmable,
      state: state ?? this.state,
      color: color ?? this.color
    );
  }
}