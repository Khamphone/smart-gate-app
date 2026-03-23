import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/usecases/forgot_password.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/verify_otp.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final RegisterUser _register;
  final ForgotPassword _forgotPassword;
  final VerifyOtp _verifyOtp;
  final AuthRepository _repository;

  AuthBloc({
    required SignIn signIn,
    required RegisterUser register,
    required ForgotPassword forgotPassword,
    required VerifyOtp verifyOtp,
    required AuthRepository repository,
  })  : _signIn = signIn,
        _register = register,
        _forgotPassword = forgotPassword,
        _verifyOtp = verifyOtp,
        _repository = repository,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthOtpVerifyRequested>(_onOtpVerify);
    on<AuthSignOutRequested>(_onSignOut);
  }

  Future<void> _onCheck(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final user = await _repository.getCurrentUser();
    emit(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated());
  }

  Future<void> _onSignIn(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _signIn(email: event.email, password: event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onRegister(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _register(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        assignedGate: event.assignedGate,
        role: event.role,
        password: event.password,
      );
      emit(AuthPendingApproval(user));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onForgotPassword(
      AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _forgotPassword(event.email);
      emit(AuthForgotPasswordSent(event.email));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onOtpVerify(
      AuthOtpVerifyRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final valid = await _verifyOtp(email: event.email, otp: event.otp);
      emit(valid ? const AuthOtpVerified() : const AuthFailure('Invalid code. Please try again.'));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    await _repository.signOut();
    emit(const AuthUnauthenticated());
  }
}
