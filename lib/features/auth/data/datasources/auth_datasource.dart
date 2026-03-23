import '../models/user_model.dart';

abstract class AuthDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> register({
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
  Future<UserModel?> getCurrentUser();
}

/// Mock — replace with real Dio calls when API is ready.
class AuthMockDataSource implements AuthDataSource {
  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (password.length < 6) throw Exception('Invalid email or password');
    return UserModel(
      id: 'usr_001',
      fullName: 'Somchai Vongkhamphanh',
      email: email,
      phone: '+85620123456',
      assignedGate: 'BOK Gate',
      role: 'operator',
      status: 'approved',
    );
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String assignedGate,
    required String role,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return UserModel(
      id: 'usr_new',
      fullName: fullName,
      email: email,
      phone: phone,
      assignedGate: assignedGate,
      role: role,
      status: 'pending',
    );
  }

  @override
  Future<void> forgotPassword(String email) async =>
      Future.delayed(const Duration(milliseconds: 800));

  @override
  Future<bool> verifyOtp({required String email, required String otp}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return otp == '123456'; // mock: any real API validates server-side
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<UserModel?> getCurrentUser() async => null;
}
