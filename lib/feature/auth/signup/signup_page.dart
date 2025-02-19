import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:smarted/feature/auth/auth_services.dart';
import 'package:smarted/shared/typography/heading_24_semibold.dart';
import 'package:smarted/widgets/button/primary_button.dart';
import 'package:smarted/widgets/inputbox.dart';
import 'package:smarted/widgets/snackbar.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _nameController = TextEditingController();
  final _schoolNameController = TextEditingController();
  final _schoolCodeController = TextEditingController();
  final _classController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  int tag = 3;

  List<String> options = [
    'science',
    'math',
    'english',
    'social-science',
    'hindi',
  ];

  List<String> tags = ['science'];
  final usersMemoizer = C2ChoiceMemoizer<String>();
  List<String> formValue = [];
  List<String> subjects = [];
  bool isPressed = false;
  var image;
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              Navigator.of(context).pop();

              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
    _ageController.text = '';
    _nameController.text = '';
    _schoolNameController.text = '';
    _schoolCodeController.text = '';
    _classController.text = '';
  }

  Future<void> _Signup() async {
    setState(() {
      isPressed = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      print('Age: ${_ageController.text}');
      print('Name: ${_nameController.text}');
      print('School Name: ${_schoolNameController.text}');
      print('School Code: ${_schoolCodeController.text}');
      print('Class: ${_classController.text}');
      print('Subjects: $tags');
      print('Image: $image');
    }
    if (image == null) {
      showSnackBar(context, "please select an Image");
      setState(() {
        isPressed = false;
      });
      return;
    }
    await AuthServices.signupUser(
      Age: _ageController.text,
      context: context,
      Password: _passwordController.text,
      Email: _emailController.text,
      Name: _nameController.text,
      SchoolName: _schoolNameController.text,
      SchoolCode: _schoolCodeController.text,
      Image: image,
      Subjects: tags,
      Class: _classController.text,
    );
    setState(() {
      isPressed = false;
    });
  }

  void submit() {
    print(tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Heading24Semibold(text: "Signup"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputBox(
                      placeholder: "example@gmail.com",
                      controller: _emailController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      placeholder: "********",
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      placeholder: "Name",
                      controller: _nameController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      placeholder: "15",
                      controller: _ageController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      placeholder: "School Name",
                      controller: _schoolNameController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      placeholder: "School Code",
                      controller: _schoolCodeController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    InputBox(
                      placeholder: "Class",
                      controller: _classController,
                      obscureText: false,
                    ),
                    const SizedBox(height: 24),
                    ChipsChoice<String>.multiple(
                      value: tags,
                      onChanged: (val) => setState(() => tags = val),
                      choiceItems: C2Choice.listFrom<String, String>(
                        source: options,
                        value: (i, v) => v,
                        label: (i, v) => v,
                        tooltip: (i, v) => v,
                      ),
                      choiceCheckmark: true,
                      choiceStyle: C2ChipStyle.outlined(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: showOptions,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.image,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          TextButton(
                                            child: Text('Select Image'),
                                            onPressed: showOptions,
                                          ),
                                          Center(
                                            child: image == null
                                                ? Text('No Image selected')
                                                : Image.file(
                                                    image,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.5,
                                                  ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("add image of your "),
                                          Text(
                                            "school ID",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                    PrimaryButton(
                      onPressed: _Signup,
                      label: "Signup",
                      customColor: Theme.of(context).colorScheme.primary,
                      isDisabled: isPressed,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
