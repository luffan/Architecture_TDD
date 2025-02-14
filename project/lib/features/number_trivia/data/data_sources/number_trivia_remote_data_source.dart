import 'dart:convert';

import 'package:architecture_tdd/core/error/exeptions.dart';
import 'package:architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServiceException] for all error codes
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServiceException] for all error codes
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

BaseOptions DIO_OPTIONS = BaseOptions(
  baseUrl: 'http://numbersapi.com',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
  headers: {},
  contentType: 'application/json; charset=utf-8',
  responseType: ResponseType.json,
);

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final Dio dio;

  NumberTriviaRemoteDataSourceImpl(this.dio);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromUrl('/$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl('/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.data));
    } else {
      throw ServerException();
    }
  }
}
