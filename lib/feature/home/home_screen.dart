import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Text("Welcome ${user.refreshToken}"),
      ),
    );
  }
}
