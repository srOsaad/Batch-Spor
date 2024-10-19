import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BackupSystem {
  String dirPath;
  BackupSystem({required this.dirPath});

  Future<void> backup(BuildContext context, {bool showSnack = true}) async {
    try {
      Directory targetDir = Directory(dirPath);
      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      List<FileSystemEntity> existingFiles = targetDir.listSync();
      for (var file in existingFiles) {
        if (file is File) {
          await file.delete();
        }
      }
      Directory appDir =
          Directory('${(await getApplicationDocumentsDirectory()).path}/db');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      List<FileSystemEntity> files = appDir.listSync();
      for (var file in files) {
        if (file is File) {
          String fileName = file.uri.pathSegments.last;
          String targetFilePath = '$dirPath/$fileName';
          await file.copy(targetFilePath);
        }
      }
      if (showSnack)
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Backuped!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e}')));
    }
  }

  Future<void> restore(BuildContext context) async {
    try {
      Directory appDir =
          Directory('${(await getApplicationDocumentsDirectory()).path}/db');
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      List<FileSystemEntity> existingFiles = appDir.listSync();
      for (var file in existingFiles) {
        if (file is File) {
          await file.delete();
        }
      }

      Directory sourceDir = Directory(dirPath);
      if (!await sourceDir.exists()) {
        await appDir.create(recursive: true);
        return;
      }

      List<FileSystemEntity> files = sourceDir.listSync();

      for (var file in files) {
        if (file is File) {
          String fileName = file.uri.pathSegments.last;
          String targetFilePath = '${appDir.path}/$fileName';
          await file.copy(targetFilePath);
        }
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Restored!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e}')));
    }
  }

  static Future<bool> isGranted() async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt > 29) {
      PermissionStatus status = await Permission.manageExternalStorage.status;
      return status.isGranted;
    } else {
      PermissionStatus status = await Permission.storage.status;
      return status.isGranted;
    }
  }

  static Future<void> requestForPermission() async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt > 29) {
      await Permission.manageExternalStorage.request();
    } else {
      await Permission.storage.request();
    }
  }
}
