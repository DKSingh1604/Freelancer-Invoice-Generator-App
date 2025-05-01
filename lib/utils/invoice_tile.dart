import 'package:fig_app/models/invoice_model.dart';
import 'package:fig_app/screens/invoice_details.dart';
import 'package:flutter/material.dart';

class InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  const InvoiceTile({required this.invoice});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isOverdue =
        invoice.dueDate != null &&
        invoice.dueDate!.isBefore(DateTime(now.year, now.month, now.day));
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      color: isOverdue ? const Color.fromARGB(255, 245, 153, 162) : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          // Open Invoice Detail Page (later we'll show PDF here)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return InvoiceDetails(invoice: invoice);
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.deepPurple.shade100,
                child: Icon(
                  Icons.receipt_long,
                  color: Colors.deepPurple.shade700,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      invoice.clientName ?? 'Unknown Client',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#${invoice.id?.substring(0, 8) ?? ''}...',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${invoice.amount?.toStringAsFixed(2) ?? '--'}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invoice.createdAt != null
                        ? '${invoice.createdAt.day}/${invoice.createdAt.month}/${invoice.createdAt.year}'
                        : '',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
