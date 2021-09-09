//
// cache.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/09/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:appwrite/appwrite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pluck/foundation/api.dart';

class Data {
  static String session = '_session';

  static Future<void> init({List<String> boxes = const []}) async {
    final dir = await getApplicationSupportDirectory();

    await Hive.initFlutter(dir.path); 

    await Future.wait([
      session,
      ...boxes
    ].map(Hive.openBox));
  }

  static Box box(String name) {
    return Hive.box(name);
  }
}

class Collection {
  final String _id;

  Collection(String id) : this._id = id;

  Future<Response<dynamic>> create(Map<String, dynamic> data, String userId) async {
    return await Api.database.createDocument(
      collectionId: _id, 
      data: data,
      read: ['*'],
      write: ['user:$userId'],
    );
  }

  Future<Response<dynamic>> list() async {
    return await Api.database.listDocuments(collectionId: _id);
  }

  Future<Response<dynamic>> get(String id) async {
    return await Api.database.getDocument(
      collectionId: _id, 
      documentId: id
    );
  }

  Future<Response<dynamic>> update({required String id, required Map<String, dynamic> data}) async {
    return await Api.database.updateDocument(
      collectionId: _id, 
      documentId: id, 
      data: data
    );
  }

  Future<Response<dynamic>> delete(String id) async {
    return await Api.database.deleteDocument(
      collectionId: _id, 
      documentId: id
    );
  }
}

class Database {
  static Collection get links => Collection('613a285362dfb');
}
