import 'package:flutter/material.dart';
import 'package:otpwithanimation/Models/user_models.dart';  


class UserDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> userDetails;
  final String accessToken;
  final String refreshToken;


  UserDetailsScreen({
    required this.userDetails,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  Widget build(BuildContext context) {
    final userId = userDetails['id'];
    final phoneNumber = userDetails['phone_number'];
    final createdAt = userDetails['created_at'];
    final updatedAt = userDetails['updated_at'];

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: $userId', style: TextStyle(fontSize: 18)),
            Text('Phone Number: $phoneNumber', style: TextStyle(fontSize: 18)),
            Text('Created At: $createdAt', style: TextStyle(fontSize: 18)),
            Text('Updated At: $updatedAt', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Access Token: $accessToken', style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 10),
            
          ],
        ),
      ),
    );
  }
}