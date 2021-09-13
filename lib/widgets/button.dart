//
// button.dart
// Ancilla
// 
// Author: Wess Cope (me@wess.io)
// Created: 06/24/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class AppIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback onPressed;
  double? _size;
  Color? _backgroundColor;

  AppIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    double? size,
    Color? backgroundColor,
  }) :
    _size = size,
    _backgroundColor = backgroundColor,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _backgroundColor ?? MacosTheme.of(context).canvasColor;
    final size = _size ?? 32;

    return MacosIconButton(
      boxConstraints: BoxConstraints(
        maxHeight: size,
        minHeight: size,
        maxWidth: size,
        minWidth: size 
      ),
      backgroundColor: backgroundColor,
      onPressed: onPressed,
      icon: icon,
      shape: BoxShape.rectangle,
    );    
  }
}
