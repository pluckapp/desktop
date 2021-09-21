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
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/foundation/data.dart';
import 'package:pluck/providers/user/model.dart';
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

  Future<Session?> create({required String email, required String password}) async {
    final response = await Api.account.create(email: email, password: password);
    final data = Map<String, dynamic>.from(response.data);

    _session = Session.fromJson(data);
    saveSession();
  }

  Future<void> delete() async {
    if(_session == null) { return; }

    await Api.account.deleteSession(sessionId: _session!.id);
    await _box.delete('current');

    notifyListeners();
  }

  Future<Session>getSession() async  {
    try {
      final result = await Api.account.getSession(sessionId: 'current');
      final data = Map<String, dynamic>.from(result.data);

      var session = Session.fromJson(data);

      final user = await getAccount();

      session = session.update(user: user);

      _session = session;
      
      saveSession();

      return _session!;
    } on AppwriteException catch(_) {
      await createAnonymous();

      return _session!;
    }
  }

  void saveSession({Session? session}) {
    Session? saving = session ?? _session;

    if(saving == null) { return; }

    _box.put('current', saving.json);

    notifyListeners();
  }

  Future<User?> getAccount() async {
    try {
      final result = await Api.account.get();
      final data = Map<String,dynamic>.from(result.data);

      return User.fromJson(data);
    } on AppwriteException catch(_) {
      return null;
    } catch(e) {
      print("getAccount error: $e");

      return null;
    }
  }
}