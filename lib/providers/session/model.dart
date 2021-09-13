//
// model.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:pluck/extensions/num.dart';
import 'package:pluck/providers/user/model.dart';

class Session {
  final String id;
  final String userId;
  final DateTime expire;
  final String provider;
  final String providerUid;
  final String providerToken;
  
  User? user;

  Map<String, dynamic> get json => {
    'id' : this.id,
    'userId' : this.userId,
    'expire' : this.expire.unixTimestamp,
    'provider' : this.provider,
    'providerUid' : this.providerUid,
    'providerToken' : this.providerToken,
  };

  Session({
    required this.id,
    required this.userId,
    required this.provider,
    required this.providerUid,
    required this.providerToken,
    required int expire
  }) : this.expire = expire.unixTimestamp;

  static Session fromJson(Map<String, dynamic> data) {
    return Session(
      id: data['\$id'],
      userId: data['userId'],
      expire: data['expire'],
      provider: data['provider'],
      providerUid: data['providerUid'],
      providerToken: data['providerToken'],
    );
  }
}