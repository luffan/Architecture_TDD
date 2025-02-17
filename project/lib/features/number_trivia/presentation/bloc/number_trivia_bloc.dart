import 'package:architecture_tdd/core/error/failures.dart';
import 'package:architecture_tdd/core/usecases/usecase.dart';
import 'package:architecture_tdd/core/util/input_converter.dart';
import 'package:architecture_tdd/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/presentation/util/failure_util.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

@Injectable()
class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) {
      final inputEither =
          inputConverter.stringToUnsignedInteger(event.numberString);

      inputEither.fold(
        (failure) {
          emit(Error(message: invalidInputFailureMessage));
        },
        (integer) async {
          emit(Loading());
          final result = await getConcreteNumberTrivia(Params(number: integer));
          _emitLoadedOrErrorState(result, emit);
        },
      );
    });

    on<GetTriviaForRandomNumber>((event, emit) async {
      emit(Loading());
      final result = await getRandomNumberTrivia(NoParams());
      _emitLoadedOrErrorState(result, emit);
    });
  }

  void _emitLoadedOrErrorState(
    Either<Failure, NumberTrivia> numberEither,
    Emitter<NumberTriviaState> emit,
  ) {
    numberEither.fold(
      (failure) => emit(
        Error(
          message: failure.toMessage(),
        ),
      ),
      (integer) => emit(Loaded(trivia: integer)),
    );
  }
}
