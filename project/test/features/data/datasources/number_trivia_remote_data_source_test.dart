import 'dart:convert';

import 'package:architecture_tdd/core/error/exeptions.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

import '../../../fixtures/fixture_reader.dart';
import './number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockDio mockDio;

  setUp(
    () {
      mockDio = MockDio();
      mockDio.options = DIO_OPTIONS;
      dataSource = NumberTriviaRemoteDataSourceImpl(mockDio);
    },
  );

  void setUpMockDioSuccess200() {
    when(mockDio.get(any)).thenAnswer(
      (_) async => Response(
        data: fixture('trivia.json'),
        requestOptions: RequestOptions(),
        statusCode: 200,
      ),
    );
  }

  void setUpMockDioFailure404() {
    when(mockDio.get(any)).thenAnswer(
      (_) async => Response(
        data: 'Something went wrong',
        requestOptions: RequestOptions(),
        statusCode: 404,
      ),
    );
  }

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia.json')),
      );

      test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
          setUpMockDioSuccess200();

          dataSource.getConcreteNumberTrivia(tNumber);

          verify(
            mockDio.get(
              '/$tNumber',
            ),
          );
        },
      );

      test(
        'should return NumberTrivia when the response code is 200 (success)',
        () async {
          setUpMockDioSuccess200();

          final result = await dataSource.getConcreteNumberTrivia(tNumber);

          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
          setUpMockDioFailure404();

          final call = dataSource.getConcreteNumberTrivia;

          expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
        },
      );
    },
  );

  group(
    'getRandomNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
        json.decode(fixture('trivia.json')),
      );

      test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
          setUpMockDioSuccess200();

          dataSource.getRandomNumberTrivia();

          verify(
            mockDio.get(
              '/random',
            ),
          );
        },
      );

      test(
        'should return NumberTrivia when the response code is 200 (success)',
        () async {
          setUpMockDioSuccess200();

          final result = await dataSource.getRandomNumberTrivia();

          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should perform a GET request on a URL with number being the endpoint and with application/json header',
        () async {
          setUpMockDioFailure404();

          final call = dataSource.getRandomNumberTrivia;

          expect(() => call(), throwsA(TypeMatcher<ServerException>()));
        },
      );
    },
  );
}
