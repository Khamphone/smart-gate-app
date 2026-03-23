import '../models/dashboard_summary_model.dart';
import '../models/transaction_item_model.dart';
import 'dashboard_remote_datasource.dart';

/// Drop-in replacement for [DashboardRemoteDataSourceImpl] that returns
/// realistic data matching the live database schema.
/// Swap out in injection.dart by setting [useMock = false] when the API is ready.
class DashboardMockDataSource implements DashboardRemoteDataSource {
  @override
  Future<DashboardSummaryModel> getSummary({
    required DateTime from,
    required DateTime to,
    required String gateId,
  }) async {
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    return DashboardSummaryModel(
      totalRevenue: 58330000,
      totalVehicles: 314,
      gateName: 'BOK Gate',
      recentTransactions: _mockTransactions(from),
    );
  }

  static List<TransactionItemModel> _mockTransactions(DateTime base) {
    // Vehicle types and their BOK tariff codes + KIP rates from database.sql
    final entries = [
      ('SUV',         'BOK-CR01',  34000.0,  'success'),
      ('LargeTruck',  'BOK-CR08', 340000.0,  'success'),
      ('Motorcycle',  '0',              0.0,  'success'),
      ('Microbus',    'BOK-CR03',  68000.0,  'success'),
      ('MidTruck',    'BOK-CR08', 340000.0,  'pending'),
      ('SaloonCar',   'BOK-CR01',  34000.0,  'success'),
      ('MicroTruck',  'BOK-CR06', 170000.0,  'success'),
      ('MPV',         'BOK-CR03',  68000.0,  'success'),
      ('Pickup',      'BOK-CR01',  34000.0,  'success'),
      ('PassengerCar','0',              0.0,  'success'),
      ('SUV',         'BOK-CR01',  34000.0,  'success'),
      ('LargeTruck',  'BOK-CR08', 340000.0,  'success'),
    ];

    return List.generate(entries.length, (i) {
      final (vehicleType, tariffCode, amount, status) = entries[i];
      return TransactionItemModel(
        id: 'TXN-BOK-${(1000 + i).toString()}',
        vehicleType: vehicleType,
        tariffCode: tariffCode,
        amount: amount,
        createdAt: base.add(Duration(minutes: i * 7 + 3)),
        status: status,
        gateId: 'BOK-entry',
      );
    });
  }
}
