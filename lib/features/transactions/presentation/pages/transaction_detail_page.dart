import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailPage extends StatelessWidget {
  final String transactionId;

  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
        leading: BackButton(onPressed: () => context.go('/')),
      ),
      body: Center(
        child: Text('Transaction ID: $transactionId'),
      ),
    );
  }
}
