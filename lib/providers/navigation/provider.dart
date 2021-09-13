//
// nav.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/09/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import './handlers.dart';

class NavProvider extends ChangeNotifier {
  FluroRouter _router = FluroRouter();
  FluroRouter get router => _router;

  Map<String, Handler> _handlers = {
    '/' : NavHandler.root,
    '/settings' : NavHandler.settings,
  };

  NavProvider() {
    _configureRoutes();
  }

  _configureRoutes() {
    router.notFoundHandler = NavHandler.notFound;

    _handlers.forEach((key, value) => router.define(key, handler: value));
  }

  void push(BuildContext context, String to) {
    _router.navigateTo(context, to);
  }

  void pop(BuildContext context) {
    _router.pop(context);
  }
}