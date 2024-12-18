import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_details.dart';
import 'package:otpwithanimation/services/auth_provider.dart'; 

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OTP Verification',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApiProvider()),
        ],
        child: const UserDetailsScreen(
          
          userDetails: {
            "id": "7e5bf057-feb1-4e8d-be26-707f7dce6d69",
            "phone_number": "8830986464",
            "created_at": "2024-12-13T07:31:48.901818Z",
            "updated_at": "2024-12-13T07:31:48.901831Z"
          },
          accessToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM0NTI0MDQ4LCJpYXQiOjE3MzQ1MjA0NDgsImp0aSI6ImNlZmQ3ZTViNDVjNTRhNjI5ZWFlZGJhNGZmMGYyMmRmIiwidXNlcl9pZCI6IjdlNWJmMDU3LWZlYjEtNGU4ZC1iZTI2LTcwN2Y3ZGNlNmQ2OSJ9.H4lYc1EPkcHN1cojWOGX8Rs8a89WRwmZSpj3Yv3dwx8 ",
           refreshToken: '',
         // refreshToken:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzM0NTA0NzQ4LCJpYXQiOjE3MzQ1MDExNDgsImp0aSI6IjBlYTJkY2U1Yzk1ZDQ0ZWU4MzNjZWQ2NTA4ODE4NDUyIiwidXNlcl9pZCI6IjdlNWJmMDU3LWZlYjEtNGU4ZC1iZTI2LTcwN2Y3ZGNlNmQ2OSJ9.lcDga5B6CrDgUJOMki5KjTY55fB7dfhpBnJHBNlChmg",
        ),
      ),
    );
  }
}