import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userId = Supabase.instance.client.auth.currentUser?.id ?? 'N/A';
  Map<String, dynamic>? userProfile;
  bool _loading = true;
  bool _editMode = false;
  bool _saving = false;
  late TextEditingController _nicknameController;
  late TextEditingController _fullnameController;
  late TextEditingController _companyController;
  String? _error;
  String? _profilePicUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    debugPrint('ProfileScreen: initState');
    _nicknameController = TextEditingController();
    _fullnameController = TextEditingController();
    _companyController = TextEditingController();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    debugPrint('ProfileScreen: dispose');
    _nicknameController.dispose();
    _fullnameController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    debugPrint(
      'ProfileScreen: _fetchUserProfile called for userId: '
      '[32m$userId[0m',
    );
    if (userId == 'N/A') return;
    try {
      final response =
          await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', userId)
              .single();
      setState(() {
        _nicknameController.text = response['nickname'] ?? '';
        _fullnameController.text = response['full_name'] ?? '';
        _companyController.text = response['company'] ?? '';
        _profilePicUrl = response['profile_pic_url'];
      });
      debugPrint('ProfileScreen: _fetchUserProfile response: $response');
      setState(() {
        userProfile = response;
        _loading = false;
        if (userProfile != null) {
          _nicknameController.text = userProfile!['nickname'] ?? '';
          _fullnameController.text = userProfile!['full_name'] ?? '';
          _companyController.text = userProfile!['company'] ?? '';
        }
      });
    } catch (e) {
      debugPrint('ProfileScreen: _fetchUserProfile error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    debugPrint('ProfileScreen: _saveProfile called');
    setState(() {
      _saving = true;
      _error = null;
    });
    final updates = {
      'nickname': _nicknameController.text.trim(),
      'full_name': _fullnameController.text.trim(),
      'company': _companyController.text.trim(),
    };
    debugPrint('ProfileScreen: _saveProfile updates: $updates');
    try {
      await Supabase.instance.client
          .from('users')
          .update(updates)
          .eq('id', userId);
      debugPrint('ProfileScreen: _saveProfile update success');
      await _fetchUserProfile();
      setState(() {
        _editMode = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      debugPrint('ProfileScreen: _saveProfile error: $e');
      setState(() {
        _error = 'Failed to update profile.';
      });
    } finally {
      setState(() {
        _saving = false;
      });
      debugPrint('ProfileScreen: _saveProfile finished');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (picked == null) return;

    setState(() => _pickedImage = File(picked.path));

    final fileExt = picked.path.split('.').last;
    final fileName =
        'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final storagePath = 'profile_pics/$fileName';

    final bytes = await picked.readAsBytes();

    try {
      final response = await Supabase.instance.client.storage
          .from('profile-pic-url')
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // If uploadBinary returns a String, it's the file path. If it throws, it's an error.
      final publicUrl = Supabase.instance.client.storage
          .from('profile-pic-url')
          .getPublicUrl(storagePath);

      setState(() {
        _profilePicUrl = publicUrl;
      });

      // Save URL to user profile
      await Supabase.instance.client
          .from('users')
          .update({'profile_pic_url': publicUrl})
          .eq('id', userId);
      await _fetchUserProfile();
    } catch (e) {
      debugPrint("Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upload image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9 > 400 ? 400.0 : size.width * 0.9;
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.deepPurple,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB388FF), Color(0xFF7C4DFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              // Profile picture with edit button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.deepPurple.shade100,
                    backgroundImage:
                        _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : (_profilePicUrl != null &&
                                        _profilePicUrl!.isNotEmpty
                                    ? NetworkImage(_profilePicUrl!)
                                    : null)
                                as ImageProvider?,
                    child:
                        (_profilePicUrl == null || _profilePicUrl!.isEmpty) &&
                                _pickedImage == null
                            ? Text(
                              (_nicknameController.text.isNotEmpty
                                  ? _nicknameController.text[0].toUpperCase()
                                  : '?'),
                              style: TextStyle(
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 36,
                              ),
                            )
                            : null,
                  ),
                  if (_editMode)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _pickAndUploadImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.deepPurple,
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: cardWidth,
                child: Card(
                  elevation: 8,
                  color: Colors.white.withOpacity(0.95),
                  shadowColor: Colors.deepPurple.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(
                      color: Colors.deepPurple.shade100,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProfileField(
                          label: 'Nickname',
                          value: userProfile?['nickname'] ?? 'N/A',
                          icon: Icons.tag_faces,
                          isEditing: _editMode,
                          controller: _nicknameController,
                        ),
                        const SizedBox(height: 18),
                        _ProfileField(
                          label: 'Full Name',
                          value: userProfile?['full_name'] ?? 'N/A',
                          icon: Icons.person,
                          isEditing: _editMode,
                          controller: _fullnameController,
                        ),
                        const SizedBox(height: 18),
                        _ProfileField(
                          label: 'Company',
                          value: userProfile?['company'] ?? 'N/A',
                          icon: Icons.business,
                          isEditing: _editMode,
                          controller: _companyController,
                        ),
                        const SizedBox(height: 18),
                        _ProfileField(
                          label: 'User ID',
                          value: userId,
                          icon: Icons.vpn_key,
                        ),
                        const SizedBox(height: 18),
                        _ProfileField(
                          label: 'Created At',
                          value:
                              userProfile?['created_at'] != null
                                  ? DateTime.tryParse(
                                            userProfile!['created_at'],
                                          ) !=
                                          null
                                      ? DateTime.parse(
                                        userProfile!['created_at'],
                                      ).toLocal().toString().split('.').first
                                      : userProfile!['created_at']
                                  : '',
                          icon: Icons.calendar_today,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _editMode
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _saving ? null : _saveProfile,
                        icon:
                            _saving
                                ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : const Icon(Icons.save),
                        label: const Text('Save'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.deepPurple),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            _saving
                                ? null
                                : () {
                                  debugPrint(
                                    'ProfileScreen: Cancel edit pressed',
                                  );
                                  setState(() {
                                    _editMode = false;
                                    _error = null;
                                    // Reset controllers to original values
                                    _nicknameController.text =
                                        userProfile?['nickname'] ?? '';
                                    _fullnameController.text =
                                        userProfile?['full_name'] ?? '';
                                    _companyController.text =
                                        userProfile?['company'] ?? '';
                                  });
                                },
                        icon: const Icon(Icons.cancel),
                        label: const Text('Cancel'),
                      ),
                    ],
                  )
                  : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      debugPrint('ProfileScreen: Edit Profile pressed');
                      setState(() {
                        _editMode = true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isEditing;
  final TextEditingController? controller;
  const _ProfileField({
    required this.label,
    required this.value,
    required this.icon,
    this.isEditing = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.deepPurple, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.deepPurple.shade400,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              isEditing && controller != null
                  ? TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                    ),
                  )
                  : Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
