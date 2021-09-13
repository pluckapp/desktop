//
// component.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/material.dart';
import 'package:pluck/components/list/cell.dart';
import 'package:pluck/providers/link/model.dart';
import 'package:pluck/providers/link/provider.dart';
import 'package:provider/provider.dart';

class ListComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    List<Link> links = context.watch<LinkProvider>().list;

    return Container(
      child: ListView.separated(
        padding: EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final link = links[index];

          return Container(
            padding: EdgeInsets.all(6),
            child: ListCell(link: link,),
          );
        }, 
        separatorBuilder: (context, _index) => Divider(height: 0.1,), 
        itemCount: links.length
        )
    );
  }
}