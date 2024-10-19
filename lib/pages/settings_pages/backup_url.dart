import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../backend_and_modals/backup_system.dart';
import 'dart:io';

class BackupUrl extends StatefulWidget {
  BackupUrl({super.key, required this.url, required this.onUrlChanged});
  String? url;
  final Function(String?) onUrlChanged;
  @override
  State<BackupUrl> createState() => _BackupUrlState();
}

class _BackupUrlState extends State<BackupUrl> {
  String? url;
  bool? isGranted;
  BackupSystem? bSystem;
  bool restoreAndBackup = false;
  @override
  void initState() {
    super.initState();
    url = widget.url;
    checkForPermission();
    checkForUrl();
  }

  void checkForPermission() async {
    isGranted = await BackupSystem.isGranted();
    if (mounted) {
      setState(() {});
    }
  }

  void checkForUrl() async {
    if (url != null) {
      if (await Directory(url!).exists()) {
        bSystem = BackupSystem(dirPath: url!);
        restoreAndBackup = true;
      } else {
        restoreAndBackup = false;
      }
    } else {
      restoreAndBackup = false;
    }
    setState(() {});
  }

  Future<String?> pickDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    return selectedDirectory;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: (isGranted ?? false)
          ? Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Backup Url",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(url ?? 'No backup location set yet!'),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: restoreAndBackup
                            ? () {
                                bSystem!.restore(context);
                              }
                            : null,
                        child: const Text('Restore'),
                      ),
                      TextButton(
                        onPressed: restoreAndBackup
                            ? () {
                                bSystem!.backup(context);
                              }
                            : null,
                        child: const Text('Backup Now'),
                      ),
                      TextButton(
                        onPressed: () async {
                          url = await pickDirectory();
                          checkForUrl();
                          widget.onUrlChanged(url);
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        child: const Text("Locate"),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Backup Url",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'You have not granted storage permission yet!',
                    style: TextStyle(color: Colors.red),
                  ),
                  Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      TextButton(
                        onPressed: () async {
                          await BackupSystem.requestForPermission();
                          checkForPermission();
                        },
                        child: const Text('Grant'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    ));
  }
}
