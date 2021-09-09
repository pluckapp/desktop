//
// hotkeys.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/06/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/material.dart';
import 'package:pluck/providers/hotkey.dart';
import 'package:provider/provider.dart';

class HotKeyInterface extends StatefulWidget {
  final Widget child;

  HotKeyInterface({
    Key? key,
    required this.child
  }) : super(key: key);

  @override
  _HotKeyInterfaceState createState() => _HotKeyInterfaceState();
}

class _HotKeyInterfaceState extends State<HotKeyInterface> {

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<HotKeyProvider>().register(),
      builder: (context, _snap) => this.widget.child
    );
  }
}