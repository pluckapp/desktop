//
// component.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pluck/components/onboarding/component.dart';
import 'package:pluck/components/onboarding/provider.dart';
import 'package:pluck/providers/navigation/provider.dart';
import 'package:pluck/widgets/button.dart';
import 'package:provider/provider.dart';

class SettingsComponent extends StatefulWidget {

  @override
  State<SettingsComponent> createState() => _SettingsComponentState();
}

class _SettingsComponentState extends State<SettingsComponent> {
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
      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.only(top: 4),
            child: PushButton(
              color: Colors.transparent,
              child: Icon(
                FluentIcons.dismiss_12_regular,
                color: MacosDynamicColor.resolve(MacosColors.selectedMenuItemTextColor, context),
                size: 14,
              ), 
              buttonSize: ButtonSize.small,
              onPressed: () => context.read<NavProvider>().pop(context),
            ),
          ),
          Expanded(child: Container()),
          PushButton(
            color: Colors.transparent,
            child: Icon(
              FluentIcons.person_12_filled,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MacosScaffold(
        children: [
          ContentArea(builder: (builder, _conntroller) {
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  _toolbar(),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: IndexedStack(
                      index: 0,
                      children: [
                        ChangeNotifierProvider(
                          create: (_context) => OnboardingProvider(),
                          child: OnboardingComponent(),
                        ),
                        Container(child: Text("placeholder")),
                        Container(child: Text("placeholder")),
                        Container(child: Text("placeholder")),
                      ],
                    )
                  )
                ],
              )
            );
          })
        ],
      )
    );
  }
}