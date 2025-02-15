import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarted/feature/auth/provider/user.dart';
import 'package:smarted/feature/auth/auth_services.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    var user = userProvider.getUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          ElevatedButton(
            onPressed: () {
              AuthServices.logout(context);
            },
            child: Text('Logout'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user.Image),
            ),
            SizedBox(height: 16),
            Text('Name: ${user.Name}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Email: ${user.Email}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Age: ${user.Age}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('School: ${user.SchoolName}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Class: ${user.ClassNumber}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Performance: ${user.Performance}',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
