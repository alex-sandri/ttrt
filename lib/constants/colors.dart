import 'dart:math';

import 'package:flutter/material.dart';

final List<Color> colors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.white,
  Colors.black,
  Colors.orange,
  Colors.pink,
  Colors.purple,
  Colors.brown,
  Colors.cyan,
  Colors.teal,
  Colors.lime,
  Colors.grey,
  Colors.indigo,
];

extension ExtendedColorList on List<Color> {
  Color get random {
    final Random random = Random();

    return this[random.nextInt(length)];
  }
}
