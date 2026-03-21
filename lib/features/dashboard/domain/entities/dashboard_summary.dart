import 'package:equatable/equatable.dart';

import 'transaction_item.dart';

class DashboardSummary extends Equatable {
  final double totalRevenue;
  final int totalVehicles;
  final String gateName;
  final List<TransactionItem> recentTransactions;

  const DashboardSummary({
    required this.totalRevenue,
    required this.totalVehicles,
    required this.gateName,
    required this.recentTransactions,
  });

  @override
  List<Object?> get props => [totalRevenue, totalVehicles, gateName, recentTransactions];
}
