import 'package:architecture_tdd/core/error/failures.dart';
import 'package:architecture_tdd/core/util/input_converter.dart';
import 'package:architecture_tdd/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>(),
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      final tNumberString = '1';

      final tNumberParsed = int.parse(tNumberString);

      final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

      blocTest(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        build: () => bloc,
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [],
        verify: (_) => verify(mockInputConverter.stringToUnsignedInteger(tNumberString)),
      );

      blocTest(
        'should emit [Error] when the input is invalid',
        build: () => bloc,
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [
          Error(message: invalidInputFailureMessage),
        ],
      );
    },
  );
}
