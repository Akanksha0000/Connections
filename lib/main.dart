import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'mobile_number_screen.dart'; 
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
        child: MobileNumberScreen(),
      ),
    );
  }
}
