import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/auth/user/user_profile.dart';
import 'package:smarted/feature/doubtbot/doubtbot.dart';
import 'package:smarted/feature/studyplan/studyplan_page.dart';
import 'package:smarted/feature/studyplan/studyplan_services.dart';
import 'package:smarted/feature/studyplan/studyplanprovider.dart';
import 'package:smarted/shared/typography/typography.dart';
import 'package:smarted/widgets/button/primary_button.dart';

import 'package:percent_indicator/percent_indicator.dart';
// import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    dynamic studyplan =
        Provider.of<StudyPlanProvider>(context, listen: true).studyplan;
    print(studyplan);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Heading24Semibold(
          text: "Welcome, ${user.Name}",
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => {
              Navigator.of(context)
                  .push(RouteAnimation.BottomUpRoute(UserProfile()))
            },
          ),
          const Gap(10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // School Info
            Body12Semibold(
                text: "School: ${user.SchoolName} (${user.SchoolCode})",
                style: Theme.of(context).textTheme.bodyLarge),
            const Gap(20),

            // Subjects Section
            Text("Your Subjects",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Gap(10),

            Column(
              children: user.Subjects.map<Widget>((subject) {
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.book,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text(subject,
                        style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Text(
                        "Pace: ${user.Pace} | Performance: ${user.PerformanceLvl}"),
                  ),
                );
              }).toList(),
            ),
            const Gap(20),
            // Study Plan Section
            Text("Your Study Plan",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Gap(10),

            // Placeholder for study plan content
            studyplan.isNotEmpty
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PrimaryButton(
                            onPressed: () => {
                                  Navigator.of(context).push(
                                      RouteAnimation.BottomUpRoute(
                                          StudyPlan(studyplan: studyplan)))
                                },
                            label: "See Daily Plan"),
                      ),
                      StudyAnalytics(studyplan: studyplan),
                    ],
                  )
                : Column(
                    children: [
                      Text("No study plan available",
                          style: TextStyle(color: Colors.grey)),
                      const Gap(10),
                      PrimaryButton(
                          isDisabled: isLoading,
                          onPressed: () => {
                                setState(() {
                                  isLoading = true;
                                }),
                                StudyPlanServices.getStudyPlan(
                                    context: context, weakAreas: ["math"]),
                                setState(() {
                                  isLoading = true;
                                })
                              },
                          label: "Generate Study Plan"),
                    ],
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(RouteAnimation.CornerUpRoute(Doubtbot()));
        },
        backgroundColor:
            Theme.of(context).primaryColor, // Matches the UI in the image
        icon: Icon(Icons.chat_bubble_outline, color: Colors.white),
        label: Text("Chat", style: TextStyle(color: Colors.white)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Creates pill-like shape
        ),
      ),
    );
  }
}

class StudyAnalytics extends StatefulWidget {
  final dynamic studyplan;

  const StudyAnalytics({super.key, required this.studyplan});
  @override
  State<StudyAnalytics> createState() => _StudyAnalyticsState();
}

class _StudyAnalyticsState extends State<StudyAnalytics> {
  @override
  Widget build(BuildContext context) {
    var studyResources = widget.studyplan["study_resources"] ?? [];
    var timeAllocation = widget.studyplan["time_allocation"] ?? {};
    var exercisePlan = widget.studyplan["exercise_plan"] ?? [];
    var expectedImprovement =
        widget.studyplan["progress_predictions"]["expected_improvement"] ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Study Analytics",
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const Gap(10),

        // Time Allocation Pie Chart
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: timeAllocation.entries
                  .map<PieChartSectionData>((entry) => PieChartSectionData(
                        color: _getColorForSubject(entry.key),
                        value: (entry.value as num).toDouble(),
                        title: entry.key,
                      ))
                  .toList(),
            ),
          ),
        ),
        const Gap(20),

        // Study Resources List
        Text("Recommended Study Resources",
            style: Theme.of(context).textTheme.titleMedium),
        const Gap(10),
        ...studyResources.map((resource) => _buildResourceCard(
              resource["source"],
              resource["type"],
              Icons.school,
              resource["link"],
            )),
        const Gap(20),

        // Progress Prediction
        Text("Expected Improvement",
            style: Theme.of(context).textTheme.titleMedium),
        const Gap(10),
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width - 50,
          lineHeight: 20,
          percent: (expectedImprovement / 100).clamp(0.0, 1.0),
          center: Text("+${expectedImprovement.toInt()}%"),
          progressColor: Colors.purple,
          backgroundColor: Colors.grey[300],
        ),
        const Gap(20),

        // Exercise Plan
        Text("Daily Exercises", style: Theme.of(context).textTheme.titleMedium),
        const Gap(10),
        ...exercisePlan.map((exercise) => _buildExerciseTile(exercise["target"],
            "${exercise["type"]} - ${exercise["difficulty"]}")),
      ],
    );
  }

  Widget _buildResourceCard(
      String source, String type, IconData icon, String link) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title:
            Text(source, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(type),
        trailing: const Icon(Icons.open_in_new, color: Colors.grey),
        onTap: () => print("Open $link"), // Implement actual link opening
      ),
    );
  }

  Widget _buildExerciseTile(String subject, String description) {
    return ListTile(
      leading: const Icon(Icons.fitness_center, color: Colors.green),
      title: Text(subject, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(description),
    );
  }

  Color _getColorForSubject(String subject) {
    final colors = {
      "English": Colors.blue,
      "Math": Colors.green,
      "Hindi": Colors.orange,
      "Science": Colors.red,
      "Social Science": Colors.purple,
    };
    return colors[subject] ?? Colors.grey;
  }
}
