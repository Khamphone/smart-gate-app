import '../../domain/entities/dashboard_summary.dart';
import '../../domain/entities/transaction_item.dart';
import 'transaction_item_model.dart';

class DashboardSummaryModel extends DashboardSummary {
  const DashboardSummaryModel({
    required super.totalRevenue,
    required super.totalVehicles,
    required super.gateName,
    required super.recentTransactions,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      totalVehicles: json['total_vehicles'] as int,
      gateName: json['gate_name'] as String,
      recentTransactions: (json['recent_transactions'] as List)
          .map((e) => TransactionItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
