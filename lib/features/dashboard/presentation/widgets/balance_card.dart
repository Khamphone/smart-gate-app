import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final double totalRevenue;
  final String gateName;

  const BalanceCard({
    super.key,
    required this.totalRevenue,
    required this.gateName,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatter = NumberFormat('#,##0', 'en_US');

    return Card(
      color: colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  gateName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary.withOpacity(0.85),
                      ),
                ),
                Icon(Icons.toll_outlined, color: colorScheme.onPrimary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Today\'s Revenue',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 4),
            // Balance display placeholder
            totalRevenue == 0
                ? _PlaceholderBalance(color: colorScheme.onPrimary)
                : Text(
                    '${formatter.format(totalRevenue)} KIP',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderBalance extends StatelessWidget {
  final Color color;

  const _PlaceholderBalance({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 180,
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
