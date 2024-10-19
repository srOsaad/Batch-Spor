import 'package:flutter/material.dart';
import 'pages/settings_page.dart';
import 'pages/home_page.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'backend_and_modals/cache_database.dart';
import 'backend_and_modals/settings_data.dart';
import 'backend_and_modals/backup_system.dart';
import 'dart:io';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _darkMode = false;
  Color seedColor = Color(0xff536dfe);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        platform: TargetPlatform.android,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        platform: TargetPlatform.android,
        useMaterial3: true,
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: ScaffoldStage(
        onDarkModeChanged: (darkMode) {
          if (darkMode != _darkMode) {
            setState(() {
              _darkMode = darkMode;
            });
          }
        },
        onColorChanged: (color) {
          if (color != seedColor) {
            setState(() {
              seedColor = color;
            });
          }
        },
      ),
    );
  }
}

class ScaffoldStage extends StatefulWidget {
  final Function(bool) onDarkModeChanged;
  final Function(Color) onColorChanged;
  ScaffoldStage(
      {super.key,
      required this.onDarkModeChanged,
      required this.onColorChanged});
  @override
  ScaffoldStageState createState() => ScaffoldStageState();
}

class ScaffoldStageState extends State<ScaffoldStage> {
  int currentPage = 0, classLeft = 0;
  CacheDatabase cache = CacheDatabase();
  bool initialized = false;
  bool showLoadingIndicator = false;
  late SettingsData settingsData = SettingsData(
    darkMode: true,
    priorityMode: true,
    ascendingMode: true,
    sortingOption: 0,
    colorAscent: Color(0xff536dfe),
    colorAscentText: Colors.white,
    backUrl: "",
  );
  final GlobalKey<HomePageState> _homePageKey = GlobalKey<HomePageState>();
  String getGreeting() {
    final hour = DateTime.now().hour;
    return hour >= 5 && hour < 12
        ? "Good Morning"
        : hour >= 12 && hour < 17
            ? "Good Afternoon"
            : hour >= 17 && hour < 19
                ? "Good Evening"
                : !settingsData.priorityMode
                    ? "Not calculated!"
                    : classLeft == 0
                        ? "All done for today!"
                        : "You have ${classLeft.toString()} ${classLeft == 1 ? "class" : "classes"} left";
  }

  @override
  void initState() {
    super.initState();
    _initializePrefs();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          showLoadingIndicator = true;
        });
      }
    });
  }

  Future<void> _initializePrefs() async {
    await cache.init();
    settingsData = cache.settings();
    setState(() {
      initialized = true;
      widget.onDarkModeChanged(settingsData.darkMode);
      widget.onColorChanged(settingsData.colorAscent);
    });
    Future.delayed(const Duration(seconds: 3), () async {
      if (cache.lastBackuped() - DateTime.now().day != 0) {
        await backupData();
        cache.setLastBackuped(DateTime.now().day);
      }
    });
  }

  Future<bool> backupData() async {
    if (await BackupSystem.isGranted()) {
      String? backUrl = cache.backupUrl();
      if (backUrl != null) {
        if (await Directory(backUrl).exists()) {
          BackupSystem bSystem = BackupSystem(dirPath: backUrl);
          bSystem.backup(context, showSnack: false);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please set backup url!')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please set backup url!')));
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (!initialized && showLoadingIndicator) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: currentPage == 0
          ? AppBar(
              title: Text(getGreeting()),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: const Icon(Icons.refresh))
              ],
            )
          : AppBar(
              title: const Text('Settings'),
            ),
      body: currentPage == 0
          ? HomePage(
              key: _homePageKey,
              settingsData: settingsData,
              onClassLeftChanged: (p0) => setState(() {
                classLeft = p0;
              }),
            )
          : SettingsPage(
              settingsData: settingsData,
              onSettingsChanged: (p0) {
                widget.onDarkModeChanged(p0.darkMode);
                widget.onColorChanged(p0.colorAscent);
                cache.setSettings(p0);
                settingsData = p0;
                setState(() {});
              },
            ),
      floatingActionButton: currentPage == 0
          ? FloatingActionButton(
              backgroundColor: settingsData.colorAscent,
              onPressed: () {
                _homePageKey.currentState?.addModifyBatch(null);
              },
              child: Icon(
                Icons.add,
                color: settingsData.colorAscentText,
              ),
            )
          : null,
      bottomNavigationBar: FluidNavBar(
        style: FluidNavBarStyle(
          barBackgroundColor: settingsData.colorAscent,
        ),
        onChange: (selectedIndex) {
          setState(() {
            currentPage = selectedIndex;
          });
        },
        icons: [
          FluidNavBarIcon(icon: Icons.home_rounded),
          FluidNavBarIcon(icon: Icons.settings_rounded),
        ],
      ),
    );
  }
}
