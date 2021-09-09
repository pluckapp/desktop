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
  final BuildContext _context;

  FluroRouter _router = FluroRouter();
  FluroRouter get router => _router;

  Map<String, Handler> _handlers = {
    '/' : NavHandler.root,
  };

  NavProvider(BuildContext context): this._context = context {
    _configureRoutes();
  }

  _configureRoutes() {
    router.notFoundHandler = NavHandler.notFound;

    _handlers.forEach((key, value) => router.define(key, handler: value));
  }
}