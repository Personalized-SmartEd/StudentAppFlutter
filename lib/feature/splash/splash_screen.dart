import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
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
  late RiveAnimationController _riveController;

  @override
  void initState() {
    super.initState();
    print("Starting app");
    AuthServices.getUserData(context);
    print("Started app");
    Timer(const Duration(seconds: 3), () {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      Navigator.of(context).pushReplacement(
          _createRoute(userProvider.user.id != "" ? const Home() : Login()));
    });
    _riveController = OneShotAnimation(
      'Animation',
      autoplay: true,
    );
    setState(() {
      _riveController.isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(color: Colors.blue),
        child: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            child: RiveAnimation.asset(
              'assets/rive/kid-walk.riv',
              controllers: [_riveController],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
