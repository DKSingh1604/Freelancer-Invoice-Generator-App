part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent {}

class DashboardStarted extends DashboardEvent {}

class DashboardRefreshRequested extends DashboardEvent {}
