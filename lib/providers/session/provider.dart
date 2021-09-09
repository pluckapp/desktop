//
// provider.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/foundation/data.dart';
import 'model.dart';

class SessionProvider extends ChangeNotifier {
  Box _box = Hive.box(Data.session);

  Session? _session;
  Session? get session => _session;

  SessionProvider() {
    var cached = _box.get('_current');

    if(cached != null) {
      _session = Session.fromJson(Map<String, dynamic>.from(cached));
    }
  }

  Future<void>createAnonymous() async {
    if(_session != null) { return; }

    try {
      final result = await Api.account.createAnonymousSession();
      final data = Map<String, dynamic>.from(result.data);
      

      _session = Session.fromJson(data);
      saveSession();

    } on AppwriteException catch(e) {
      print("createAnon: ${e.message}");
    }

  }

  Future<Session?>getSession() async  {
    try {
      final result = await Api.account.getSession(sessionId: 'current');
      final data = Map<String, dynamic>.from(result.data);

      _session = Session.fromJson(data);

      saveSession();

      return _session;
    } on AppwriteException catch(e) {
      await createAnonymous();
    }
  }

  void saveSession() {
    if(_session == null) { return; }

    _box.put('current', _session!.json);

    notifyListeners();
  }
}