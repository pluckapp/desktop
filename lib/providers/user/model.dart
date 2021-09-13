//
// model.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:pluck/types/meta.dart';

class User {
  final String id;
  final String email;
  final String username;
  final int status;
  final Meta prefs;

  Map<String, dynamic> get json => {
    'id': this.id,
    'email': this.email,
    'name': this.username,
    'status': this.status,
    'prefs': this.prefs.json
  };

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.status,
    Meta? prefs
  }) :  this.prefs = prefs ?? Meta();

  static User fromJson(Map<String, dynamic> data) {
    return User(
      id: data['\$id'],
      email: data['email'],
      username: data['name'],
      status: data['status'],
      prefs: Meta(data: data['prefs'])
    );
  }
}