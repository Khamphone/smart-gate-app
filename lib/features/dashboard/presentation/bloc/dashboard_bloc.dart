import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/dashboard_summary.dart';
import '../../domain/usecases/get_dashboard_summary.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardSummary getDashboardSummary;

  // Remembers last params for refresh
  DashboardLoaded? _lastEvent;

  DashboardBloc({required this.getDashboardSummary}) : super(const DashboardInitial()) {
    on<DashboardLoaded>(_onLoaded);
    on<DashboardRefreshed>(_onRefreshed);
  }

  Future<void> _onLoaded(DashboardLoaded event, Emitter<DashboardState> emit) async {
    _lastEvent = event;
    emit(const DashboardLoading());
    try {
      final summary = await getDashboardSummary(
        from: event.from,
        to: event.to,
        gateId: event.gateId,
      );
      emit(DashboardSuccess(summary));
    } catch (e) {
      emit(DashboardFailure(e.toString()));
    }
  }

  Future<void> _onRefreshed(DashboardRefreshed event, Emitter<DashboardState> emit) async {
    if (_lastEvent == null) return;
    await _onLoaded(_lastEvent!, emit);
  }
}
