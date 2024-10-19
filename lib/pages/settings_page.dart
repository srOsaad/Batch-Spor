import 'dart:io';
import 'package:flutter/material.dart';
import '../backend_and_modals/backup_system.dart';
import '../backend_and_modals/settings_data.dart';
import 'package:settings_ui/settings_ui.dart';
import 'settings_pages/about_page.dart';
import 'settings_pages/trash_page.dart';
import 'settings_pages/backup_url.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'settings_pages/sort_options.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    super.key,
    required this.settingsData,
    required this.onSettingsChanged,
  });
  final SettingsData settingsData;
  final Function(SettingsData) onSettingsChanged;
  var abs = const <ColorPickerType, bool>{
    ColorPickerType.both: false,
    ColorPickerType.custom: false,
    ColorPickerType.primary: false,
    ColorPickerType.bw: false,
    ColorPickerType.customSecondary: false,
    ColorPickerType.wheel: false,
  };

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool permissionGranted = false;
  String sortOptionString(int u) {
    return u == 1
        ? 'Time'
        : u == 2
            ? 'Class'
            : u == 3
                ? 'Week'
                : u == 4
                    ? 'Date Added'
                    : 'Name';
  }

  void checkUrlandPermission() async {
    if (widget.settingsData.backUrl != null) {
      if (!(await Directory(widget.settingsData.backUrl!).exists())) {
        widget.settingsData.backUrl = null;
      }
    }
    permissionGranted = await BackupSystem.isGranted();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkUrlandPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      darkTheme: const SettingsThemeData(
        settingsSectionBackground: Colors.transparent,
        settingsListBackground: Colors.transparent,
      ),
      lightTheme: const SettingsThemeData(
        settingsSectionBackground: Colors.transparent,
        settingsListBackground: Colors.transparent,
      ),
      sections: [
        SettingsSection(
          tiles: [
            SettingsTile.navigation(
              title: const Text('Local Url'),
              leading: const Icon(Icons.storage),
              trailing: Icon(
                  widget.settingsData.backUrl != null && permissionGranted
                      ? Icons.link
                      : Icons.link_off),
              onPressed: (context) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BackupUrl(
                        url: widget.settingsData.backUrl,
                        onUrlChanged: (p0) {
                          widget.settingsData.backUrl = p0;
                          widget.onSettingsChanged(widget.settingsData);
                          setState(() {});
                        });
                  }),
            ),
            SettingsTile.navigation(
              onPressed: (context) => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => TrashPage())),
              leading: const Icon(Icons.delete),
              title: const Text('Trash'),
            ),
          ],
          title: const Text('Backup'),
        ),
        SettingsSection(
          tiles: [
            SettingsTile.switchTile(
              initialValue: widget.settingsData.darkMode,
              onToggle: (value) {
                setState(() {
                  widget.settingsData.darkMode = value;
                });
                widget.onSettingsChanged(widget.settingsData);
              },
              leading: const Icon(Icons.dark_mode_rounded),
              title: const Text('Dark Mode'),
            ),
            SettingsTile(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ColorPicker(
                  padding: EdgeInsets.zero,
                  onColorChanged: (color) {
                    widget.settingsData.colorAscent = color;
                    widget.settingsData.colorAscentText =
                        (color == Color(0xffff5252) ||
                                color == Color(0xffff4081) ||
                                color == Color(0xffe040fb) ||
                                color == Color(0xff7c4dff) ||
                                color == Color(0xff536dfe) ||
                                color == Color(0xff448aff) ||
                                color == Color(0xffff6e40))
                            ? Colors.white
                            : Colors.black;
                    widget.onSettingsChanged(widget.settingsData);
                  },
                  colorCodeHasColor: false,
                  color: widget.settingsData.colorAscent,
                  pickersEnabled: widget.abs,
                  enableShadesSelection: false,
                  selectedColorIcon: Icons.square_rounded,
                ),
              ),
            ),
          ],
          title: const Text('Environment'),
        ),
        SettingsSection(
          tiles: [
            SettingsTile.switchTile(
              initialValue: widget.settingsData.priorityMode,
              leading: const Icon(Icons.priority_high_rounded),
              onToggle: (value) {
                setState(() {
                  widget.settingsData.priorityMode = value;
                  widget.onSettingsChanged(widget.settingsData);
                });
              },
              title: const Text('Priority Mode'),
            ),
            SettingsTile.navigation(
              onPressed: (context) => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SortOptions(
                        settingsData: widget.settingsData,
                        onSettingsChanged: widget.onSettingsChanged);
                  }),
              trailing:
                  Text(sortOptionString(widget.settingsData.sortingOption)),
              leading: const Icon(Icons.sort_rounded),
              title: const Text('Sort'),
            ),
          ],
          title: const Text('Sort Options'),
        ),
        SettingsSection(
          tiles: [
            SettingsTile.navigation(
              onPressed: (context) => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutPage())),
              leading: const Icon(Icons.info_rounded),
              title: const Text('About'),
            ),
          ],
          title: const Text('Information'),
        )
      ],
    );
  }
}
