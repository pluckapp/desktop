//
// file.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:io' as io;
import 'dart:typed_data';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

enum _TmpType {
  Image,
  String,
}

class File {
  static Future<io.Directory> get temp async => await getTemporaryDirectory();

  static Future<String> ensureDir(String path) async {
    final target = io.Directory(path);

    if(!(await target.exists())) {
      await target.create(recursive: true);
    }

    return path;
  }

  static Future<String> ensureFile(String path) async {
    final target = io.File(path);

    if(!(await target.exists())) {
      await target.create(recursive: true);
    }

    return path;
  }

  static Future<String> _writeTempFile(String path, dynamic data, _TmpType type) async {
    final tmpPath = await temp;

    final filePath = p.join(
      tmpPath.path,
      path
    );

    await ensureDir(p.dirname(filePath));

    io.File writeFile;
    switch(type)  {
      case _TmpType.Image:
        final bytes = data as Uint8List;
        writeFile = await io.File(filePath).writeAsBytes(bytes);
        break;
      case _TmpType.String:
        final contents = data as String;
        writeFile = await io.File(filePath).writeAsString(contents);
        break;
    }

    return writeFile.path;
  }

  static Future<String> tempImageFile(Uint8List data, {String? name}) async {
    return await _writeTempFile(
      _filePath('images', name: name, ext: 'png'),
      data,
      _TmpType.Image
    );
  }

  static Future<String> tempTextFile(String data, {String? name}) async {
    return await _writeTempFile(
      _filePath('text', name: name, ext: 'txt'),
      data,
      _TmpType.String
    );
  }

  static String _filePath(String prefix, {String? name, String? ext}) {
    final id = name ?? _uuid.v4().split('-').first;
    final dot = ext == null ? '' : '.$ext';
    
    return p.join(
      prefix,
      '$id$dot'
    );
  }
}