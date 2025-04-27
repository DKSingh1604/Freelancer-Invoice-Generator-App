import 'package:fig_app/models/invoice_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InvoiceRepository {
  final supabase = Supabase.instance.client;

  Future<List<Invoice>> fetchRecentInvoices({int limit = 5}) async {
    final List data = await supabase
        .from('invoices')
        .select('*, clients!client_id(name)')
        // .select()
        .eq('user_id', supabase.auth.currentUser!.id)
        .order('created_at', ascending: false)
        .limit(limit);
    print('FETCHED INVOICES:');
    print(data);

    return data.map((e) => Invoice.fromMap(e)).toList();
  }
}
