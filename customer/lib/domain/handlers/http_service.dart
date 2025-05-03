import 'package:dingtea/app_constants.dart';
import 'package:dio/dio.dart';

import 'token_interceptor.dart';

class HttpService {
  Dio client(
          {bool requireAuth = false,
          bool routing = false,
          bool chatGpt = false}) =>
      Dio(
        BaseOptions(
          baseUrl: chatGpt
              ? "https://api.openai.com"
              : routing
                  ? AppConstants.drawingBaseUrl
                  : AppConstants.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
          headers: {
            'Accept':
                'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
            'Content-type': 'application/json'
          },
        ),
      )
        ..interceptors
            .add(TokenInterceptor(requireAuth: requireAuth, chatGPT: chatGpt))
        ..interceptors.add(LogInterceptor(
            responseHeader: false,
            requestHeader: true,
            responseBody: true,
            requestBody: true));
}
