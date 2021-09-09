//
// handlers.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/09/2021
// 
// Copywrite (c) 2021 Wess.io
//

import "package:fluro/fluro.dart";
import 'package:flutter/material.dart';
import 'package:pluck/components/app/component.dart';

typedef RouteParams = Map<String, dynamic>;

class NavHandler {  
  static Handler notFound = Handler(handlerFunc: (BuildContext? context, RouteParams params) {
    return Container(
      child: Text("Not fouund")
    );
  });

  static Handler root = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => AppComponent());
}