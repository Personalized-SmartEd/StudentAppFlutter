import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/auth/login/login_page.dart';
import 'package:smarted/feature/auth/signup/signup_page.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage(
            title: "Is Traditional Learning Enough?",
            subtitle:
                "Every student learns differently, but classrooms often follow a one-size-fits-all approach. Many students struggle to keep up, while others aren’t challenged enough.",
            animation: "assets/animations/student.json",
            buttonText: "Next",
            onPressed: () => _pageController.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
          _buildPage(
            title: "Meet SmartEd - Your AI Learning Companion",
            subtitle:
                "\u2022 Personalized Learning Paths: A quick assessment helps us tailor lessons to your style.\n\u2022 AI-Powered Insights: Detects patterns to identify learning strengths and areas needing support.\n\u2022 Engaging & Adaptive: Interactive quizzes, tutor bot, and real-time assistance.",
            animation: "assets/animations/learning.json",
            buttonText: "Get Started",
            onPressed: () {
              Navigator.push(context, RouteAnimation.BottomUpRoute(Login()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required String animation,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(animation, height: 300),
          SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
