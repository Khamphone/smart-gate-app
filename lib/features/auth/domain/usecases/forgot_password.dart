import '../repositories/auth_repository.dart';

class ForgotPassword {
  final AuthRepository _repository;
  const ForgotPassword(this._repository);

  Future<void> call(String email) => _repository.forgotPassword(email);
}
