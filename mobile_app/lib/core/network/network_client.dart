import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

class NetworkClient {
  NetworkClient({required String baseUrl})
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeoutMs),
            receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeoutMs),
            headers: {'Accept': 'application/json'},
          ),
        );

  final Dio dio;
}
