//
// component.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/06/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:appwrite/appwrite.dart' show Response;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:pluck/foundation/data.dart';
import 'package:pluck/providers/session/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:provider/provider.dart';

class AppComponent extends StatefulWidget {
  @override
  _AppComponentState createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> with TrayListener {
  
  @override
  void initState() { 
    super.initState();
  }

  Widget _toolbar() {

    return Container(
      decoration: BoxDecoration(
        color: MacosDynamicColor.resolve(MacosColors.controlColor, context).withAlpha(5),
        border: Border(
          bottom: BorderSide(
            color: MacosDynamicColor.resolve(MacosColors.separatorColor, context).withAlpha(60),
          )
        )
      ),
      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Row(
        children: [
          Text("pluck"),
          Spacer(),
          PushButton(
            color: Colors.transparent,
            child: Icon(
              CupertinoIcons.settings,
              color: MacosDynamicColor.resolve(MacosColors.selectedMenuItemTextColor, context),
              size: 18,
            ), 
            buttonSize: ButtonSize.small,
            onPressed: () {},
          )
        ],
      )
    );
  }

  Widget _entry(BuildContext context) {
    return MacosScaffold(
      children: [
        ContentArea(builder: (context, _controller) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _toolbar(),
                Expanded(
                  child: Container(
                    child: FutureBuilder(
                      future: Database.links.list(),
                      builder: (context, AsyncSnapshot<Response> snap) {
                        if(snap.connectionState != ConnectionState.done) {
                          return Container(child: Text("Loading..."));
                        } 

                        Response? response = snap.data;

                        if(response == null) {
                          return Container(child: Text("Empty."));
                        }

                        final results = List<Map<String, dynamic>>.from(Map<String, dynamic>.from(response.data)['documents']);
                        final docs = results
                        .map((item) => {
                          'id': item['\$id'],
                          'account_id': item['account_id'],
                          'url': item['url']
                        })
                        .toList();

                        
                        if(docs.length == 0) {
                          return Container(child: Text("Empty"));  
                        }

                        return Container(
                          child: ListView.separated(
                            padding: EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              final item = docs[index];
                              final id = item['id'];
                              final user = item['account_id'];

                              return Container(
                                padding: EdgeInsets.all(6),
                                child: Text("$user/$id"),
                              );
                            }, 
                            separatorBuilder: (context, _index) => Divider(), 
                            itemCount: docs.length
                            )
                        );
                      },
                    )
                  )
                )
              ],
            )
          );
        })
      ],
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressCircle(value: null,),
          SizedBox(width: 10,),
          Container(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text("Starting up...")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<SessionProvider>().getSession(),
      builder: (context, snap) {
        if(snap.connectionState != ConnectionState.done) {
          return _loading(context);
        }

        return _entry(context);    
      },
    );
  }

}
