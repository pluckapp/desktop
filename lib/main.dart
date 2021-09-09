//
// main.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/06/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pluck/foundation/data.dart';
import 'package:pluck/providers/hotkey.dart';
import 'package:pluck/providers/navigation/provider.dart';
import 'package:pluck/providers/request.dart';
import 'package:pluck/providers/session/provider.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Data.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RequestProvider()),
        ChangeNotifierProvider(create: (context) => SessionProvider()),
        ChangeNotifierProvider(create: (context) => HotKeyProvider(context)),
        ChangeNotifierProvider(create: (context) => NavProvider(context)),
      ],
      child: MediaQuery(
        data: MediaQueryData(),
        child: Main(),
      )
    )
  );

  doWhenWindowReady(() {
    const initialSize = Size(300, 450);

    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
  });
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with TrayListener {

  @override
  void initState() { 
    _setupTray();

    context.read<HotKeyProvider>().register();

    super.initState();  
  }

  void _setupTray() {
    TrayManager.instance.setIcon('assets/images/tray_icon.png');
    TrayManager.instance.addListener(this);
  }

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      debugShowCheckedModeBanner: false,
      title: 'Pluck',
      theme: MacosThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: MacosThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: context.read<NavProvider>().router.generator,
      initialRoute: '/'
    );
  }

  @override
  void onTrayIconMouseUp() async {
    Rect frame = await TrayManager.instance.getBounds(); 
    final x = -(MediaQuery.of(context).size.width - frame.left);
    final y = 0.0;

    appWindow.position = Offset(x, y);

    if(appWindow.isVisible) {
      appWindow.hide();
    } else {
      appWindow.show();
    }
  }
}

