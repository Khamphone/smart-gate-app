import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView();

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  final _emailCtrl = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) setState(() => _emailError = state.message);
      },
      child: Scaffold(
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            final isSent = state is AuthForgotPasswordSent;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: isSent
                    ? _SentView(email: (state as AuthForgotPasswordSent).email)
                    : _FormView(
                        emailCtrl: _emailCtrl,
                        emailError: _emailError,
                        isLoading: isLoading,
                        onSubmit: () {
                          final email = _emailCtrl.text.trim();
                          if (email.isEmpty) {
                            setState(() => _emailError = 'Email is required');
                            return;
                          }
                          setState(() => _emailError = null);
                          context.read<AuthBloc>().add(AuthForgotPasswordRequested(email));
                        },
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController emailCtrl;
  final String? emailError;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _FormView({
    required this.emailCtrl, required this.emailError,
    required this.isLoading, required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mark_email_unread_outlined,
                size: 64, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 28),
        const Text('Forgot Password?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text("Enter your registered email. We'll send you a reset link.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
        const SizedBox(height: 32),
        AuthTextField(
          label: 'Email Address *',
          placeholder: 'Enter your email address',
          leadingIcon: Icons.email_outlined,
          controller: emailCtrl,
          keyboardType: TextInputType.emailAddress,
          errorText: emailError,
          enabled: !isLoading,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: isLoading ? null : onSubmit,
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Send Reset Link', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: isLoading ? null : () => context.pop(),
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }
}

class _SentView extends StatelessWidget {
  final String email;
  const _SentView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
            child: Icon(Icons.check_circle_outline, size: 72, color: Colors.green.shade600),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Check your email',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('A reset link has been sent to\n$email\nCheck your inbox.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.6)),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Resend Email'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => context.go('/login'),
          child: const Text('Back to Sign In'),
        ),
      ],
    );
  }
}
