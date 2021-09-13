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
import 'package:pluck/extensions/num.dart';

enum LinkType {
  Text,
  Image,
  URL,
}

class LinkProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  List<Link> _list = [];
  List<Link> get list => _list;

  LinkProvider() {
    load();
  }

  Future<List<Link>> load() async {
    _loading = true;
    notifyListeners();
    
    final response = await Database.links.list();
    final data = response.data;
    final list = data['documents'].map((d) => Link.fromJson(d)).toList();
    
    _list = List<Link>.from(list);
    
    _loading = false;
    notifyListeners();
    return _list;
  }

  Future<Link> save({
    required String userId,
    required String url,
    required LinkType type,
    String? tag,
  }) async {

    _loading = true;
    notifyListeners();

    final code = _generateCode();

    final response = await Database.links.create(
      {
        'userid': userId,
        'code': code,
        'url': url,
        'type': _typeKey(type),
        'tag': tag ?? userId,
        'timestamp': DateTime.now().unixTimestamp
      }, 
      userId
    );

    final link = Link.fromJson(response.data);
    await load();

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