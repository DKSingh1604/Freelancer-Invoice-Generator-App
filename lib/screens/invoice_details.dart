import 'package:flutter/material.dart';
import 'package:fig_app/models/invoice_model.dart';
import 'package:flutter/services.dart';

class InvoiceDetails extends StatelessWidget {
  final Invoice invoice;
  const InvoiceDetails({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Details'),
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
                      child: Icon(
                        Icons.receipt_long,
                        color: Colors.deepPurple.shade700,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            invoice.clientName ?? 'Unknown Client',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          if (invoice.description != null &&
                              invoice.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                invoice.description!,
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
                _DetailRow(
                  label: 'Amount',
                  value: '\$${invoice.amount?.toStringAsFixed(2) ?? '--'}',
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Date',
                  value:
                      invoice.createdAt != null
                          ? '${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}'
                          : '',
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  label: 'Due Date',
                  value:
                      invoice.dueDate != null
                          ? '${invoice.dueDate!.day}/${invoice.dueDate!.month}/${invoice.dueDate!.year}'
                          : 'N/A',
                ),
                const SizedBox(height: 16),
                _DetailRow(label: 'Status', value: invoice.status ?? 'N/A'),
                if (invoice.clientId != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailRow(
                          label: 'Client ID',
                          value: invoice.clientId!,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          size: 18,
                          color: Colors.deepPurple,
                        ),
                        tooltip: 'Copy Client ID',
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: invoice.clientId!),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Client ID copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
                if (invoice.id != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _DetailRow(
                          label: 'Invoice ID',
                          value: invoice.id!,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.copy,
                          size: 18,
                          color: Colors.deepPurple,
                        ),
                        tooltip: 'Copy Invoice ID',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: invoice.id!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Invoice ID copied!')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
                _DetailRow(
                  label: 'Notes',
                  value:
                      invoice.notes != null && invoice.notes!.isNotEmpty
                          ? invoice.notes!
                          : 'N/A',
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
