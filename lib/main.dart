import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/app.dart';
import 'package:smarted/feature/auth/provider/user.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
