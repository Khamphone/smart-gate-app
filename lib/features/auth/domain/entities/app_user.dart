import 'package:equatable/equatable.dart';

enum UserRole { operator, supervisor, admin }
enum UserStatus { pending, approved, suspended }

class AppUser extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String assignedGate;
  final UserRole role;
  final UserStatus status;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.assignedGate,
    required this.role,
    required this.status,
  });

  @override
  List<Object?> get props => [id, fullName, email, phone, assignedGate, role, status];
}
