part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoadInProgress extends DashboardState {}

class DashboardLoadSuccess extends DashboardState {
  final List<Client> clients;
  final List<Invoice> recentInvoices;
  DashboardLoadSuccess({required this.clients, required this.recentInvoices});
}

class DashboardLoadFailure extends DashboardState {
  final String error;
  DashboardLoadFailure(this.error);
}
