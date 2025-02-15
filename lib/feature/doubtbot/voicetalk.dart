import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:smarted/core/network/endpoints.dart';
import 'package:smarted/feature/auth/provider/user.dart';

class VoiceChatPage extends StatefulWidget {
  String selectedSubject;
  VoiceChatPage({required this.selectedSubject});
  @override
  _VoiceChatPageState createState() => _VoiceChatPageState();
}

class _VoiceChatPageState extends State<VoiceChatPage> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  bool _isSpeaking = false;
  bool _isLoading = false;
  String _spokenText = "";
  late RiveAnimationController _riveController;

  @override
  void initState() {
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
    _flutterTts.setVolume(1.0);
    _flutterTts.setPitch(1.0);
    _flutterTts.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
      _setRiveAnimation("wave");
    });
    _riveController = SimpleAnimation("wave");
    super.initState();
  }

  void _setRiveAnimation(String state) {
    setState(() {
      _riveController.isActive = false;
      _riveController = SimpleAnimation(state);
    });
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _setRiveAnimation("hands_hear_start");
      _speech.listen(onResult: (result) {
        setState(() => _spokenText = result.recognizedWords);
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
    if (_spokenText.isNotEmpty) {
      _sendVoiceQuery(_spokenText);
    }
  }

  Future<void> _sendVoiceQuery(String query) async {
    if (query.isEmpty) return;
    setState(() => _isLoading = true);
    _setRiveAnimation("hands_down");

    var userProvider = Provider.of<UserProvider>(context, listen: false);
    final response = await http.post(
      Uri.parse('${Endpoints.baseURL}/doubt/ask'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userProvider.user.Token,
      },
      body: jsonEncode({
        'doubt': {
          'question': query,
          'image_url':
              'https://miro.medium.com/v2/resize:fit:786/format:webp/1*OReJHtogeA62SmSwzNzgvw.png',
          'image_description':
              'Imagine you have two apples in one hand and then you get two more apples in the other hand. If you put all the apples together, how many apples do you have? You would have four apples! So, 2 + 2 = 4. It\'s like counting on your fingers!'
        },
        'subject': widget.selectedSubject
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String botResponse = data["explanation"] ?? "I didn't understand that.";
      _speak(botResponse);
    }

    setState(() => _isLoading = false);
  }

  void _speak(String text) async {
    setState(() => _isSpeaking = true);
    _setRiveAnimation("Talk");
    await _flutterTts.speak(text);
  }

  void _stopSpeaking() async {
    await _flutterTts.stop();
    setState(() => _isSpeaking = false);
    setState(() {
      _spokenText = "";
    });
    _setRiveAnimation("success");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isListening) {
          _stopListening();
        } else {
          _stopSpeaking();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Voice Chat")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: RiveAnimation.asset(
                  'assets/rive/talker.riv',
                  controllers: [_riveController],
                ),
              ),
              SizedBox(height: 20),
              Text(
                _spokenText.isEmpty ? "Start speaking" : _spokenText,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _isListening
                  ? CircularProgressIndicator()
                  : FloatingActionButton(
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                      child: Icon(_isListening ? Icons.stop : Icons.mic),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
