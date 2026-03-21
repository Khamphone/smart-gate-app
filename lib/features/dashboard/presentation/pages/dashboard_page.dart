import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/balance_card.dart';
import '../widgets/stats_row.dart';
import '../widgets/transaction_list.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()
        ..add(DashboardLoaded(
          from: DateTime.now().copyWith(hour: 0, minute: 0, second: 0),
          to: DateTime.now(),
          gateId: 'BOK',
        )),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Gate'),
        actions: [
          const NotificationBadge(),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<DashboardBloc>().add(const DashboardRefreshed()),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            DashboardLoading() => const Center(child: CircularProgressIndicator()),
            DashboardFailure(:final message) => _ErrorView(message: message),
            DashboardSuccess(:final summary) => _SuccessView(summary: summary),
            _ => const SizedBox.shrink(),
          };
        },
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final dynamic summary;

  const _SuccessView({required this.summary});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async =>
          context.read<DashboardBloc>().add(const DashboardRefreshed()),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                BalanceCard(
                  totalRevenue: summary.totalRevenue,
                  gateName: summary.gateName,
                ),
                const SizedBox(height: 16),
                StatsRow(
                  totalVehicles: summary.totalVehicles,
                ),
                const SizedBox(height: 24),
                Text(
                  'Transaction History',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
              ]),
            ),
          ),
          TransactionList(transactions: summary.recentTransactions),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;

  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () =>
                context.read<DashboardBloc>().add(const DashboardRefreshed()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
