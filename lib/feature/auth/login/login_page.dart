import 'package:flutter/material.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/widgets/button.dart';
import 'package:smarted/widgets/button/primary_button.dart';
import 'package:smarted/widgets/button/secondary_button.dart';
import 'package:smarted/widgets/inputbox.dart';
import 'package:rive/rive.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final AuthServices authService = AuthServices();
  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      AuthServices.loginUser(
        context: context,
        password: _passwordController.text,
        email: _emailController.text,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Set the initial value for the email
    _emailController.text = 'email@gmail.com';
    _passwordController.text = 'password';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                customColor: Colors.blue[300],
              ),
              RiveAnimation.asset(
                'assets/rive/cat_button.riv',
              )
            ],
          ),
        ),
      ),
    );
  }
}
