import 'dart:convert';
import 'package:gap/gap.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otpwithanimation/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';  
import 'otp_screen.dart';

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  _MobileNumberScreenState createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _mobileController = TextEditingController();
  late AnimationController _arcController;
  late Animation<double> _arcAnimation;
  bool isInputFocused = false;
  bool isAnimating = false;
  bool isInputVisible = true;  

  

  final List<String> _images = [
    'https://www.shutterstock.com/shutterstock/photos/2468716257/display_1500/stock-vector-insurance-concept-illustration-a-male-insurance-agent-standing-with-crossed-legs-holding-an-2468716257.jpg',
    'https://cdn.pixabay.com/photo/2020/08/03/09/39/medical-5459631_1280.png',
    'https://img.freepik.com/premium-photo/design-has-been-done-occasion-national-doctors-day_1119325-8217.jpg?w=740',
    'https://img.freepik.com/free-vector/flat-world-health-day-celebration-illustration_23-2148885397.jpg?t=st=1733738046~exp=1733741646~hmac=38f0b619c67306c192be65547fcc67a0aced4571ff99e6e71a1a07bba69c4727&w=740',
  ];

  final List<String> _texts = [
    "Read patient's stories and book doctor appointments",
    "Get up to 25% on medicine",
    "1 crore Indians connect with doctors every year with Practo",
    "Video consult top doctors from the comfort of home",
  ];

  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _arcController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _arcAnimation =
        Tween<double>(begin: 0, end: 2 * pi).animate(_arcController)
          ..addListener(() {
            setState(() {});
          });
    _arcController.repeat();
    _pageController = PageController(viewportFraction: 1.0);

    _pageController.addListener(() {
      if (_pageController.page?.toInt() != _currentIndex) {
        setState(() {
          _currentIndex = _pageController.page?.toInt() ?? 0;
        });
      }
    });

    _mobileController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _arcController.dispose();
    _mobileController.dispose();
    _pageController.dispose();
    super.dispose();
  }

 void _onContinuePressed() async {
  final mobileNumber = _mobileController.text;
  if (mobileNumber.length != 10) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
    );
    return;
  }

  setState(() {
    isAnimating = true;
    isInputVisible = false;
  });

  try{
    final apiProvider = Provider.of<ApiProvider>(context,listen: false);
    final response = await apiProvider.sendOtp(mobileNumber);
    if(response)
    {
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context)=> OtpScreen(mobileNumber: mobileNumber, apiProvider:apiProvider)
         )
      
      );
      
    }
    else
    {
      _showErrorSnackBar("An error occured please try again");
    }


  }
  catch(e){
    _showErrorSnackBar("An error occured please try again");
  }
  finally{
    setState(() {
        isAnimating=false;

      });
  }
}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (isInputFocused)
          ? AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              actions: const [
                Row(
                  children: [
                    Icon(Icons.help_outline, color: Colors.black),
                    Gap(8),
                    Text(
                      "Help",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                Gap(16),
                  ],
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                isInputFocused = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Column(
                children: [
                  if (!isInputFocused)
                    Expanded(
                      flex: 7,
                      child: Container(
                        color: const Color.fromARGB(255, 27, 68, 165),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: _images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Gap(20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.network(
                                      _images[index],
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      width: MediaQuery.of(context).size.width * 0.7,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                  const Gap(20),
                                  Text(
                                    _texts[index],
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Gap(20),
                                  SmoothPageIndicator(
                                    controller: _pageController,
                                    count: _images.length,
                                    effect: const ScaleEffect(
                                      activeDotColor: Colors.white,
                                      dotColor: Colors.grey,
                                      dotHeight: 8.0,
                                      dotWidth: 8.0,
                                      spacing: 10.0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  Expanded(
                    flex: isInputFocused ? 10 : 3,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isInputFocused) const Gap(20) else const Gap(10),  
                          Text(
                            isInputFocused
                                ? "Enter your mobile number"
                                : "Let's get started! Enter your mobile number",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Gap(20),
                          Visibility(
                            visible: isInputVisible,
                            child: TextFormField(
                              controller: _mobileController,
                              autofocus: isInputFocused,
                              keyboardType: TextInputType.number,
                              cursorColor: Colors.black,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onTap: () {
                                setState(() {
                                  isInputFocused = true;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Mobile number',
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '+91',
                                        style: TextStyle(
                                            fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      Gap(30),
                                      SizedBox(width: 8),
                                      Text('|', style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const Gap(30),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: isInputFocused
                                ? const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "By Continuing, you agree to our",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Terms & Conditions",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
                                    "Trouble signing in?",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isAnimating)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: SizedBox(
                width: 50,
                height: 50,
                child: CustomPaint(
                  painter: ArcPainter(_arcAnimation.value),
                ),
              ),
            ),
          if (isInputFocused && isInputVisible)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: _mobileController.text.isNotEmpty ? _onContinuePressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _mobileController.text.isNotEmpty ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double angle;

  ArcPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, angle, pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
