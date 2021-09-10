//
// link.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/material.dart';
import 'package:pluck/foundation/data.dart';
import 'package:pluck/providers/link/model.dart';
import 'package:pluck/foundation/shortcode.dart';

enum LinkType {
  Text,
  Image,
  URL,
}

class LinkProvider extends ChangeNotifier {
  List<Link> _list = [];
  List<Link> get list => _list;
  

  LinkProvider() {
    load();
  }

  Future<List<Link>> load() async {
    final response = await Database.links.list();
    final data = response.data;
    final list = data['documents'].map((d) => Link.fromJson(d)).toList();

    _list = List<Link>.from(list);
    
    notifyListeners();
    return _list;
  }

  Future<Link> save({
    required String userId,
    required String url,
    required LinkType type,
    String? tag,
  }) async {

    print("Saving...");

    final code = _generateCode();

    print("code: $code");

    final response = await Database.links.create(
      {
        'userid': userId,
        'code': code,
        'url': url,
        'type': _typeKey(type),
        'tag': tag ?? userId
      }, 
      userId
    );

    print("RES: $response");

    final link = Link.fromJson(response.data);

    print("link: $link");

    print("loading...");
    await load();

    print("returning link");
    return link;
  }

  String _typeKey(LinkType type) {
    switch(type) {
      case LinkType.Image:
        return 'image';
      case LinkType.Text:
        return 'text';
      case LinkType.URL:
      return 'url';
    }
  }

  String _generateCode() {
    int len = _list.length + 1;

    final code = generate(len);
    
    if(_list.indexWhere((element) => element.code == code) > -1) {
      return _generateCode();
    }

    return code;
  }
}