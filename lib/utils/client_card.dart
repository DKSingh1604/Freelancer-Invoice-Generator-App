import 'package:fig_app/models/client_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  const ClientCard({required this.client});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(client.name),
        subtitle: Text(client.company ?? 'No company'),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {},
      ),
    );
  }
}
