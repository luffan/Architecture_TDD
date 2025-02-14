import 'dart:convert';

import 'package:architecture_tdd/core/error/exceptions.dart';
import 'package:architecture_tdd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dio/dio.dart';

import 'interfaces/number_trivia_remote_data_source.dart';

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
