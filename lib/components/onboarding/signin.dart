//
// signin.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:pluck/components/onboarding/provider.dart';
import 'package:provider/provider.dart';

class UserSignin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Sign in",
            style: TextStyle(
              color: MacosDynamicColor.resolve(MacosColors.textColor, context),
              fontSize: 18
            ),
          ),
          SizedBox(height: 6,),
          Divider(color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(20),),
          Container(
            child: Text(
              'Enter email and password to sign into your account.',
              style: TextStyle(
                color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(160)
              ),
            ),
          ),
          SizedBox(height: 6,),
          Divider(color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(20),),
          SizedBox(height: 6,),
          MacosTextField(
            padding: EdgeInsets.all(12),
            placeholder: 'email',
          ),
          SizedBox(height: 12,),
          MacosTextField(
            padding: EdgeInsets.all(12),
            placeholder: 'password',
            obscureText: true,
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: TextButton(
                    child: Text(
                      "Need an account? Sign up!",
                      style: TextStyle(
                        fontSize: 12
                      )
                    ),
                    onPressed: () {
                      context.read<OnboardingProvider>().viewSignup();
                    },
                  )
                )
              ),
              PushButton(
                child: Text("Submit"), 
                buttonSize: ButtonSize.large,
                onPressed: () {},
              ),
            ],
          ),
        ],
      )
    );
  }
}