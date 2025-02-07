import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/model/user.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/quiz/assessment_services.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {
              AuthServices.logout(context);
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: Text("Welcome ${user.refreshToken}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AssessmentServices.getAssessment(context);
        },
        child: const Icon(Icons.assessment),
      ),
    );
  }
}
