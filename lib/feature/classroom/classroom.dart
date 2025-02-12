import 'package:flutter/material.dart';

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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Classroom"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
        child: Icon(Icons.add),
      ),
    );
  }
}
