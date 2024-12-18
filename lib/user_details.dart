import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  List<Map<String, dynamic>> profiles = [];
  int profileCount = 0;
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _sexController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  
  Future<void> _fetchProfiles() async {
    final apiProvider = ApiProvider();
    final token = widget.accessToken;

    try {
      final response = await apiProvider.getProfiles(token);
      setState(() {
        profiles = List<Map<String, dynamic>>.from(response['profiles']);
        profileCount = response['profile_count'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profiles: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfiles(); 
  }

  
  Future<void> _createProfile() async {
    final name = _nameController.text;
    final age = _ageController.text;
    final sex = _sexController.text;
    final weight = _weightController.text;
    final height = _heightController.text;

    if (name.isEmpty || age.isEmpty || sex.isEmpty || weight.isEmpty || height.isEmpty) {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile created successfully')),
        );
        _fetchProfiles(); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create profile')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = widget.userDetails['id'];
    final phoneNumber = widget.userDetails['phone_number'];
    final createdAt = widget.userDetails['created_at'];
    final updatedAt = widget.userDetails['updated_at'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User ID: $userId', style: const TextStyle(fontSize: 18)),
            Text('Phone Number: $phoneNumber', style: const TextStyle(fontSize: 18)),
            Text('Created At: $createdAt', style: const TextStyle(fontSize: 18)),
            Text('Updated At: $updatedAt', style: const TextStyle(fontSize: 18)),
            const Gap(20),
            
            // Show profiles or create profile option
            Expanded(
              child: profileCount < 6
                  ? Column(
                      children: [
                        // Show all profiles and the 'Create Profile' button
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 columns
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: profiles.length,
                            itemBuilder: (context, index) {
                              final profile = profiles[index];
                              return GestureDetector(
                                onTap: () {
                                  // Handle profile click (if needed)
                                },
                                child: Card(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        child: Text(profile['name'][0], style: TextStyle(fontSize: 24)),
                                      ),
                                      Text(profile['name'], style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _createProfile,
                          child: const Text('Create Profile'),
                        ),
                      ],
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return GestureDetector(
                          onTap: () {
                            // Handle profile click (if needed)
                          },
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Colors.grey,
                                  child: Text(profile['name'][0], style: TextStyle(fontSize: 24)),
                                ),
                                Text(profile['name'], style: const TextStyle(fontSize: 16)),
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
