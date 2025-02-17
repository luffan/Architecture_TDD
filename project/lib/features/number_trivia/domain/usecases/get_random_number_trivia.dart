import 'package:architecture_tdd/core/error/failures.dart';
import 'package:architecture_tdd/core/usecases/usecase.dart';
import 'package:architecture_tdd/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Singleton()
class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await repository.getRandomNumberTrivia();
  }
}
