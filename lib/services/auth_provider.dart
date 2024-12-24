import 'dart:convert';
import 'dart:ui';
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

  Future<bool> createProfile({
    required String name,
    required String age,
    required String sex,
    required String weight,
    required String height,
    required String token,
  }) async {
    final url = Uri.parse(ApiUrls.CreateProfileUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'age': age,
          'sex': sex,
          'weight': weight,
          'height': height,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception('Failed to create profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<Map<String, dynamic>> getProfiles(String token) async {
    final url = Uri.parse(ApiUrls.profileUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch profiles');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Future<bool> deletProfile(String token, String profileId) async {
  //   final url = Uri.parse(ApiUrls.deleteProfile);

  //   try {
  //     final response = await http.delete(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({
  //         'profile_id': profileId,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       print(response.body);
  //       return true;
  //     } else {
  //       // throw Exception("Failed to delete the profile");
  //       return false;
  //     }
  //   } catch (e) {
  //     throw Exception("Error: $e");
  //   }
  // }

  Future<bool> deleteProfile({
    required String profileId,
    required String token,
  }
  ) async {
    final url = Uri.parse(ApiUrls.deleteProfile);

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'profile_id': profileId}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  //   Future<bool> updateProfile({
  //   required String profileId,
  //   required String name,
  //   required String token,
  // }) async {
  //   final url = Uri.parse(ApiUrls.updateProfileUrl.replaceFirst("{profileId}", profileId)); 

  //   try {
  //     final response = await http.put(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'name': name}),
  //     );

  //     if (response.statusCode == 200) {
  //       return true;
  //     } else {
  //       throw Exception("Failed to update profile");
  //     }
  //   } catch (e) {
  //     throw Exception("Error: $e");
  //   }
  // }

  
Future<bool> updateProfile({
    required String profileId,
    required String name,
    required int age,
    required String sex,
    required String token,
  }) async {
    final url = Uri.parse(ApiUrls.updateProfileUrl.replaceFirst("{profileId}", profileId));

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
        body: jsonEncode({
          'name': name,
          'age': age,
          'sex': sex,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception("Failed to update profile");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}
