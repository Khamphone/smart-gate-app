import 'package:equatable/equatable.dart';

class TransactionItem extends Equatable {
  final String id;
  final String vehicleType;
  final String tariffCode;
  final double amount;
  final DateTime createdAt;
  final String status;
  final String gateId;

  const TransactionItem({
    required this.id,
    required this.vehicleType,
    required this.tariffCode,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.gateId,
  });

  @override
  List<Object?> get props => [id, vehicleType, tariffCode, amount, createdAt, status, gateId];
}
