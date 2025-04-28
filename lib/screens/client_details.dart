import 'package:flutter/material.dart';
import 'package:fig_app/models/client_model.dart';
import 'package:flutter/services.dart';

class ClientDetails extends StatelessWidget {
  final Client client;
  const ClientDetails({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Client Details"),
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: Text(
                        client.name.isNotEmpty
                            ? client.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: Colors.deepPurple.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          if (client.company != null &&
                              client.company!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                client.company!,
                                style: TextStyle(
                                  color: Colors.deepPurple.shade400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                _DetailRow(label: 'Email', value: client.email),
                const SizedBox(height: 16),
                _DetailRow(label: 'Phone', value: client.phone),
                const SizedBox(height: 16),
                _DetailRow(label: 'Address', value: client.address ?? 'N/A'),
                const SizedBox(height: 16),
                _DetailRow(label: 'City', value: client.city ?? 'N/A'),
                const SizedBox(height: 16),
                _DetailRow(label: 'State', value: client.state ?? 'N/A'),
                const SizedBox(height: 16),
                _DetailRow(label: 'Country', value: client.country ?? 'N/A'),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'GST Number',
                  value: client.gstNumber ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Website', value: client.website ?? 'N/A'),
                const SizedBox(height: 16),
                _DetailRow(label: 'Notes', value: client.notes ?? 'N/A'),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Contact Person',
                  value: client.contactPerson ?? 'N/A',
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Client ID', value: client.id),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy Client ID'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: client.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Client ID copied!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade700,
            fontSize: 15,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}
