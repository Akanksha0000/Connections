
import 'package:flutter/material.dart';
import 'services/auth_provider.dart';

class ProfileDetailScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  final String accessToken;

  const ProfileDetailScreen({
    super.key,
    required this.profile,
    required this.accessToken,
  });

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  bool _isEditMode = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.profile['name'];
    _ageController.text = widget.profile['age'].toString();
    _sexController.text = widget.profile['sex'];
  }

  void _saveProfile() async {
    final apiProvider = ApiProvider();
    final success = await apiProvider.updateProfile(
      profileId: widget.profile['id'],
      name: _nameController.text,
      age: int.parse(_ageController.text),
      sex: _sexController.text,
      token: widget.accessToken,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      
      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

void _deleteProfile() async {
    final apiProvider = ApiProvider();
    final success = await apiProvider.deleteProfile(
      profileId: widget.profile['id'],
      token: widget.accessToken,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile deleted successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete profile')),
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[600],
        elevation: 0,
        title: const Text(
          'Profile Details',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                _toggleEditMode();
              } else if (value == 'delete') {
                _deleteProfile();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'edit', 'delete'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon:const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.blue[600],
              height: MediaQuery.of(context).size.height * 0.15,
              child: Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      child: Text(
                        profile['name'][0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildProfileField('Profile Id', profile['id'].toString(), false),
            _buildProfileField('Full Name', profile['name'], true, _nameController),
            _buildProfileField('Age', profile['age'].toString(), true, _ageController),
            _buildProfileField('Sex', profile['sex'], true, _sexController),
            if (_isEditMode) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _saveProfile, 
                  child: const Text('Save'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    String value,
    bool isEditable,
    [TextEditingController? controller]
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        subtitle: isEditable
            ? TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: value,
                  border: InputBorder.none,
                ),
                enabled: _isEditMode,
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
        trailing: isEditable && _isEditMode
            ? Icon(Icons.edit, color: Colors.grey[400], size: 20)
            : null,
      ),
    );
  }
}
