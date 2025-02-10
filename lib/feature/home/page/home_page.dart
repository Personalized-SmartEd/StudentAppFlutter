import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:smarted/feature/studyplan/studyplan_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
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
