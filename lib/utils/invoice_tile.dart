import 'package:fig_app/models/invoice_model.dart';
import 'package:flutter/material.dart';

class InvoiceTile extends StatelessWidget {
  final Invoice invoice;
  const InvoiceTile({required this.invoice});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Invoice #${invoice.id}'),
      subtitle: Text(invoice.clientName),
      trailing: Text('\$${invoice.amount.toStringAsFixed(2)}'),
      onTap: () {
        // Open Invoice Detail Page (later we'll show PDF here)
      },
    );
  }
}
