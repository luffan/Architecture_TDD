import 'package:auth_project/core/error/failures.dart';
import 'package:auth_project/feature/auth/domain/entity/auth_user.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> authorization();
}