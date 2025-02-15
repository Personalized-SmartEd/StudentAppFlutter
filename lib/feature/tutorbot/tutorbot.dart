import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/shared/constants/color.constants.dart';
import 'package:smarted/shared/text_styles/text_styles.dart';

class Tutorbot extends StatefulWidget {
  const Tutorbot({super.key});

  @override
  State<Tutorbot> createState() => _TutorbotState();
}

class _TutorbotState extends State<Tutorbot> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _chapterController = TextEditingController();
  final TextEditingController _topicController = TextEditingController();
  String? _selectedSubject;
  List<Map<String, String>> chatHistory = [];
  List<String> followUpQuestions = [];
  List<String> keyPoints = [];

  List<String> subjects = [
    'science',
    'math',
    'english',
    'social-science',
    'hindi',
  ];

  void _startNewSession() {
    setState(() {
      _selectedSubject = null;
      _chapterController.clear();
      _topicController.clear();
      chatHistory.clear();
      followUpQuestions.clear();
      keyPoints.clear();
    });
  }

  Future<void> sendMessage([String? predefinedMessage]) async {
    String message = predefinedMessage ?? _messageController.text;
    if (message.isEmpty ||
        _selectedSubject == null ||
        _chapterController.text.isEmpty ||
        _topicController.text.isEmpty) return;

    setState(() => chatHistory.add({"sender": "student", "content": message}));

    var requestBody = jsonEncode({
      "subject": {
        "subject": _selectedSubject,
        "chapter": _chapterController.text,
        "topic_description": _topicController.text
      },
      "new_message": message
    });
    var userprov = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('${Endpoints.baseURL}/tutor/session'),
        headers: {
          'Content-Type': 'application/json',
          "token": userprov.user.Token
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          chatHistory.add(
              {"sender": "tutor-bot", "content": responseData["explanation"]});
          followUpQuestions =
              List<String>.from(responseData["follow_up_questions"] ?? []);
          keyPoints = List<String>.from(responseData["key_points"] ?? []);
        });
      } else {
        _handleError(message);
      }
    } catch (e) {
      _handleError(message);
    }

    _messageController.clear();
  }

  void _handleError(String message) {
    setState(() => chatHistory.add({
          "sender": "tutor-bot",
          "content": "Failed to connect.",
          "retry": message
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tutor Bot", style: GoogleFonts.poppins()),
        backgroundColor: ColorConstants.primary,
        actions: [
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: _startNewSession)
        ],
      ),
      body: (_selectedSubject == null ||
              _chapterController.text.isEmpty ||
              _topicController.text.isEmpty)
          ? _buildSubjectSelection()
          : _buildChatInterface(),
    );
  }

  Widget _buildChatInterface() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: chatHistory.length,
            itemBuilder: (context, index) {
              bool isStudent = chatHistory[index]["sender"] == "student";
              return Align(
                alignment:
                    isStudent ? Alignment.centerRight : Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isStudent
                            ? ColorConstants.primary.withOpacity(0.8)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        chatHistory[index]["content"]!,
                      ),
                    ),
                    if (chatHistory[index].containsKey("retry"))
                      TextButton(
                        onPressed: () {
                          _messageController.text =
                              chatHistory[index]["retry"]!;
                          sendMessage();
                        },
                        child:
                            Text("Retry", style: TextStyle(color: Colors.red)),
                      ),
                    if (keyPoints.isNotEmpty && index == chatHistory.length - 1)
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Key Points:",
                                style: Theme.of(context).textTheme.bodyLarge),
                            ...keyPoints.map((point) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Text("• $point",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                )),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (followUpQuestions.isNotEmpty)
          Text(
            "Follow Up Questions",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
            textAlign: TextAlign.left,
          ),
        Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: followUpQuestions.map((question) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ActionChip(
                    label:
                        Text(question, style: TextStyle(color: Colors.white)),
                    backgroundColor: ColorConstants.primary,
                    onPressed: () => sendMessage(question),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child:
                      _buildTextField(_messageController, "Ask a question...")),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: ColorConstants.primary,
                child: IconButton(
                  icon: Icon(Icons.send, color: Colors.white),
                  onPressed: () => sendMessage(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectSelection() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Select a Subject",
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: subjects.map((subject) {
              return ChoiceChip(
                label:
                    Text(subject, style: Theme.of(context).textTheme.bodyLarge),
                selected: _selectedSubject == subject,
                onSelected: (selected) =>
                    setState(() => _selectedSubject = subject),
                selectedColor: ColorConstants.primary.withOpacity(0.8),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          _buildTextField(_chapterController, "Enter chapter"),
          SizedBox(height: 10),
          _buildTextField(_topicController, "Enter topic"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_selectedSubject != null &&
                  _chapterController.text.isNotEmpty &&
                  _topicController.text.isNotEmpty) {
                setState(() {});
              }
            },
            child: Text("Start Session"),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: ColorConstants.primary)),
      ),
    );
  }
}
