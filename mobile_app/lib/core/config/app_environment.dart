import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppEnvironment {
  const AppEnvironment({required this.apiBaseUrl});

  final String apiBaseUrl;

  String get assetBaseUrl {
    return apiBaseUrl.replaceFirst(RegExp(r'/api/?$'), '');
  }

  String assetUrl(String path) => '$assetBaseUrl/assets/${path.replaceFirst(RegExp(r'^/+'), '')}';

      factory AppEnvironment.fromDartDefine() {
      const envUrl = String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: '',
      );

      String baseUrl;

      if (envUrl.isNotEmpty) {
        baseUrl = envUrl;
      } else {
        baseUrl = 'http://127.0.0.1/MobileComputingUAS/api/';

        if (!kIsWeb) {
          try {
            if (Platform.isAndroid) {
              baseUrl = 'http://10.0.2.2/MobileComputingUAS/api/';
            }
          } catch (_) {}
        }
      }

      final normalizedBaseUrl =
          baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

      return AppEnvironment(apiBaseUrl: normalizedBaseUrl);
    }
}
