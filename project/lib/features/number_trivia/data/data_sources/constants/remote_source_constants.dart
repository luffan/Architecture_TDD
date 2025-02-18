import 'package:dio/dio.dart';

final dioClientOptions = BaseOptions(
  baseUrl: 'http://numbersapi.com',
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
  headers: {},
  contentType: 'application/json; charset=utf-8',
  responseType: ResponseType.json,
);
