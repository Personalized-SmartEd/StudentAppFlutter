import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/studyplan/studyplan_page.dart';
import 'package:smarted/feature/studyplan/studyplan_services.dart';

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
            StudyPlanScreen(),
            Gap(20),
          ],
        ));
  }
}

class StudyPlanScreen extends StatefulWidget {
  @override
  _StudyPlanScreenState createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  String? learningStyle;
  String? currentLevel;
  List<String> weakAreas = [];
  String? preferredPace;
  int availableHours = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Choose Learning Style",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: learningStyle,
                    isExpanded: true,
                    items: ["Visual", "Auditory", "Kinesthetic"].map((style) {
                      return DropdownMenuItem(
                        value: style.toLowerCase(),
                        child: Text(style),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        learningStyle = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Gap(10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Select Weak Areas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 10,
                    children: ["Maths", "English", "Science"].map((subject) {
                      return ChoiceChip(
                        label: Text(subject),
                        selected: weakAreas.contains(subject.toLowerCase()),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              weakAreas.add(subject.toLowerCase());
                            } else {
                              weakAreas.remove(subject.toLowerCase());
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Gap(10),
          ElevatedButton(
            onPressed: () {
              StudyPlanServices.getStudyPlan(
                context: context,
                learningStyle: learningStyle,
                weakAreas: weakAreas,
                availableHours: availableHours,
              );
            },
            child: Text("Get Study Plan"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
          ),
        ],
      ),
    );
  }
}
