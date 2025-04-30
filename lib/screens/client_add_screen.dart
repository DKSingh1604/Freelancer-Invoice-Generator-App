import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientAddScreen extends StatefulWidget {
  const ClientAddScreen({super.key});

  @override
  State<ClientAddScreen> createState() => _ClientAddScreenState();
}

class _ClientAddScreenState extends State<ClientAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _contactPersonController =
      TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _gstController.dispose();
    _websiteController.dispose();
    _notesController.dispose();
    _contactPersonController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final user = Supabase.instance.client.auth.currentUser;
      await Supabase.instance.client.from('clients').insert({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'company': _companyController.text.trim(),
        'address': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'state': _stateController.text.trim(),
        'country': _countryController.text.trim(),
        'gst_number': _gstController.text.trim(),
        'website': _websiteController.text.trim(),
        'notes': _notesController.text.trim(),
        'contact_person': _contactPersonController.text.trim(),
        'user_id': user?.id,
      });
      if (mounted) {
        print("Client added successfully");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client added successfully')),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      print('Error adding client: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add client: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12), // Reduced padding
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                  side: BorderSide(color: Colors.deepPurple.shade100, width: 2),
                ),
                color: Colors.white.withOpacity(0.98),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ), // Reduced padding
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 36,
                                backgroundColor: Colors.deepPurple.shade100,
                                child: const Icon(
                                  Icons.person_add,
                                  color: Colors.deepPurple,
                                  size: 36,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Add New Client',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                        _buildField(
                          _nameController,
                          'Name',
                          Icons.person,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty ? 'Enter name' : null,
                        ),
                        const SizedBox(height: 18),
                        _buildField(
                          _emailController,
                          'Email',
                          Icons.email,
                          validator:
                              (v) =>
                                  v == null || v.isEmpty ? 'Enter email' : null,
                        ),
                        const SizedBox(height: 18),
                        _buildField(
                          _phoneController,
                          'Phone',
                          Icons.phone,
                        ), // Now optional
                        const SizedBox(height: 18),
                        _buildField(
                          _companyController,
                          'Company',
                          Icons.business,
                        ), // Now optional
                        const SizedBox(height: 18),
                        _buildField(
                          _addressController,
                          'Address',
                          Icons.location_on,
                        ), // Now optional
                        const SizedBox(height: 18),
                        _buildField(
                          _cityController,
                          'City',
                          Icons.location_city,
                        ),
                        const SizedBox(height: 18),
                        _buildField(_stateController, 'State', Icons.map),
                        const SizedBox(height: 18),
                        _buildField(_countryController, 'Country', Icons.flag),
                        const SizedBox(height: 18),
                        _buildField(
                          _gstController,
                          'GST Number',
                          Icons.confirmation_number,
                        ), // Now optional
                        const SizedBox(height: 18),
                        _buildField(_websiteController, 'Website', Icons.web),
                        const SizedBox(height: 18),
                        _buildField(_notesController, 'Notes', Icons.note),
                        const SizedBox(height: 18),
                        _buildField(
                          _contactPersonController,
                          'Contact Person',
                          Icons.person_outline,
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child:
                              _loading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.save),
                                      label: const Text(
                                        'Add Client',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 18,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 19,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                        ),
                                        elevation: 4,
                                      ),
                                      onPressed: _submit,
                                    ),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon, {
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          filled: true,
          fillColor: Colors.deepPurple.shade50,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
        validator: validator,
      ),
    );
  }
}
