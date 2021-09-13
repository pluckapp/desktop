//
// provider.dart
// pluck
// 
// Author: Wess Cope (me@wess.io)
// Created: 09/13/2021
// 
// Copywrite (c) 2021 Wess.io
//

import 'package:flutter/foundation.dart';
import 'package:pluck/components/onboarding/signin.dart';
import 'package:pluck/components/onboarding/signup.dart';

class OnboardingProvider extends ChangeNotifier {

  final pages = [
    UserSignup(),
    UserSignin()
  ];

  int _current = 0;
  int get current => _current;

  List<String> _errors = [];
  List<String> get errors => _errors;

  void viewSignup() {
    _current = 0;
    notifyListeners();
  }

  void viewSignin() {
    _current = 1;
    notifyListeners();
  }
}