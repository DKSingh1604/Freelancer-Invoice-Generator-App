import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fig_app/models/client_model.dart';
import 'package:fig_app/models/invoice_model.dart';
import 'package:fig_app/repositories/client_repository.dart';
import 'package:fig_app/repositories/invoice_repository.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ClientRepository clientRepo;
  final InvoiceRepository invoiceRepo;
  DashboardBloc({required this.clientRepo, required this.invoiceRepo})
    : super(DashboardLoadInProgress()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshRequested>(_onRefresh);
  }

  Future<void> _onStarted(event, emit) async {
    emit(DashboardLoadInProgress());
    try {
      final clients = await clientRepo.fetchClients();
      final invoices = await invoiceRepo.fetchRecentInvoices(limit: 5);
      emit(DashboardLoadSuccess(clients: clients, recentInvoices: invoices));
    } catch (e) {
      emit(DashboardLoadFailure(e.toString()));
    }
  }

  Future<void> _onRefresh(event, emit) async {
    // identical logic to _onStarted
    add(DashboardStarted());
  }
}
