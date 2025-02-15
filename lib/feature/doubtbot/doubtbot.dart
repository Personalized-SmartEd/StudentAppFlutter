import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:smarted/core/route/routeAnimation.dart';
import 'package:smarted/feature/doubtbot/voicetalk.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/feature/auth/provider/user.dart';

class Doubtbot extends StatefulWidget {
  const Doubtbot({super.key});

  @override
  _DoubtbotState createState() => _DoubtbotState();
}

class _DoubtbotState extends State<Doubtbot> {
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  String _selectedSubject = "math";
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _showSubjectSelectionDialog());
  }

  Future<void> _showSubjectSelectionDialog() async {
    List<String> subjects = [
      'Science',
      'Math',
      'English',
      'Social Science',
      'Hindi'
    ];

    String? selected = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select a Subject"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: subjects.map((subject) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, subject.toLowerCase()),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      subject,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
    if (selected != null) {
      setState(() => _selectedSubject = selected);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  Future<void> _sendDoubt() async {
    if (_questionController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _messages.add({"role": "user", "text": _questionController.text});
    });

    var userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse('${Endpoints.baseURL}/doubt/ask'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.Token,
      },
      body: jsonEncode({
        'doubt': {
          'question': _questionController.text,
          'image_url':
              "https://miro.medium.com/v2/resize:fit:786/format:webp/1*OReJHtogeA62SmSwzNzgvw.png",
        },
        'subject': _selectedSubject
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _messages.add({
          "role": "bot",
          "text": data["explanation"],
          "keypoints": data["keypoints"]
        });
      });
    } else {
      setState(() {
        _messages.add({"role": "bot", "text": 'Failed to get response'});
      });
    }

    setState(() {
      _isLoading = false;
      _selectedImage = null;
    });
    _questionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Doubtbot"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildMessageBubble(_messages[index]),
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    bool isUser = message["role"] == "user";
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SelectableText(
          message["text"],
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.mic),
            onPressed: () {
              Navigator.push(
                context,
                RouteAnimation.BottomUpRoute(
                  VoiceChatPage(selectedSubject: _selectedSubject),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.photo),
            onPressed: _pickImage,
          ),
          if (_selectedImage != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.file(_selectedImage!,
                  height: 40, width: 40, fit: BoxFit.cover),
            ),
          Expanded(
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(
                labelText: "Ask a question...",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _isLoading ? null : _sendDoubt,
            child: _isLoading ? CircularProgressIndicator() : Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
