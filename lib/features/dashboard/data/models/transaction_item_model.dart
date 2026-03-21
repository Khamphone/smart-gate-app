import '../../domain/entities/transaction_item.dart';

class TransactionItemModel extends TransactionItem {
  const TransactionItemModel({
    required super.id,
    required super.vehicleType,
    required super.tariffCode,
    required super.amount,
    required super.createdAt,
    required super.status,
    required super.gateId,
  });

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) {
    return TransactionItemModel(
      id: json['id'] as String,
      vehicleType: json['vehicle_type'] as String? ?? '',
      tariffCode: json['tariff_code'] as String? ?? 'BOK-CR01',
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      status: json['status'] as String,
      gateId: json['gate_id'] as String,
    );
  }
}
