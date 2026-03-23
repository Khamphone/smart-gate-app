import 'package:flutter/material.dart';

enum PasswordStrength { empty, weak, fair, strong }

class PasswordStrengthBar extends StatelessWidget {
  final String password;

  const PasswordStrengthBar({super.key, required this.password});

  static PasswordStrength _evaluate(String pw) {
    if (pw.isEmpty) return PasswordStrength.empty;
    int score = 0;
    if (pw.length >= 8) score++;
    if (pw.contains(RegExp(r'[A-Z]'))) score++;
    if (pw.contains(RegExp(r'[0-9]'))) score++;
    if (pw.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    if (score <= 1) return PasswordStrength.weak;
    if (score <= 2) return PasswordStrength.fair;
    return PasswordStrength.strong;
  }

  @override
  Widget build(BuildContext context) {
    final strength = _evaluate(password);
    if (strength == PasswordStrength.empty) return const SizedBox.shrink();

    final (label, color, fraction) = switch (strength) {
      PasswordStrength.weak => ('Weak', Colors.red, 0.33),
      PasswordStrength.fair => ('Fair', Colors.orange, 0.66),
      PasswordStrength.strong => ('Strong', Colors.green, 1.0),
      _ => ('', Colors.grey, 0.0),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 4,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
