import '../entities/dashboard_summary.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummary {
  final DashboardRepository _repository;

  const GetDashboardSummary(this._repository);

  Future<DashboardSummary> call({
    required DateTime from,
    required DateTime to,
    required String gateId,
  }) {
    return _repository.getSummary(from: from, to: to, gateId: gateId);
  }
}
