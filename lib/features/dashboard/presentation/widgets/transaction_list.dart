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
    final timeFormatter = DateFormat('HH:mm');
    final amountFormatter = NumberFormat('#,##0', 'en_US');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () => context.go('/transactions/${transaction.id}'),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            _vehicleIcon(transaction.vehicleType),
            color: Theme.of(context).colorScheme.onSecondaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          transaction.vehicleType.isEmpty ? 'Unknown' : transaction.vehicleType,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${transaction.tariffCode} · ${timeFormatter.format(transaction.createdAt)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${amountFormatter.format(transaction.amount)} KIP',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 2),
            _StatusBadge(status: transaction.status),
          ],
        ),
      ),
    );
  }

  IconData _vehicleIcon(String vehicleType) {
    return switch (vehicleType.toLowerCase()) {
      'motorcycle' => Icons.two_wheeler,
      'largetruck' || 'midtruck' || 'microtruck' => Icons.local_shipping,
      'microbus' || 'mpv' => Icons.airport_shuttle,
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isSuccess ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          color: isSuccess ? Colors.green.shade800 : Colors.orange.shade800,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
