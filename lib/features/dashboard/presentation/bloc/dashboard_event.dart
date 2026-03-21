part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DashboardEvent {
  final DateTime from;
  final DateTime to;
  final String gateId;

  const DashboardLoaded({
    required this.from,
    required this.to,
    required this.gateId,
  });

  @override
  List<Object?> get props => [from, to, gateId];
}

class DashboardRefreshed extends DashboardEvent {
  const DashboardRefreshed();
}
