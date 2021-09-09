//
// file.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'dart:io' as io; 
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart' show Response, MultipartFile;
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:pluck/foundation/api.dart';
import 'package:pluck/foundation/data.dart';
import 'package:pluck/foundation/file.dart';
import 'package:uuid/uuid.dart';

final _uuid = Uuid();

class RequestProvider extends ChangeNotifier {
  bool _inProgress = false;
  bool get inProgress => _inProgress;

  Future<Response<dynamic>> uploadImage(Uint8List data, String accountId) async {
    _inProgress = true;
    notifyListeners();

    final contentType = MediaType.parse('image/png');
    final imageFile = await File.tempImageFile(data);
    final multipart = await MultipartFile.fromFile(imageFile, contentType: contentType);

    var response = await Api.storage.createFile(
      file: multipart,
      read: ['*'],
    );

    final id = response.data['\$id'];
    final imgUrl = Api.urlForStorage(id);

    response = await uploadURL(imgUrl, accountId);

    _inProgress = false;
    notifyListeners();

    _delete(imageFile);
    return response;
  }

  Future<Response<dynamic>> uploadText(String text, String accountId) async {
    _inProgress = true;
    notifyListeners();

    final contentType = MediaType.parse('plain/text');
    final textFile = await File.tempTextFile(text);
    final multipart = await MultipartFile.fromFile(textFile, contentType: contentType);

    var response = await Api.storage.createFile(
      file: multipart,
      read: ['*']
    );

    final id = response.data['\$id'];
    final txtUrl = Api.urlForStorage(id);

    response = await uploadURL(txtUrl, accountId);

    _inProgress = false;
    notifyListeners();

    _delete(textFile);
    return response;
  }

  Future<Response<dynamic>> uploadURL(String text, String userId, {String? name}) async {
    _inProgress = true;
    notifyListeners();

    var response = await Database.links.create(
      {
        'url': text,
        'account_id': userId
      },
      userId
    );

    final id = response.data['\$id'];

    _inProgress = false;
    notifyListeners();

    return response;
  }

  static String _name(String? name) {
    return name ?? _uuid.v4().split('-').first;
  }

  static Future<void> _delete(String path) async {
    await io.File(path).delete();
  }
}