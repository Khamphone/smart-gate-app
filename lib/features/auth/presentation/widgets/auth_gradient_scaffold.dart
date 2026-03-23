import 'package:flutter/material.dart';

class AuthGradientScaffold extends StatelessWidget {
  final Widget child;
  final double cardHeightFraction;

  const AuthGradientScaffold({
    super.key,
    required this.child,
    this.cardHeightFraction = 0.65,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A73E8), Color(0xFF74B3FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Logo header area
              SizedBox(
                height: size.height * (1 - cardHeightFraction) - MediaQuery.paddingOf(context).top,
                child: const _LogoHeader(),
              ),
              // White card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.toll_outlined, size: 48, color: Colors.white),
        ),
        const SizedBox(height: 12),
        const Text(
          'Smart Gate',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Gate Management System',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}
