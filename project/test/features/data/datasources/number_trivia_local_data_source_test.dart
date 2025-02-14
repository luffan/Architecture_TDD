import 'dart:convert';

import 'package:architecture_tdd/core/error/exceptions.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/constants/local_source_constants.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/interfaces/number_trivia_local_data_source.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source_impl.dart';
import 'package:architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../fixtures/fixture_reader.dart';
import './number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(
    () {
      mockSharedPreferences = MockSharedPreferences();
      dataSource = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
    },
  );

  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
          json.decode(fixture('trivia_cached.json')));

      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('trivia_cached.json'));

          final result = await dataSource.getLastNumberTrivia();

          verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should return a CacheException when there is not a cached value',
        () async {
          when(mockSharedPreferences.getString(any)).thenReturn(null);

          final call = dataSource.getLastNumberTrivia;

          expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        },
      );
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel(
        text: 'text trivia',
        number: 1,
      );
      test(
        'should call SharedPreferences to cache the data',
        () async {
          dataSource.cacheNumberTrivia(tNumberTriviaModel);

          final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

          verify(
            mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            ),
          );
        },
      );
    },
  );
}
