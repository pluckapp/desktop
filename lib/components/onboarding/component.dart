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
import 'package:pluck/components/onboarding/provider.dart';
import 'package:provider/provider.dart';

class OnboardingComponent extends StatefulWidget {
  @override
  State<OnboardingComponent> createState() => _OnboardingComponentState();
}

class _OnboardingComponentState extends State<OnboardingComponent> {
  
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: context.watch<OnboardingProvider>().current,
      children: context.read<OnboardingProvider>().pages,
    );
  }
}