import 'package:architecture_tdd/core/error/failures.dart';
import 'package:architecture_tdd/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);

  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
