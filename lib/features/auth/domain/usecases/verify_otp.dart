import '../repositories/auth_repository.dart';

class VerifyOtp {
  final AuthRepository _repository;
  const VerifyOtp(this._repository);

  Future<bool> call({required String email, required String otp}) =>
      _repository.verifyOtp(email: email, otp: otp);
}
