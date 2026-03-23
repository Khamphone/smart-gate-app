part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final AppUser user;
  const AuthAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Registration succeeded but account is pending admin approval.
class AuthPendingApproval extends AuthState {
  final AppUser user;
  const AuthPendingApproval(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthForgotPasswordSent extends AuthState {
  final String email;
  const AuthForgotPasswordSent(this.email);
  @override
  List<Object?> get props => [email];
}

class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}

class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
  @override
  List<Object?> get props => [message];
}
