//
// hotkeys.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:pluck/providers/link/model.dart';
import 'package:pluck/providers/link/provider.dart';
import 'package:pluck/providers/session/model.dart';
import 'package:pluck/providers/session/provider.dart';
import 'package:provider/provider.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/foundation/notification.dart';

typedef HotkeyCallback = Function(BuildContext context);

class Hotkeys {
  static List<HotKey> _keys = [
    HotKey(
      KeyCode.keyA,
      modifiers: [
        KeyModifier.control,
        KeyModifier.alt
      ],
      scope: HotKeyScope.system
    ),
  ];

  static List<HotKey> get keys => _keys;

  static BuildContext? _context;

  static Future<void> register(BuildContext context) async {
    _context = context;

    await Future.wait(
      keys.map((k) => HotKeyManager.instance.register(
        k,
        keyDownHandler: onDown,
        keyUpHandler: onUp
      ))
    );
  }

  static Future<void>unregister() async {
    await Future.wait(
      keys.map(HotKeyManager.instance.unregister)
    );
  }

  static void onDown(k) {
  }

  static void onUp(k) {
    _upload(_context!);
  }


  static Future<void> _upload(BuildContext context) async {
    Session? session = await context.read<SessionProvider>().getSession();
    if(session == null) {
      print("Hotkeys can't get a session");
      return;
    }

    var image = await Pasteboard.image;
    var str = await Pasteboard.string;

    String address = "";
    LinkType type = LinkType.Image;

    try {
      if(image != null) {
        address = await Api.uploadImage(image, session.userId);
        type = LinkType.Image;
      } else if(str != null) {
        final isURL = Uri.tryParse(str)?.hasAbsolutePath ?? false;

        address = isURL
        ? await Api.uploadURL(str, session.userId)
        : await Api.uploadText(str, session.userId);

        type = isURL
        ? LinkType.URL
        : LinkType.Text;
      }

      if(address.length == 0) {
        throw Exception("Invalid address returned");
      }

      Link link = await context.read<LinkProvider>().save(
        userId: session.userId, 
        url: address, 
        type: type,
        tag: session.user?.username
      );

      copyShortcut(Api.shortUrl(link));

      await context.read<LinkProvider>().load();


    } on AppwriteException catch(err) {
      print("Paste Appwrite err: ${err.message}");

    } on FileSystemException catch (err) {
      print("FileSystem err: ${err.message}");
    }
  }

  static void copyShortcut(String url) {
    Clipboard.setData(
      ClipboardData(text: url)
    );

    NotificationService.show(
      title: '$url', 
      body: 'Has been copied clipboard'
    );
  }
}