//
// signup.dart
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
import 'package:pluck/extensions/string.dart';

class UserSignup extends StatefulWidget {
  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _validate() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Sign up",
            style: TextStyle(
              color: MacosDynamicColor.resolve(MacosColors.textColor, context),
              fontSize: 18
            ),
          ),
          SizedBox(height: 6,),
          Divider(color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(20),),
          SizedBox(height: 6,),
          Container(
            child: Text(
              'Sign up and get your ugly url turned into one based on your username',
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
            placeholder: 'username',
            controller: _usernameController,
          ),
          SizedBox(height: 12,),
          MacosTextField(
            padding: EdgeInsets.all(12),
            placeholder: 'email',
            controller: _emailController
          ),
          SizedBox(height: 12,),
          MacosTextField(
            padding: EdgeInsets.all(12),
            placeholder: 'password',
            obscureText: true,
            controller: _passwordController
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  child: TextButton(
                    child: Text(
                      "Have an account? Sign in!",
                      style: TextStyle(
                        fontSize: 12
                      )
                    ),
                    onPressed: () {
                      context.read<OnboardingProvider>().viewSignin();
                    },
                  )
                )
              ),
              PushButton(
                child: Text("Submit"), 
                buttonSize: ButtonSize.large,
                onPressed: () {
                  context.read<OnboardingProvider>().viewSignin();
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}