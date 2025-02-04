import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/login/login_page.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthServices authService = AuthServices();
  @override
  void initState() {
    super.initState();
    print("Starting app");
    authService.getUserData(context);
    print("Started app");
    Timer(const Duration(seconds: 1), () {
      final navigator = Navigator.of(context);
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) =>
                Provider.of<UserProvider>(context).user.id != ""
                    ? Home()
                    : Login()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Splash Screen"),
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.blue),
        child: const Center(
          child: Text("Splash Screen"),
        ),
      ),
    );
  }
}
