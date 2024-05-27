import 'dart:async';
import 'package:connect/WelcomeLogIn/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();

    // Navigate to LogInPage after 5 seconds
    Timer(const Duration(seconds: 5), () {
      Navigator.push(
        context,
        _createRoute(),
      );
    });
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LogInPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BounceInDown(
          // Animating the text with BounceInDown effect
          duration: Duration(seconds: 2),
          child: Text(
            'Campus Connect',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }
}
