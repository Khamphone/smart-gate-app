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
      backgroundColor: const Color(0xFFF9F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF1F5F9),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1D4ED8)),
          onPressed: () {},
        ),
        title: const Text(
          'Smart Gate',
          style: TextStyle(
            color: Color(0xFF1D4ED8),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          const NotificationBadge(),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
            onPressed: () =>
                context.read<DashboardBloc>().add(const DashboardRefreshed()),
          ),
        ],
      ),
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return switch (state) {
            DashboardLoading() =>
              const Center(child: CircularProgressIndicator()),
            DashboardFailure(:final message) =>
              _ErrorView(message: message),
            DashboardSuccess(:final summary) =>
              _SuccessView(summary: summary),
            _ => const SizedBox.shrink(),
          };
        },
      ),
      floatingActionButton: _GradientFab(onTap: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class _GradientFab extends StatelessWidget {
  final VoidCallback onTap;

  const _GradientFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF005BBF), Color(0xFF1A73E8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF005BBF).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: const Icon(Icons.add_road, color: Colors.white, size: 28),
        ),
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                BalanceCard(
                  totalRevenue: summary.totalRevenue,
                  gateName: summary.gateName,
                ),
                const SizedBox(height: 16),
                StatsRow(totalVehicles: summary.totalVehicles),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction History',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF191C23),
                              ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF005BBF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
              ]),
            ),
          ),
          TransactionList(transactions: summary.recentTransactions),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
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
