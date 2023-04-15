import 'dart:async';
import 'package:flutter/material.dart';
import '../../shared/constants/components.dart';
import '../../shared/constants/router_const.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(milliseconds: 1500), () {
      navigateToAndRemoveUntil(context: context, screen: homeScreen);
    });
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          'assets/images/todo.png',
          height: MediaQuery.of(context).size.height * 1 / 2,
          width: MediaQuery.of(context).size.width * 1 / 2,
        ),
      ),
    );
  }
}
