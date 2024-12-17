import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:otpwithanimation/api/secrets.dart';

class ApiProvider with ChangeNotifier {
  Future<bool> sendOtp(String phoneNumber) async {
    final url = Uri.parse(ApiUrls.sendOtpUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone_number': phoneNumber}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(" failed to send otp");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
  
  Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    final url = Uri.parse(ApiUrls.verifyOtpUrl);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone_number': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body); 
      } else {
        throw Exception("Failed to verify OTP");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
  
}
