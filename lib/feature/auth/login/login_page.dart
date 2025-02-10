import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/signup/signup_page.dart';
import 'package:smarted/shared/typography/heading_24_semibold.dart';
import 'package:smarted/widgets/button/primary_button.dart';
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
  late RiveAnimationController _riveController;

  @override
  void initState() {
    super.initState();
    _emailController.text = 'ee@gmail.com';
    _passwordController.text = 'password';
    _riveController = OneShotAnimation(
      'isPressed',
      autoplay: true,
    );
  }

  Future<void> _login() async {
    setState(() {
      isPressed = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
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

  void _onIconTapped() {
    setState(() {
      _riveController.isActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Heading24Semibold(text: "Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _onIconTapped,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: RiveAnimation.asset(
                    'assets/rive/bounce-button.riv',
                    controllers: [_riveController],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputBox(
                      label: "Email",
                      placeholder: "example@gmail.com",
                      controller: _emailController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      label: "Password",
                      placeholder: "********",
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      onPressed: _login,
                      label: "Login",
                      customColor: Theme.of(context).colorScheme.primary,
                      isDisabled: isPressed,
                    ),
                    const SizedBox(height: 24),
                    LDivider(),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      label: "Sign Up",
                      customColor: Theme.of(context).colorScheme.secondary,
                      isDisabled: isPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
