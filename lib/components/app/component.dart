//
// component.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 08/06/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pluck/components/list/component.dart';
import 'package:pluck/providers/link/provider.dart';
import 'package:pluck/providers/navigation/provider.dart';
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
      padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
      child: Row(
        children: [
          Text("pluck"),
          Spacer(),
          PushButton(
            color: Colors.transparent,
            child: Icon(
              FluentIcons.settings_28_filled,
              color: MacosDynamicColor.resolve(MacosColors.selectedMenuItemTextColor, context),
              size: 18,
            ), 
            buttonSize: ButtonSize.small,
            onPressed: () => context.read<NavProvider>().push(context, '/settings'),
          )
        ],
      )
    );
  }

  Widget _entry(BuildContext context) {
    bool loading = context.watch<LinkProvider>().loading;

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
                    child: loading
                    ? Container(child: Text("Loading..."))
                    : ListComponent()
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
