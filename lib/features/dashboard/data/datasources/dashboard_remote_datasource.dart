import '../models/dashboard_summary_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getSummary({
    required DateTime from,
    required DateTime to,
    required String gateId,
  });
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  // TODO: inject Dio instance via constructor

  @override
  Future<DashboardSummaryModel> getSummary({
    required DateTime from,
    required DateTime to,
    required String gateId,
  }) async {
    // TODO: implement API call
    // final response = await _dio.get('/dashboard/summary', queryParameters: {...});
    // return DashboardSummaryModel.fromJson(response.data);
    throw UnimplementedError();
  }
}
