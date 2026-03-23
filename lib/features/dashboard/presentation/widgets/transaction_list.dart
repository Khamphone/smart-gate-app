import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionItem> transactions;

  const TransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('No transactions yet today.')),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) => TransactionTile(
          transaction: transactions[index],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('hh:mm a');
    final amountFormatter = NumberFormat('#,##0', 'en_US');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.go('/transactions/${transaction.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Vehicle icon circle
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E2EC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _vehicleIcon(transaction.vehicleType),
                    color: const Color(0xFF414754),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Label + tariff
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.vehicleType.isEmpty
                            ? 'Unknown'
                            : transaction.vehicleType,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF191C23),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${transaction.tariffCode} · ${timeFormatter.format(transaction.createdAt)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF414754),
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount + status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '₭ ',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color:
                                  const Color(0xFF414754).withOpacity(0.7),
                            ),
                          ),
                          TextSpan(
                            text: amountFormatter
                                .format(transaction.amount),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005BBF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    _StatusBadge(status: transaction.status),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _vehicleIcon(String vehicleType) {
    return switch (vehicleType.toLowerCase()) {
      'motorcycle' => Icons.two_wheeler,
      'largetruck' || 'midtruck' => Icons.local_shipping,
      'microtruck' => Icons.local_shipping_outlined,
      'microbus' || 'mpv' => Icons.airport_shuttle,
      'suv' || 'luxury suv' => Icons.electric_car,
      'sedan' || 'saloooncar' || 'compact sedan' || 'ev sedan' =>
        Icons.electric_car,
      _ => Icons.directions_car,
    };
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isSuccess = status.toLowerCase() == 'success';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isSuccess
            ? const Color(0xFF86F898)
            : const Color(0xFFFFDDB9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toLowerCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: isSuccess
              ? const Color(0xFF00722F)
              : const Color(0xFF2B1700),
        ),
      ),
    );
  }
}
