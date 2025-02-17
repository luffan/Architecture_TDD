import 'package:architecture_tdd/core/error/failures.dart';
import 'package:architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

extension FailureExtension on Failure {
  String toMessage() {
    switch(runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected failure';
    }
  }
}