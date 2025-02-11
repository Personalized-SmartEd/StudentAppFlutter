import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/studyplan/studyplan_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserProvider>(context, listen: false);
    print(user.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
                onPressed: () => {AuthServices.logout(context)},
                icon: Icon(Icons.logout_outlined))
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StudyPlan()))
              },
              child: Text("Get Study Plan"),
            ),
            Gap(20),
          ],
        ));
  }
}
