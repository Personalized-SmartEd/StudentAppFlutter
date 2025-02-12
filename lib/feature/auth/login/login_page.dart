import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;
import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/signup/signup_page.dart';
import 'package:smarted/shared/typography/heading_24_semibold.dart';
import 'package:smarted/widgets/button/primary_button.dart';
import 'package:smarted/widgets/button/secondary_button.dart';
import 'package:smarted/widgets/divider.dart';
import 'package:smarted/widgets/inputbox.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPressed = false;
  late rive.RiveAnimationController _riveController;

  @override
  void initState() {
    super.initState();
    _riveController = rive.OneShotAnimation(
      'Idle_CH',
      autoplay: true,
    );
  }

  Future<void> _login() async {
    _changeAnimationState();
    setState(() {
      isPressed = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      await AuthServices.loginUser(
        context: context,
        Password: _passwordController.text,
        Email: _emailController.text,
      );
    }
    setState(() {
      isPressed = false;
    });
  }

  void _changeAnimationState() {
    setState(() {
      _riveController = rive.OneShotAnimation(
        'ollie_DW',
        autoplay: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: _changeAnimationState,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: rive.RiveAnimation.asset(
                      'assets/rive/skater_dude.riv',
                      controllers: [_riveController],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Heading24Semibold(text: "Login"),
                            const SizedBox(height: 16),
                            InputBox(
                              placeholder: "Enter your email",
                              controller: _emailController,
                              obscureText: false,
                            ),
                            const SizedBox(height: 16),
                            InputBox(
                              placeholder: "Enter your password",
                              controller: _passwordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              onPressed: _login,
                              label: "Login",
                              isDisabled: isPressed,
                            ),
                            const SizedBox(height: 24),
                            LDivider(),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              onPressed: () {
                                // _changeAnimationState();

                                Navigator.of(context).push(
                                  RouteAnimation.BottomUpRoute(
                                    SignUp(),
                                  ),
                                );
                              },
                              customColor: Theme.of(context).colorScheme.scrim,
                              label: "Sign Up",
                              isDisabled: isPressed,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
