import 'package:flutter/material.dart';

class SettingsData {
  bool darkMode;
  bool priorityMode;
  bool ascendingMode;
  int sortingOption;
  Color colorAscent;
  Color colorAscentText;
  String? backUrl;

  SettingsData(
      {required this.darkMode,
      required this.priorityMode,
      required this.ascendingMode,
      required this.sortingOption,
      required this.colorAscent,
      required this.colorAscentText,
      required this.backUrl});
}
