import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class UserDetailsScreen extends StatelessWidget {
  final String userId;
  final String userPhonenumber;
  
 
 const UserDetailsScreen({ 
  Key? key,
  required this.userId, 
  required this.userPhonenumber
  }) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(("user details"))
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User ID : $userId',
                style: const TextStyle(fontSize: 20),
              ),
              const Gap(10),
              Text(
                'Phone Number : $userPhonenumber',
                style: const TextStyle(fontSize: 20),
              ),
           ] ,
        ),
     ),
    );
  }    
}