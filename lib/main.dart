import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'backend_and_modals/batch_class.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir =
      Directory('${(await getApplicationDocumentsDirectory()).path}/db');
  if (!await appDocumentDir.exists()) {
    await appDocumentDir.create(recursive: true);
  }
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ClassAdapter());
  Hive.registerAdapter(BatchAdapter());
  runApp(const App());
}
