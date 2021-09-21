//
// provider.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/providers/session/provider.dart';
import 'package:provider/provider.dart';
import 'package:pluck/providers/user/model.dart';

class UserProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  User? _user;
  User? get user => _user;

  BuildContext _context;
  UserProvider(BuildContext context): _context = context;

  Future<User?> register({
    required String email,
    required String password,
    required String username
  }) async {
    try {
      await Api.account.updateEmail(email: email, password: password);
    
      final response = await Api.account.updateName(name: username);
      final user = User.fromJson(response.data);
      final session = (await _context.read<SessionProvider>().getSession());

      _context.read<SessionProvider>().saveSession(session: session);
      
      return user;

    } on AppwriteException catch(e) {
      print("E: ${e.message}");
    }

    return null;
  }
}