import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'profile_detail_screen.dart';
import 'services/auth_provider.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;
  final String accessToken;
  final String refreshToken;

  const UserDetailsScreen({
    super.key,
    required this.userDetails,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> with WidgetsBindingObserver {
  List<Map<String, dynamic>> profiles = [];
  int profileCount = 0;
  bool isLoading = true;
  
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Future<void> _fetchProfiles() async {
    setState(() => isLoading = true);
    
    final apiProvider = ApiProvider();
    final token = widget.accessToken;

    try {
      final response = await apiProvider.getProfiles(token);
      if (mounted) {
        setState(() {
          profiles = List<Map<String, dynamic>>.from(response['profiles']);
          profileCount = response['profile_count'];
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching profiles: $e')),
        );
      }
    }
  }

  void _clearFormFields() {
    _nameController.clear();
    _ageController.clear();
    _sexController.clear();
    _weightController.clear();
    _heightController.clear();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchProfiles();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _ageController.dispose();
    _sexController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchProfiles();
    }
  }

  Future<void> _createProfile() async {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final sex = _sexController.text.trim();
    final weight = _weightController.text.trim();
    final height = _heightController.text.trim();

    if (name.isEmpty || age.isEmpty || sex.isEmpty || 
        weight.isEmpty || height.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    final apiProvider = ApiProvider();
    final token = widget.accessToken;

    try {
      bool success = await apiProvider.createProfile(
        name: name,
        age: age,
        sex: sex,
        weight: weight,
        height: height,
        token: token,
      );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile created successfully')),
          );
          Navigator.of(context).pop(); // Close the dialog
          _clearFormFields();
          _fetchProfiles(); // Reload the profiles
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create profile')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showProfileForm() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  textCapitalization: TextCapitalization.words,
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _sexController,
                  decoration: const InputDecoration(labelText: 'Sex'),
                  textCapitalization: TextCapitalization.words,
                ),
                TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _clearFormFields();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createProfile,
              child: const Text('Add Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneNumber = widget.userDetails['phone_number'];
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.05;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'User Details',
          style: TextStyle(
            color: const Color.fromARGB(255, 27, 68, 165),
            fontWeight: FontWeight.w700,
            fontSize: 26,

          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: $phoneNumber',
              style: const TextStyle(fontSize: 18, color: const Color.fromARGB(255, 27, 68, 165 ), fontWeight: FontWeight.w700),
            ),
            const Gap(20),
            Expanded(
              child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white)
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: profiles.length + (profileCount < 6 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == profiles.length && profileCount < 6) {
                        return GestureDetector(
                          onTap: _showProfileForm,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[600],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color:  Colors.white,
                                    size: 50,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Add Profile',
                                  style: TextStyle(fontSize: 16, color:const Color.fromARGB(255, 27, 68, 165),),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final profile = profiles[index];
                      return GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileDetailScreen(
                                profile: profile,
                                accessToken: widget.accessToken,
                              ),
                            ),
                          );
                          _fetchProfiles(); 
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                
                                decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    profile['name'][0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color:Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile['name'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color:  Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'profile_detail_screen.dart';
// import 'services/auth_provider.dart';

// class UserDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> userDetails;
//   final String accessToken;
//   final String refreshToken;

//   const UserDetailsScreen({
//     super.key,
//     required this.userDetails,
//     required this.accessToken,
//     required this.refreshToken,
//   });

//   @override
//   _UserDetailsScreenState createState() => _UserDetailsScreenState();
// }

// class _UserDetailsScreenState extends State<UserDetailsScreen> {
//   List<Map<String, dynamic>> profiles = [];
//   int profileCount = 0;
//   final _nameController = TextEditingController();
//   final _ageController = TextEditingController();
//   final _sexController = TextEditingController();
//   final _weightController = TextEditingController();
//   final _heightController = TextEditingController();

//   Future<void> _fetchProfiles() async {
//     final apiProvider = ApiProvider();
//     final token = widget.accessToken;

//     try {
//       final response = await apiProvider.getProfiles(token);
//       setState(() {
//         profiles = List<Map<String, dynamic>>.from(response['profiles']);
//         profileCount = response['profile_count'];
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching profiles: $e')),
//       );
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _fetchProfiles();
//   }

//     @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _nameController.dispose();
//     _ageController.dispose();
//     _sexController.dispose();
//     _weightController.dispose();
//     _heightController.dispose();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       _fetchProfiles();
//     }
//   }

//    Future<void> _navigateToProfileDetail(Map<String, dynamic> profile) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfileDetailScreen(
//           profile: profile,
//           accessToken: widget.accessToken,
//         ),
//       ),
//     );
//     // Reload data when returning from ProfileDetailScreen
//     _fetchProfiles();
//   }
//   Future<void> _createProfile() async {
//     final name = _nameController.text;
//     final age = _ageController.text;
//     final sex = _sexController.text;
//     final weight = _weightController.text;
//     final height = _heightController.text;

//     if (name.isEmpty ||
//         age.isEmpty ||
//         sex.isEmpty ||
//         weight.isEmpty ||
//         height.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill in all fields')),
//       );
//       return;
//     }

//     final apiProvider = ApiProvider();
//     final token = widget.accessToken;

//     try {
//       bool success = await apiProvider.createProfile(
//         name: name,
//         age: age,
//         sex: sex,
//         weight: weight,
//         height: height,
//         token: token,
//       );

//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile created successfully')),
//         );
//         _fetchProfiles();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to create profile')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   void _showProfileForm() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Create Profile'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//               ),
//               TextField(
//                 controller: _ageController,
//                 decoration: const InputDecoration(labelText: 'Age'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _sexController,
//                 decoration: const InputDecoration(labelText: 'Sex'),
//               ),
//               TextField(
//                 controller: _weightController,
//                 decoration: const InputDecoration(labelText: 'Weight'),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: _heightController,
//                 decoration: const InputDecoration(labelText: 'Height'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _createProfile();
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Add Now'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//   final userId = widget.userDetails['id'];
//   final phoneNumber = widget.userDetails['phone_number'];

//   final screenWidth = MediaQuery.of(context).size.width;
//   final screenHeight = MediaQuery.of(context).size.height;

//   final padding = screenWidth * 0.05;

//   return Scaffold(
//     backgroundColor: const Color.fromARGB(255, 27, 68, 165),
//     appBar: AppBar(
//       backgroundColor: const Color.fromARGB(255, 27, 68, 165),
//       title: const Text(
//         'User Details',
//         style: TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           fontSize: 24,
//         ),
//       ),
//     ),
//     body: Padding(
//       padding: EdgeInsets.all(padding),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('User ID: $phoneNumber',
//               style: const TextStyle(fontSize: 18, color: Colors.white)),
//           const Gap(20),
//           Expanded(
//             child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 4,
//                   mainAxisSpacing: 4,
//                   childAspectRatio: 1,
//                 ),
//                 itemCount: profiles.length + (profileCount < 6 ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index == profiles.length && profileCount < 6) {
//                     return GestureDetector(
//                       onTap: _showProfileForm,
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: 100,
//                               height: 100,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey[800],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: const Icon(
//                                 Icons.add,
//                                 color: Colors.white,
//                                 size: 50,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             const Text(
//                               'Add Profile',
//                               style: TextStyle(
//                                   fontSize: 16, color: Colors.white),
//                               textAlign: TextAlign.center,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }

//                   final profile = profiles[index];

//                   return GestureDetector(
//                     onTap: () {
                     
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ProfileDetailScreen(
//                             profile: profile,
//                             accessToken: widget.accessToken,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[800],
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Center(
//                               child: Text(
//                                 profile['name'][0],
//                                 style: const TextStyle(
//                                     fontSize: 40, color: Colors.white),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             profile['name'],
//                             style: const TextStyle(
//                                 fontSize: 16, color: Colors.white),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }),
//           ),
//         ],
//       ),
//     ),
//   );
// }
// }