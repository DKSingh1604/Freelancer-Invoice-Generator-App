// ignore_for_file: sort_child_properties_last

import 'package:fig_app/repositories/client_repository.dart'
    show ClientRepository;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceAddScreen extends StatefulWidget {
  const InvoiceAddScreen({super.key});

  @override
  State<InvoiceAddScreen> createState() => _InvoiceAddScreenState();
}

class _InvoiceAddScreenState extends State<InvoiceAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClientId;
  List<Map<String, dynamic>> _clients = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String _selectedStatus = 'yet to start';
  final List<String> _statusOptions = [
    'yet to start',
    'draft',
    'sent',
    'paid',
    'overdue',
    'cancelled',
  ];
  DateTime? _selectedDate;
  DateTime? _selectedDueDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  Future<void> _fetchClients() async {
    setState(() => _loading = true);
    // You may want to use your ClientRepository here for a real app
    // For now, let's assume fetchClients returns a List<Client>
    try {
      final clients = await ClientRepository().fetchClients();
      setState(() {
        _clients = clients.map((c) => {'id': c.id, 'name': c.name}).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedClientId == null) return;
    setState(() => _loading = true);
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser?.id;
      await supabase.from('invoices').insert({
        'client_id': _selectedClientId,
        'description': _descriptionController.text.trim(),
        'amount': double.tryParse(_amountController.text.trim()) ?? 0.0,
        'created_at':
            _selectedDate?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'status': _selectedStatus,
        'due_date': _selectedDueDate?.toIso8601String(),
        'user_id': userId,
        'notes': _noteController.text.trim(),
      });
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice added successfully')),
      );
      setState(() => _loading = false);
    } catch (e) {
      print('Error adding invoice: $e');
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add invoice: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Add Invoice'),
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
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.receipt_long,
                                  color: Colors.deepPurple,
                                  size: 28,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Invoice Details',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            DropdownButtonFormField<String>(
                              value: _selectedClientId,
                              items:
                                  _clients
                                      .map(
                                        (client) => DropdownMenuItem<String>(
                                          value: client['id'] as String,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    Colors.deepPurple.shade100,
                                                child: Text(
                                                  (client['name'] as String)
                                                          .isNotEmpty
                                                      ? (client['name']
                                                              as String)[0]
                                                          .toUpperCase()
                                                      : '?',
                                                  style: const TextStyle(
                                                    color: Colors.deepPurple,
                                                  ),
                                                ),
                                                radius: 14,
                                              ),
                                              const SizedBox(width: 10),
                                              Flexible(
                                                child: Text(
                                                  client['name'] as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) =>
                                      setState(() => _selectedClientId = val),
                              decoration: InputDecoration(
                                labelText: 'Select Client',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                              validator:
                                  (val) =>
                                      val == null
                                          ? 'Please select a client'
                                          : null,
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Amount',
                                prefixIcon: Icon(Icons.attach_money),
                              ),
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? 'Enter amount'
                                          : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                prefixIcon: Icon(Icons.description_outlined),
                              ),
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? 'Enter description'
                                          : null,
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _noteController,
                              decoration: const InputDecoration(
                                labelText: 'Note (optional)',
                                prefixIcon: Icon(Icons.note_alt_outlined),
                              ),
                              maxLines: 2,
                            ),
                            const SizedBox(height: 18),
                            DropdownButtonFormField<String>(
                              value: _selectedStatus,
                              items:
                                  _statusOptions
                                      .map(
                                        (status) => DropdownMenuItem(
                                          value: status,
                                          child: Row(
                                            children: [
                                              Icon(
                                                status == 'paid'
                                                    ? Icons.check_circle
                                                    : status == 'overdue'
                                                    ? Icons
                                                        .warning_amber_rounded
                                                    : status == 'sent'
                                                    ? Icons.send
                                                    : status == 'draft'
                                                    ? Icons.edit_note
                                                    : status == 'cancelled'
                                                    ? Icons.cancel
                                                    : Icons.hourglass_empty,
                                                color:
                                                    status == 'paid'
                                                        ? Colors.green
                                                        : status == 'overdue'
                                                        ? Colors.red
                                                        : status == 'sent'
                                                        ? Colors.blue
                                                        : status == 'draft'
                                                        ? Colors.orange
                                                        : status == 'cancelled'
                                                        ? Colors.grey
                                                        : Colors.deepPurple,
                                                size: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                status[0].toUpperCase() +
                                                    status.substring(1),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged:
                                  (val) => setState(
                                    () =>
                                        _selectedStatus = val ?? 'yet to start',
                                  ),
                              decoration: InputDecoration(
                                labelText: 'Status',
                                prefixIcon: const Icon(Icons.flag_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                              ),
                              validator:
                                  (val) =>
                                      val == null || val.isEmpty
                                          ? 'Select status'
                                          : null,
                              dropdownColor: Colors.white,
                              isExpanded: true,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 18),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                _selectedDate == null
                                    ? 'Select Date'
                                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => _selectedDate = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(
                                Icons.event,
                                color: Colors.deepPurple,
                              ),
                              title: Text(
                                _selectedDueDate == null
                                    ? 'Select Due Date'
                                    : 'Due Date: ${_selectedDueDate!.toLocal().toString().split(' ')[0]}',
                              ),
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  setState(() => _selectedDueDate = picked);
                                }
                              },
                            ),
                            const SizedBox(height: 28),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.save_alt),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _submit,
                              label: const Text('Save Invoice'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
