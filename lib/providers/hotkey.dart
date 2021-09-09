//
// hotkey.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/09/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/providers/request.dart';
import 'package:pluck/providers/session/model.dart';
import 'package:pluck/providers/session/provider.dart';
import 'package:provider/provider.dart';

class HotKeyProvider extends ChangeNotifier {
  final BuildContext _context;

  List<HotKey> _keys = [
    HotKey(
      KeyCode.keyA,
      modifiers: [
        KeyModifier.control,
        KeyModifier.alt
      ],
      scope: HotKeyScope.system
    ),
  ];

  List<HotKey> get keys => _keys;

  HotKeyProvider(BuildContext context) : _context = context;

  Future<void> register() async {
    await Future.wait(
      keys.map((k) => HotKeyManager.instance.register(
        k,
        keyDownHandler: onDown,
        keyUpHandler: onUp
      ))
    );
  }

  void onDown(k) {
  }

  void onUp(k) {
    print("Key up");
    _upload();
  }


  Future<void> _upload() async {
    Session? session = await _context.read<SessionProvider>().getSession();
    if(session == null) {
      print("Upload no sesh");
      return;
    }

    var img = await Pasteboard.image;
    // var url = await Pasteboard.absoluteUrlString;
    // var uri = await Pasteboard.uri;
    var str = await Pasteboard.string;
    Response<dynamic>? response;

    try {
      if(img != null) {
        response = await _context.read<RequestProvider>().uploadImage(img, session.userId);
      } else if(str != null) {
        final isURL = Uri.tryParse(str)?.hasAbsolutePath ?? false;

        response = isURL
        ? await _context.read<RequestProvider>().uploadURL(str, session.userId)
        : await _context.read<RequestProvider>().uploadText(str, session.userId);
      }

      if(response != null) {
        final session = _context.read<SessionProvider>().session;

        final id = response.data['\$id'];
        final shortURL = await Api.shortUrl(session!.userId, id);

        Clipboard.setData(
          ClipboardData(text: shortURL)
        );
      }

    } on AppwriteException catch(err) {
      print("ERRRR: ${err.message}");
    } on FileSystemException catch (err) {
      print("ERRRR: ${err.message}");
    }

    return;
  }
}