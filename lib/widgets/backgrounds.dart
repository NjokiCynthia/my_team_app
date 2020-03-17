
import 'package:flutter/material.dart';

BoxDecoration primaryGradient() {
  return BoxDecoration(
    gradient: RadialGradient(
      colors: [Colors.white, Colors.blue[100]],
      radius: 2.0,
    )
  );
}