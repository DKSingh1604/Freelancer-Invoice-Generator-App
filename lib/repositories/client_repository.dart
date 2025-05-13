import 'package:fig_app/models/client_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientRepository {
  final supabase = Supabase.instance.client;

  Future<List<Client>> fetchClients() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return [];
    }
    final data = await supabase
        .from('clients')
        .select()
        .eq('user_id', userId)
        .order('name');

    print('Fetched clients:');
    print(data);

    return (data as List).map((e) => Client.fromMap(e)).toList();
  }
}
