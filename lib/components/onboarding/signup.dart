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
import 'package:pluck/providers/user/provider.dart';
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

  String _error = '';

  bool _validate() {
    if(
      _emailController.text.isEmpty &&
      _usernameController.text.isEmpty &&
      _passwordController.text.isEmpty 
    ) { 
      setState(() {
        _error = 'Email, username and password are required.';
      });

      return false; 
    }

    if(_emailController.text.isValidEmail() == false) { 
      setState(() {
        _error = 'Invalid email address';
      });
      
      return false; 
    }

    return true;
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
          if(_error.isEmpty == false)
          ...[
            SizedBox(height: 6,),
            Divider(color: MacosDynamicColor.resolve(MacosColors.textColor, context).withAlpha(20),),
            SizedBox(height: 6,),
            Container(
              padding: EdgeInsets.all(8),
              color: MacosDynamicColor.resolve(MacosColors.alternatingContentBackgroundColor, context).withAlpha(160),
              child: Text(
              _error,
              style: TextStyle(
                color: MacosDynamicColor.resolve(MacosColors.systemRedColor, context).withAlpha(160)
              ),
            ),
          )],
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
                onPressed: () async {
                  if(_validate() == false) { return; }

                  final user = await context.read<UserProvider>().register(
                    email: _emailController.text, 
                    password: _passwordController.text, 
                    username: _usernameController.text
                  );

                  print("New user: $user");
                },
              ),
            ],
          ),
        ],
      )
    );
  }
}