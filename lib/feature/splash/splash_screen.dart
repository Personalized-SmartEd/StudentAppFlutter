import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/login/login_page.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/home_screen.dart';
import 'package:smarted/feature/splash/gettingstarted.dart';

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
      Navigator.of(context).pushReplacement(RouteAnimation.BottomUpRoute(
          userProvider.user.id != "" ? Home() : OnboardingScreen()));
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
        decoration: BoxDecoration(color: Theme.of(context).primaryColor),
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
