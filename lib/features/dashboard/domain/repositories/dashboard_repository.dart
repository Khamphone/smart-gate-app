import '../entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<DashboardSummary> getSummary({
    required DateTime from,
    required DateTime to,
    required String gateId,
  });
}
