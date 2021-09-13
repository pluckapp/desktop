//
// provider.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/material.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/providers/user/model.dart';

class UserProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  User? _user;
  User? get user => _user;

  Future<User> register({
    required String email,
    required String password,
    required String username
  }) async {
    await Api.account.updatePassword(password: password);
    await Api.account.updateEmail(email: email, password: password);
    
    final response = await Api.account.updateName(name: username);
    
    return User.fromJson(response.data);
  }
}