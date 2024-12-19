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
        Navigator.of(context).pop(); 
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

  void _openProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _sexController,
                  decoration: const InputDecoration(labelText: 'Sex (M/F)'),
                ),
                TextField(
                  controller: _weightController,
                  decoration: const InputDecoration(labelText: 'Weight'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _heightController,
                  decoration: const InputDecoration(labelText: 'Height'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
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
    final userId = widget.userDetails['id'];
    final phoneNumber = widget.userDetails['phone_number'];

    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        backgroundColor: Colors.black, 
        title: const Text(
          'User Details',
          style: TextStyle(
            color: Colors.red, 
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Text('Phone Number: $phoneNumber', style: const TextStyle(fontSize: 18, color: Colors.white)),
            const Gap(20),

            
            Expanded(
              child: Column(
                children: [
                  if (profileCount < 6) 
                    GestureDetector(
                      onTap: _openProfileDialog,
                      child: Container(
                        width: 60, 
                        height: 60, 
                        decoration: BoxDecoration(
                          color: Colors.grey[800], 
                          borderRadius: BorderRadius.circular(8), 
                        ),
                        child: const Center(
                          child:  Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  const Gap(20),

                 
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: profiles.length,
                      itemBuilder: (context, index) {
                        final profile = profiles[index];
                        return GestureDetector(
                          onTap: () {
                            
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 60, 
                                height: 60, 
                                decoration: BoxDecoration(
                                  color: Colors.grey[800], 
                                  borderRadius: BorderRadius.circular(8), 
                                ),
                                child: Center(
                                  child: Text(
                                    profile['name'][0], 
                                    style: const TextStyle(fontSize: 24, color: Colors.white),
                                  ),
                                ),
                              ),
                              Gap(5),
                              Text(
                                profile['name'],
                                style: const TextStyle(fontSize: 16, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
