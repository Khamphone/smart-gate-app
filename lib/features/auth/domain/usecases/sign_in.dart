import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository _repository;
  const SignIn(this._repository);

  Future<AppUser> call({required String email, required String password}) =>
      _repository.signIn(email: email, password: password);
}
