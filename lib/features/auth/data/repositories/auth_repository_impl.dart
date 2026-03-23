import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;
  const AuthRepositoryImpl(this._dataSource);

  @override
  Future<AppUser> signIn({required String email, required String password}) =>
      _dataSource.signIn(email: email, password: password);

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String phone,
    required String assignedGate,
    required String role,
    required String password,
  }) =>
      _dataSource.register(
        fullName: fullName,
        email: email,
        phone: phone,
        assignedGate: assignedGate,
        role: role,
        password: password,
      );

  @override
  Future<void> forgotPassword(String email) => _dataSource.forgotPassword(email);

  @override
  Future<bool> verifyOtp({required String email, required String otp}) =>
      _dataSource.verifyOtp(email: email, otp: otp);

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<AppUser?> getCurrentUser() => _dataSource.getCurrentUser();
}
