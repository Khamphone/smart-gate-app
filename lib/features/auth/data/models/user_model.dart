import '../../domain/entities/app_user.dart';

class UserModel extends AppUser {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.assignedGate,
    required String role,
    required String status,
  }) : super(
          role: _parseRole(role),
          status: _parseStatus(status),
        );

  static UserRole _parseRole(String raw) => switch (raw.toLowerCase()) {
        'supervisor' => UserRole.supervisor,
        'admin' => UserRole.admin,
        _ => UserRole.operator,
      };

  static UserStatus _parseStatus(String raw) => switch (raw.toLowerCase()) {
        'approved' => UserStatus.approved,
        'suspended' => UserStatus.suspended,
        _ => UserStatus.pending,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        fullName: json['full_name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String? ?? '',
        assignedGate: json['assigned_gate'] as String? ?? '',
        role: json['role'] as String? ?? 'operator',
        status: json['status'] as String? ?? 'pending',
      );
}
