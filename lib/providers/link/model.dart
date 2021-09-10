//
// model.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/10/2021
// 
// Copywrite (c) 2021 Wess.io
//

class Link {
  final String id;
  final String userId;
  final String code;
  final String url;
  final String type;
  final String? tag;

  Map<String, dynamic> get json => {
    'id': this.id,
    'userId': this.userId,
    'code': this.code,
    'url': this.url,
    'type': this.type,
    'tag': this.tag
  };

  Link({
    required this.id,
    required this.userId,
    required this.code,
    required this.url,
    required this.type,
    this.tag
  });

  static Link fromJson(Map<String, dynamic> data) {
    return Link(
      id: data['\$id'],
      userId: data['userid'],
      code: data['code'],
      url: data['url'],
      type: data['type'],
      tag: data['tag']
    );
  }
}