import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/home/page/home_page.dart';
import 'package:smarted/feature/quiz/assessment_services.dart';
import 'package:smarted/feature/quiz/assestment_quiz_page.dart';
import 'package:smarted/feature/quiz/quiz_page.dart';

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
    'Settings',
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.emoji_events,
    Icons.bookmark,
    Icons.settings,
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
        return HomePage();
      case "Classrooms":
        return HomePage();
      case "Settings":
        return HomePage();
      default:
        return HomePage();
    }
    // return Container();
  }

  @override
  void initState() {
    super.initState();
    // AuthServices.logout(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var user = Provider.of<UserProvider>(context, listen: false);
      print("assessment");

      print(jsonEncode(user.user));
      if (user.user.LearningStyle == "") {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AssestmentQuiz()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Home"),
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         AuthServices.logout(context);
      //       },
      //       icon: const Icon(Icons.logout),
      //     )
      //   ],
      // ),
      body: _getBody(_labels[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
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
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icons[index],
                  color: isSelected ? Colors.orange : Colors.grey,
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
