import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repository;
  const RegisterUser(this._repository);

  Future<AppUser> call({
    required String fullName,
    required String email,
    required String phone,
    required String assignedGate,
    required String role,
    required String password,
  }) =>
      _repository.register(
        fullName: fullName,
        email: email,
        phone: phone,
        assignedGate: assignedGate,
        role: role,
        password: password,
      );
}
