//
// api.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/06/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:io' as io; 
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pluck/foundation/file.dart';
import 'package:pluck/providers/link/model.dart';

class Api {
  static String project = '613a23243739a';
  static String host = 'https://api.devpipe.com/v1';
  static String shareHost = "http://plk.io";
  
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

  static String shortUrl(Link link) {
    String user = link.userId;
    String code = link.code;
    
    final host = shareHost;

    return '$host/$user/$code';
  }

  static Future<String> uploadImage(Uint8List data, String accountId) async {
      
    final contentType = MediaType.parse('image/png');
    final imageFile = await File.tempImageFile(data);
    final multipart = await MultipartFile.fromFile(imageFile, contentType: contentType);

    var response = await Api.storage.createFile(
      file: multipart,
      read: ['*'],
    );

    final id = response.data['\$id'];
    final imgUrl = Api.urlForStorage(id);
    _delete(imageFile);

    return imgUrl;
  }

  static Future<void> _delete(String path) async {    
    await io.File(path).delete();
  }

  static Future<String> uploadText(String text, String accountId) async {
    final contentType = MediaType.parse('plain/text');
    final textFile = await File.tempTextFile(text);
    final multipart = await MultipartFile.fromFile(textFile, contentType: contentType);

    var response = await Api.storage.createFile(
      file: multipart,
      read: ['*']
    );

    final id = response.data['\$id'];
    final txtUrl = Api.urlForStorage(id);

    _delete(textFile);

    return txtUrl;
  }

  static Future<String> uploadURL(String url, String _accountId) async {
    return url;
  }

}