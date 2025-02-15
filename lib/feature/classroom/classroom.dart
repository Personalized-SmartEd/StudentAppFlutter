import 'package:flutter/material.dart';
import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/doubtbot/doubtbot.dart';

class Classroom extends StatefulWidget {
  const Classroom({super.key});

  @override
  State<Classroom> createState() => _ClassroomState();
}

class _ClassroomState extends State<Classroom> {
  String classroomid = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classroom"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController _controller = TextEditingController();
                    return AlertDialog(
                      title: Text("Enter Classroom ID"),
                      content: TextField(
                        controller: _controller,
                        decoration: InputDecoration(hintText: "Classroom ID"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            String classroomId = _controller.text;
                            setState(() {
                              classroomid = classroomId;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.add_circle_outline),
              tooltip: 'Add Classroom',
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Classroom"),
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
