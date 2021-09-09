//
// api.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/06/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:appwrite/appwrite.dart';

class Api {
  static String project = '613a23243739a';
  static String host = 'https://api.devpipe.com/v1';
  static String shareHost = "http://localhost:1234";
  
  final Client _client;
  Client get client => _client;
  
  Api() : _client = Client() {
    _client
    .setEndpoint(host)
    .setProject(project)
    .setSelfSigned();
  }

  static Api? _instance;
  static Api get instance {
    if(_instance == null) {
      _instance = Api();
    }

    

    return _instance!;
  }

  static Account? _account;
  static Account get account {
    if(_account == null) {
      _account = Account(instance.client);
    }

    return _account!;
  }

  static Storage? _storage;
  static Storage get storage {
    if(_storage == null) {
      _storage = Storage(instance.client);
    }

    return _storage!;
  }

  static Database? _database;
  static Database get database {
    if(_database == null) {
      _database = Database(instance.client);
    }

    return _database!;
  }

  static String urlForStorage(String id) {
    return '$host/storage/files/$id/view?project=$project';
  }

  static Future<String> shortUrl(String user, String name) async {
    final host = shareHost;

    return '$host/$user/$name';
  }
}