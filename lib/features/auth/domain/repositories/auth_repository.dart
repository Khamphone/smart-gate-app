import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> signIn({required String email, required String password});
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String assignedGate,
    required String role,
    required String password,
  });
  Future<void> forgotPassword(String email);
  Future<bool> verifyOtp({required String email, required String otp});
  Future<void> signOut();
  Future<AppUser?> getCurrentUser();
}
