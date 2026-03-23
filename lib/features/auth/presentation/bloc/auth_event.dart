part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String phone;
  final String assignedGate;
  final String role;
  final String password;
  const AuthRegisterRequested({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.assignedGate,
    required this.role,
    required this.password,
  });
  @override
  List<Object?> get props => [fullName, email, phone, assignedGate, role, password];
}

class AuthForgotPasswordRequested extends AuthEvent {
  final String email;
  const AuthForgotPasswordRequested(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthOtpVerifyRequested extends AuthEvent {
  final String email;
  final String otp;
  const AuthOtpVerifyRequested({required this.email, required this.otp});
  @override
  List<Object?> get props => [email, otp];
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
