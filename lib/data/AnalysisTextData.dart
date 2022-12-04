import 'package:flutter/material.dart';

class AnalysisTextData {
  AnalysisTextData({this.text, this.type});

  String? text;
  TextType? type;
}

enum TextType {
  object(Color.fromARGB(255, 255, 158, 67)),
  action(Color.fromARGB(255, 255, 81, 81)),
  characteristic(Color.fromARGB(255, 81, 162, 255));

  final Color typeColor;
  const TextType(this.typeColor);
}
