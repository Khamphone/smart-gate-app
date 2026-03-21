import '../../domain/entities/dashboard_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<DashboardSummary> getSummary({
    required DateTime from,
    required DateTime to,
    required String gateId,
  }) async {
    return remoteDataSource.getSummary(from: from, to: to, gateId: gateId);
  }
}
