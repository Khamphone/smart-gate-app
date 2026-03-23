import 'package:flutter/material.dart';

class StatsRow extends StatelessWidget {
  final int totalVehicles;

  const StatsRow({super.key, required this.totalVehicles});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            iconWidget: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFD8E2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.directions_car,
                color: Color(0xFF005BBF),
                size: 22,
              ),
            ),
            valueWidget: Text(
              totalVehicles.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF191C23),
              ),
            ),
            label: 'Vehicles Today',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            iconWidget: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF86F898),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.sensors,
                color: Color(0xFF006E2C),
                size: 22,
              ),
            ),
            valueWidget: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF006E2C),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF191C23),
                  ),
                ),
              ],
            ),
            label: 'Gate Status',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final Widget iconWidget;
  final Widget valueWidget;
  final String label;

  const _StatCard({
    required this.iconWidget,
    required this.valueWidget,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          const SizedBox(height: 12),
          valueWidget,
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF414754),
            ),
          ),
        ],
      ),
    );
  }
}
