import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'user_details.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  OtpScreen({required this.mobileNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();

  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();
  final FocusNode _focusNode4 = FocusNode();
  final FocusNode _focusNode5 = FocusNode();
  final FocusNode _focusNode6 = FocusNode();

  late AnimationController _controller;
  bool isAnimating = false;
  bool isContinueButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode1.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _otpController1.dispose();
    _otpController2.dispose();
    _otpController3.dispose();
    _otpController4.dispose();
    _otpController5.dispose();
    _otpController6.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    _focusNode6.dispose();
    super.dispose();
  }

  Widget _buildOtpTextField(
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
  ) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocusNode != null) {
            nextFocusNode.requestFocus();
          }
        },
      ),
    );
  }

   void _verifyOtp() async {

  setState(() {
    isAnimating = true;
    isContinueButtonVisible = false;
  });
  _controller.repeat();

  String enteredOtp = _otpController1.text +
      _otpController2.text +
      _otpController3.text +
      _otpController4.text +
      _otpController5.text +
      _otpController6.text;


  print("otp is : $enteredOtp ");
  print(widget.mobileNumber);
  final url = Uri.parse('http://192.168.0.178:7000/authentication/verify-otp/');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'phone_number': widget.mobileNumber,
      'otp': enteredOtp,
    }),
  );

  if (response.statusCode == 200) {
  
    _controller.stop();
    setState(() {
      isAnimating = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserDetailsScreen(userId: 'userID', userPhonenumber: 'phoneNumber',)),
    );
  } else {
  
    _controller.stop();
    setState(() {
      isAnimating = false;
      isContinueButtonVisible = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
    const  SnackBar(content: Text("Invalid OTP. Please try again.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(Icons.help_outline, color: Colors.black),
                SizedBox(width: 5),
                Text(
                  "Help",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(40),
            const Text(
              'Enter the 6-digit OTP sent to',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const Gap(8),
            Text(
              widget.mobileNumber,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOtpTextField(_otpController1, _focusNode1, _focusNode2),
                _buildOtpTextField(_otpController2, _focusNode2, _focusNode3),
                _buildOtpTextField(_otpController3, _focusNode3, _focusNode4),
                _buildOtpTextField(_otpController4, _focusNode4, _focusNode5),
                _buildOtpTextField(_otpController5, _focusNode5, _focusNode6),
                _buildOtpTextField(_otpController6, _focusNode6, null),
              ],
            ),
            const Gap(20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  print("Resend OTP clicked");
                },
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                ),
              ),
            ),
            if (isAnimating)
            const Center(
                child: CircularProgressIndicator(),
              ),
            const Spacer(),
            if (isContinueButtonVisible)
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            const Gap(20),
          ],
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const  Scaffold(
      body: Center(
        child: Text(
          "OTP Verified Successfully!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
