import '/backend_and_modals/settings_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CacheDatabase {
  static CacheDatabase? _instance;
  static SharedPreferences? _prefs;

  CacheDatabase._internal();

  factory CacheDatabase() {
    _instance ??= CacheDatabase._internal();
    return _instance!;
  }
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SettingsData settings() {
    return SettingsData(
      darkMode: darkMode(),
      priorityMode: priorityMode(),
      ascendingMode: ascendingMode(),
      sortingOption: sortOptionInt(),
      colorAscent: colorAscent(),
      colorAscentText: colorAscentText(),
      backUrl: backupUrl(),
    );
  }

  void setSettings(SettingsData settings) {
    setDarkMode(settings.darkMode);
    setPriorityMode(settings.priorityMode);
    setAscendingMode(settings.ascendingMode);
    setSortOptionInt(settings.sortingOption);
    setColorAscent(
        '0x${settings.colorAscent.value.toRadixString(16).padLeft(8, '0')}');
    setColorAscentText(
        '0x${settings.colorAscentText.value.toRadixString(16).padLeft(8, '0')}');
    setBackupUrl(settings.backUrl ?? "");
  }

  bool darkMode() {
    return _prefs!.getBool('darkMode') ?? false;
  }

  bool priorityMode() {
    return _prefs!.getBool('priorityMode') ?? true;
  }

  bool ascendingMode() {
    return _prefs!.getBool('ascendingMode') ?? true;
  }

  int sortOptionInt() {
    return _prefs!.getInt('sortOption') ?? 0;
  }

  Color colorAscent() {
    return Color(
        int.parse(_prefs!.getString('colorAscentHex') ?? "0xff536dfe"));
  }

  Color colorAscentText() {
    return Color(
        int.parse(_prefs!.getString('colorAscentTextHex') ?? "0xffffffff"));
  }

  String? backupUrl() {
    String? t = _prefs!.getString('backUrl');
    if (t == "") return null;
    return t;
  }

  int lastBackuped() {
    return _prefs!.getInt('day') ?? 18;
  }

  void setDarkMode(bool value) {
    _prefs!.setBool('darkMode', value);
  }

  void setPriorityMode(bool value) {
    _prefs!.setBool('priorityMode', value);
  }

  void setAscendingMode(bool value) {
    _prefs!.setBool('ascendingMode', value);
  }

  void setSortOptionInt(int value) {
    _prefs!.setInt('sortOption', value);
  }

  void setColorAscent(String value) {
    _prefs!.setString('colorAscentHex', value);
  }

  void setColorAscentText(String value) {
    _prefs!.setString('colorAscentTextHex', value);
  }

  void setBackupUrl(String url) {
    _prefs!.setString('backUrl', url);
  }

  void setLastBackuped(int value) {
    _prefs!.setInt('day', value);
  }
}
