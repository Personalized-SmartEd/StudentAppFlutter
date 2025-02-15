import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/auth/auth_services.dart';

import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/classroom/classroom.dart';
import 'package:smarted/feature/doubtbot/doubtbot.dart';
import 'package:smarted/feature/home/page/home_page.dart';
import 'package:smarted/feature/quiz/assestment_quiz_page.dart';
import 'package:smarted/feature/quiz/subject_quiz.dart';
import 'package:smarted/feature/studyplan/studyplanprovider.dart';
import 'package:smarted/feature/tutorbot/tutorbot.dart';
import 'package:smarted/shared/theme/theme.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<String> _labels = [
    'Home',
    'Quiz',
    'Classrooms',
    'TutorBot',
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.emoji_events,
    Icons.bookmark,
    Icons.boy_outlined,
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody(String label) {
    switch (label) {
      case "Home":
        return HomePage();
      case "Quiz":
        return SubjectQuizPage();
      case "Classrooms":
        return Classroom();
      case "TutorBot":
        return Tutorbot();
      default:
        return HomePage();
    }
  }

  @override
  void initState() {
    // AuthServices.logout(context);
    Provider.of<StudyPlanProvider>(context, listen: false).loadStudyPlan();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = Provider.of<UserProvider>(context, listen: false);
      print(user.user.id);
      print("assessment");

      print(jsonEncode(user.user));
      if (user.user.LearningStyle == "") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AssessmentQuiz()),
          (route) => false,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(_labels[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurface,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: List.generate(_labels.length, (index) {
            final isSelected = _selectedIndex == index;

            return BottomNavigationBarItem(
              icon: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(isSelected ? 12 : 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icons[index],
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                  size: isSelected ? 28 : 24,
                ),
              ),
              label: _labels[index],
            );
          }),
        ),
      ),
    );
  }
}
