import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_gradient_scaffold.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_strength_bar.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String? _selectedGate;
  String? _selectedRole;
  bool _agreed = false;
  bool _showSuccess = false;

  final _gates = ['BOK Gate', 'Gate 2', 'Gate 3', 'All Gates'];
  final _roles = ['Operator', 'Supervisor', 'Admin'];

  Map<String, String?> _errors = {};

  @override
  void dispose() {
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _passCtrl, _confirmCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validate() {
    final errs = <String, String?>{};
    if (_nameCtrl.text.trim().isEmpty) errs['name'] = 'Full name is required';
    if (_emailCtrl.text.trim().isEmpty) errs['email'] = 'Email is required';
    if (_phoneCtrl.text.trim().isEmpty) errs['phone'] = 'Phone number is required';
    if (_selectedGate == null) errs['gate'] = 'Please select a gate';
    if (_selectedRole == null) errs['role'] = 'Please select a role';
    if (_passCtrl.text.length < 6) errs['password'] = 'Password must be at least 6 characters';
    if (_confirmCtrl.text != _passCtrl.text) errs['confirm'] = 'Passwords do not match';
    setState(() => _errors = errs);
    return errs.isEmpty;
  }

  bool get _canSubmit =>
      _nameCtrl.text.isNotEmpty &&
      _emailCtrl.text.isNotEmpty &&
      _phoneCtrl.text.isNotEmpty &&
      _selectedGate != null &&
      _selectedRole != null &&
      _passCtrl.text.length >= 6 &&
      _confirmCtrl.text == _passCtrl.text &&
      _agreed;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthPendingApproval) setState(() => _showSuccess = true);
        if (state is AuthFailure) setState(() => _errors['general'] = state.message);
      },
      child: AuthGradientScaffold(
        cardHeightFraction: 0.75,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            if (_showSuccess) return _SuccessView(onBack: () => context.go('/login'));

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Create Account',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Fill in your details to get started',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                  const SizedBox(height: 24),
                  AuthTextField(
                    label: 'Full Name *', placeholder: 'Enter your full name',
                    leadingIcon: Icons.person_outline, controller: _nameCtrl,
                    errorText: _errors['name'], enabled: !isLoading,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Email Address *', placeholder: 'Enter your email address',
                    leadingIcon: Icons.email_outlined, controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    errorText: _errors['email'], enabled: !isLoading,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Phone Number *', placeholder: '+856 XX XXX XXXX',
                    leadingIcon: Icons.phone_outlined, controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    errorText: _errors['phone'], enabled: !isLoading,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  _DropdownField(
                    label: 'Assigned Gate *', icon: Icons.location_on_outlined,
                    placeholder: 'Select your gate', items: _gates,
                    value: _selectedGate, errorText: _errors['gate'],
                    enabled: !isLoading,
                    onChanged: (v) => setState(() => _selectedGate = v),
                  ),
                  const SizedBox(height: 12),
                  _DropdownField(
                    label: 'Role *', icon: Icons.badge_outlined,
                    placeholder: 'Select your role', items: _roles,
                    value: _selectedRole, errorText: _errors['role'],
                    enabled: !isLoading,
                    onChanged: (v) => setState(() => _selectedRole = v),
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Password *', placeholder: 'Create a password',
                    leadingIcon: Icons.lock_outline, controller: _passCtrl,
                    isPassword: true, errorText: _errors['password'], enabled: !isLoading,
                    onChanged: (_) => setState(() {}),
                  ),
                  PasswordStrengthBar(password: _passCtrl.text),
                  const SizedBox(height: 12),
                  AuthTextField(
                    label: 'Confirm Password *', placeholder: 'Confirm your password',
                    leadingIcon: Icons.lock_outline, controller: _confirmCtrl,
                    isPassword: true, errorText: _errors['confirm'], enabled: !isLoading,
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  _AgreeRow(
                    value: _agreed,
                    enabled: !isLoading,
                    onChanged: (v) => setState(() => _agreed = v ?? false),
                  ),
                  if (_errors['general'] != null) ...[
                    const SizedBox(height: 8),
                    Text(_errors['general']!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: (isLoading || !_canSubmit)
                        ? null
                        : () {
                            if (_validate()) {
                              context.read<AuthBloc>().add(AuthRegisterRequested(
                                    fullName: _nameCtrl.text.trim(),
                                    email: _emailCtrl.text.trim(),
                                    phone: _phoneCtrl.text.trim(),
                                    assignedGate: _selectedGate!,
                                    role: _selectedRole!.toLowerCase(),
                                    password: _passCtrl.text,
                                  ));
                            }
                          },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Already have an account? '),
                    TextButton(
                      onPressed: isLoading ? null : () => context.go('/login'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ]),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final IconData icon;
  final String placeholder;
  final List<String> items;
  final String? value;
  final String? errorText;
  final bool enabled;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.label, required this.icon, required this.placeholder,
    required this.items, required this.value, required this.onChanged,
    this.errorText, this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      DropdownButtonFormField<String>(
        value: value,
        hint: Text(placeholder),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: errorText != null ? Colors.red : Colors.grey.shade300),
          ),
          filled: true,
          fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
        ),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: enabled ? onChanged : null,
      ),
      if (errorText != null) ...[
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ),
      ],
    ]);
  }
}

class _AgreeRow extends StatelessWidget {
  final bool value;
  final bool enabled;
  final void Function(bool?) onChanged;

  const _AgreeRow({required this.value, required this.onChanged, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Checkbox(value: value, onChanged: enabled ? onChanged : null),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Wrap(children: [
            const Text('I agree to the '),
            GestureDetector(
              onTap: () {},
              child: Text('Terms & Conditions',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
            const Text(' and '),
            GestureDetector(
              onTap: () {},
              child: Text('Privacy Policy',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ),
    ]);
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onBack;
  const _SuccessView({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
          child: Icon(Icons.check_circle, size: 72, color: Colors.green.shade600),
        ),
        const SizedBox(height: 24),
        const Text('Account Created!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text('Your account is awaiting admin approval.\nYou will be notified once approved.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5)),
        const SizedBox(height: 32),
        FilledButton(
          onPressed: onBack,
          style: FilledButton.styleFrom(
            minimumSize: const Size(200, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Back to Sign In'),
        ),
      ]),
    );
  }
}
