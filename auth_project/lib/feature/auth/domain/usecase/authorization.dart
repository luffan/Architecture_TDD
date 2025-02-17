import 'package:auth_project/core/error/failures.dart';
import 'package:auth_project/core/usecase/usecase.dart';
import 'package:auth_project/feature/auth/domain/entity/auth_user.dart';
import 'package:auth_project/feature/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class Authorization implements UseCase<AuthUser, NoParams> {
  final AuthRepository _authRepository;

  Authorization(this._authRepository);

  @override
  Future<Either<Failure, AuthUser>> call(NoParams params) {
    return _authRepository.authorization();
  }
}
