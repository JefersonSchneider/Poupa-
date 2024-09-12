import 'dart:async';

import 'package:app_monitoramento/components/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => InitState();
}

class InitState extends State<SplashScreen> {

  @override
  InitState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, loginRoute);
  }

  loginRoute() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => const LoginScreen()
    ));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color:  Color(0xFF2C3E50),
              gradient: LinearGradient(colors: [
                Color(0xFF4A90E2),
                Color(0xFF5BA1F2),
              ], // Add a comma here
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)
            )
          ),

          Center(
            child: Container(
              child: Image.asset("images/poupa_logo.png"),
            ),
          )
        ],
      ),
    );
  }
}