import 'package:architecture_tdd/features/number_trivia/data/data_sources/constants/remote_source_constants.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RemoteSourceProvider {
  @singleton
  Dio dio() {
    Dio dio = Dio();
    dio.options = dioClientOptions;
    return dio;
  }
}