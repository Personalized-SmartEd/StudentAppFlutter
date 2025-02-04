import 'package:flutter/material.dart';
import 'package:smarted/feature/auth/auth_services.dart';

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
      authService.loginUser(
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
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                // initialValue: "email@gmail.com",
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                // initialValue: "password",
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
