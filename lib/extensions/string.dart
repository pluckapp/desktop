//
// string.dart
// Ancilla
// 
// Author: Wess Cope (me@wess.io)
// Created: 07/20/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:io';

extension StringExt on String {
  String toFirstUpperCase() {
    final first = this.substring(0, 1);
    final rest = this.substring(1);

    return first.toUpperCase() + rest;
  }

  Future<bool> get isDirectory async => (await FileSystemEntity.type(this)) == FileSystemEntityType.directory;
  Future<bool> get isFile async => (await FileSystemEntity.type(this)) == FileSystemEntityType.file; 

  bool isValidEmail() {
    return RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this);
  }
}