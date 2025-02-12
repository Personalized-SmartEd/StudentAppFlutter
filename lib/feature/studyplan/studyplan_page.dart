import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyPlan extends StatefulWidget {
  final dynamic studyplan;

  const StudyPlan({super.key, required this.studyplan});

  @override
  State<StudyPlan> createState() => _StudyPlanState();
}

class _StudyPlanState extends State<StudyPlan> {
  int _selectedDayIndex = 0;

  @override
  Widget build(BuildContext context) {
    var days = widget.studyplan['weekly_schedule'];
    var selectedDay = days[_selectedDayIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Plan"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Top Navigation Bar
          Container(
            height: 60,
            color: Colors.blueAccent,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                    decoration: BoxDecoration(
                      color: _selectedDayIndex == index
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      days[index]['day'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _selectedDayIndex == index
                            ? Colors.blueAccent
                            : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Study Plan Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subjects:",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        children:
                            selectedDay['subjects'].map<Widget>((subject) {
                          return Chip(
                            avatar: Icon(
                              subject == 'maths' ? Icons.calculate : Icons.book,
                              size: 18,
                              color: Colors.white,
                            ),
                            label: Text(subject.toUpperCase()),
                            backgroundColor: subject == 'maths'
                                ? Colors.orange
                                : Colors.green,
                            labelStyle: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Activities:",
                        style: GoogleFonts.poppins(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ...selectedDay['activities'].map<Widget>((activity) {
                        return ListTile(
                          leading: Icon(Icons.star, color: Colors.yellow[700]),
                          title: Text(activity,
                              style: GoogleFonts.poppins(fontSize: 16)),
                        );
                      }).toList(),
                      SizedBox(height: 10),
                      Text(
                        "Study Duration: ${selectedDay['duration']} hours",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
