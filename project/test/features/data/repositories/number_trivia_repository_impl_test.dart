import 'package:architecture_tdd/core/error/exeptions.dart';
import 'package:architecture_tdd/core/error/failures.dart';
import 'package:architecture_tdd/core/network/network_info.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:architecture_tdd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:architecture_tdd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:architecture_tdd/features/number_trivia/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import './number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaRemoteDataSource>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(
        number: tNumber,
        text: 'Test trivia',
      );

      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test(
        'should check if the device online',
        () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          repository.getConcreteNumberTrivia(tNumber);

          verify(mockNetworkInfo.isConnected);
        },
      );

      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
          () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenAnswer((_) async => tNumberTriviaModel);

            await repository.getConcreteNumberTrivia(tNumber);

            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
          () async {
            when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                .thenThrow(ServerException());

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestsOffline(() {
        test(
          'should return last locally cached data when the cached data is present',
          () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia.call());
            expect(result, equals(Right(tNumberTriviaModel)));
          },
        );

        test(
          'should return CacheFailure cached data when there is cached data present',
          () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repository.getConcreteNumberTrivia(tNumber);

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );

  group(
    'getRandomNumberTrivia',
        () {
      final tNumberTriviaModel = NumberTriviaModel(
        number: 132,
        text: 'Test trivia',
      );

      final NumberTrivia tNumberTrivia = tNumberTriviaModel;

      test(
        'should check if the device online',
            () async {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

          repository.getRandomNumberTrivia();

          verify(mockNetworkInfo.isConnected);
        },
      );

      runTestsOnline(() {
        test(
          'should return remote data when the call to remote data source is successful',
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getRandomNumberTrivia();

            verify(mockRemoteDataSource.getRandomNumberTrivia());
            expect(result, equals(Right(tNumberTrivia)));
          },
        );

        test(
          'should cache the data locally when the call to remote data source is successful',
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            await repository.getRandomNumberTrivia();

            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
          },
        );

        test(
          'should return server failure when the call to remote data source is unsuccessful',
              () async {
            when(mockRemoteDataSource.getRandomNumberTrivia())
                .thenThrow(ServerException());

            final result = await repository.getRandomNumberTrivia();

            verify(mockRemoteDataSource.getRandomNumberTrivia());
            verifyZeroInteractions(mockLocalDataSource);
            expect(result, equals(Left(ServerFailure())));
          },
        );
      });

      runTestsOffline(() {
        test(
          'should return last locally cached data when the cached data is present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);

            final result = await repository.getRandomNumberTrivia();

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia.call());
            expect(result, equals(Right(tNumberTriviaModel)));
          },
        );

        test(
          'should return CacheFailure cached data when there is cached data present',
              () async {
            when(mockLocalDataSource.getLastNumberTrivia())
                .thenThrow(CacheException());

            final result = await repository.getRandomNumberTrivia();

            verifyZeroInteractions(mockRemoteDataSource);
            verify(mockLocalDataSource.getLastNumberTrivia());
            expect(result, equals(Left(CacheFailure())));
          },
        );
      });
    },
  );
}
